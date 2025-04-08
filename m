Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D22264A76;
	Tue,  8 Apr 2025 11:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110927; cv=none; b=tmIQiRyPp1CPc6MwBO6S1GUUTLwO+2oemRNkFEElyU/29zzMNXGEDa6Viqv4zgcmJOtt2ngbRpUCLdZX/VffUtZlkCGB1xKPzI5NoZ+XsCdA02H9M9UKVsOtwaAgYm4wv1QzolZ7bjKq5xHuX8z0DMISQO5ly+2lzarZWDDJEtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110927; c=relaxed/simple;
	bh=CEmU6KaqdQo28JL990GUe1EUBwPlvOQHh0MW9TkcpuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMHJJHhGn4kFxVHQUDDtkZDdmwQXB+s0d2uXyexEW9IFhObn3N5e5ujr+B9Fx8lfIQAqyaTsXRD33t2hTRAALJjG7300E/c3Qk4qHE2tO2d8PD99zC6QVyN3kM+oK1lngQH7vfkVYO8EcbnuFd1YNPuDRGL2WHSGl9cXyeLfcLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUO+CQ8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUO+CQ8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26343C4CEE5;
	Tue,  8 Apr 2025 11:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110927;
	bh=CEmU6KaqdQo28JL990GUe1EUBwPlvOQHh0MW9TkcpuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUO+CQ8hhD7vQ5LQVr+wiA/Wy5OtIevT+MOh/e6iAxJEakJYOTuG63bkTQ3I/2UVH
	 o8H5h4TWu2JcPBpXvZkMOeF3JVSLDyDUdtDJ7IolqLOiGpFj6a5WxnCF5tEgiIvNdO
	 xAWlzHAJcJGda57V5eRq1jQpnPrnwbncPYzA7Uy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 245/731] net: dsa: sja1105: fix kasan out-of-bounds warning in sja1105_table_delete_entry()
Date: Tue,  8 Apr 2025 12:42:22 +0200
Message-ID: <20250408104919.982030833@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5f2b28b79d2d1946ee36ad8b3dc0066f73c90481 ]

There are actually 2 problems:
- deleting the last element doesn't require the memmove of elements
  [i + 1, end) over it. Actually, element i+1 is out of bounds.
- The memmove itself should move size - i - 1 elements, because the last
  element is out of bounds.

The out-of-bounds element still remains out of bounds after being
accessed, so the problem is only that we touch it, not that it becomes
in active use. But I suppose it can lead to issues if the out-of-bounds
element is part of an unmapped page.

Fixes: 6666cebc5e30 ("net: dsa: sja1105: Add support for VLAN operations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250318115716.2124395-4-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_static_config.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 3d790f8c6f4da..ffece8a400a66 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -1917,8 +1917,10 @@ int sja1105_table_delete_entry(struct sja1105_table *table, int i)
 	if (i > table->entry_count)
 		return -ERANGE;
 
-	memmove(entries + i * entry_size, entries + (i + 1) * entry_size,
-		(table->entry_count - i) * entry_size);
+	if (i + 1 < table->entry_count) {
+		memmove(entries + i * entry_size, entries + (i + 1) * entry_size,
+			(table->entry_count - i - 1) * entry_size);
+	}
 
 	table->entry_count--;
 
-- 
2.39.5



