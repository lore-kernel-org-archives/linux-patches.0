Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C11F7580;
	Mon, 23 Jun 2025 22:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716654; cv=none; b=UAlHlix0WkNNePsDjiy/Epy9V6mDdvrls0JjllkBAkRT5RX1D24ztA+xJ9BPIkYqrMR67xmWdMejzgeYT5APK3d12i+3IbdSq4GpywzhGQaO6pGbhrd/iTFrhxHTrSrSiIkNQL2R3zKdViQgnHILbu2DMvhsFVqIBqtVdiOx/bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716654; c=relaxed/simple;
	bh=obGHq2lTw32fpqjrNLFgi9wwM9p55lZtSPR/o/+gvJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZM1bbSKYD2n1hS7dRLqafRVg6huu/hZIBIgLq2yWKv81q/WS4EoJtCS0pT5mx91MjqFF5kXXe+yymH7ET9gNd8qfAFUEPK23+1s1v5FcAK565eqKJ8xuoKFtEQ/OPO57p/gk/7eOa8TncTlDStC3DF5e7AIcvIk6RGwjUFTjvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7AYYSJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7AYYSJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8D2C4CEEA;
	Mon, 23 Jun 2025 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716654;
	bh=obGHq2lTw32fpqjrNLFgi9wwM9p55lZtSPR/o/+gvJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7AYYSJf6A2ns1HeHbr49O0ILcbo0JIrdaSZP1eVlXNYiEQXUyNQii2Gb5CsTiqmd
	 rZARbpzntH65s8Do1PuF7/Li8SeBDkV0FZcP+vOd/S9XnjJ7xCfqavJPidq8eWDpEN
	 zx7NbLXLKh99VLOV5qwi8hV5PPif9H22XharEqPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/414] software node: Correct a OOB check in software_node_get_reference_args()
Date: Mon, 23 Jun 2025 15:06:39 +0200
Message-ID: <20250623130648.585564644@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 31e4e12e0e9609850cefd4b2e1adf782f56337d6 ]

software_node_get_reference_args() wants to get @index-th element, so
the property value requires at least '(index + 1) * sizeof(*ref)' bytes
but that can not be guaranteed by current OOB check, and may cause OOB
for malformed property.

Fix by using as OOB check '((index + 1) * sizeof(*ref) > prop->length)'.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250414-fix_swnode-v2-1-9c9e6ae11eab@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index eb6eb25b343ba..53b3f0061ad12 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -529,7 +529,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if (index * sizeof(*ref) >= prop->length)
+	if ((index + 1) * sizeof(*ref) > prop->length)
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.39.5



