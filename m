Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9F94D8CE;
	Tue, 30 Sep 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244342; cv=none; b=aNWjE+8Z74bU7KEFkEBK9+uXb5REzfj18IYlkojFL+ImRmg5dyF9P/WFlsNr2ogjMNCKnxPI0tY6IZpFbAWiBI3iULntP+v2OGqrxqiJncKCn+7Hqo+/te7tVm3TOUx+Ywd6r/c6czdDx0lioLJFuUmJ+vznYlFhC0SLxXMFuEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244342; c=relaxed/simple;
	bh=3BXU2vEiBL1d7SVcnGJBPMHQyFQEyC00bOgM1JLAnqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTyErsBWnncKV9Dkkt4rs9BV23Akd/RbX7+qQq8I3bB/BPCUNZQLSw9AgvKEVwPn4Z8SRkulwaQM+sH6iIPNonX9+mz1XKSp3oscJ/a1L/VTe8eTW1e1RcKWzwsbsLZTS6Vk8lGMYynbfaMKRzc/yl03Xhq1hDG1nZ9pyS3PmH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+91pr/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+91pr/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BF7C4CEF0;
	Tue, 30 Sep 2025 14:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244342;
	bh=3BXU2vEiBL1d7SVcnGJBPMHQyFQEyC00bOgM1JLAnqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+91pr/JAAws70/oCNpO0BqY4J++fVHS1k5NhkYbUevGGimuA5UwJw6V6SmBqGRGw
	 0Arj2Xb++ooeYrQuslnCmFhCiBGrAXKQc3SDC4tHtrBojH0TQsYOTFwp5Vtk9Dv3Yx
	 /EDU97Gh32s2FGUCdCZw7uVIBKhDbdeagFNb9ujo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/122] bnxt_en: correct offset handling for IPv6 destination address
Date: Tue, 30 Sep 2025 16:47:12 +0200
Message-ID: <20250930143827.120564199@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 3d3aa9472c6dd0704e9961ed4769caac5b1c8d52 ]

In bnxt_tc_parse_pedit(), the code incorrectly writes IPv6
destination values to the source address field (saddr) when
processing pedit offsets within the destination address range.

This patch corrects the assignment to use daddr instead of saddr,
ensuring that pedit operations on IPv6 destination addresses are
applied correctly.

Fixes: 9b9eb518e338 ("bnxt_en: Add support for NAT(L3/L4 rewrite)")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Link: https://patch.msgid.link/20250920121157.351921-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 775d0b7521ca0..ef2bd84c55ff5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -243,7 +243,7 @@ bnxt_tc_parse_pedit(struct bnxt *bp, struct bnxt_tc_actions *actions,
 			   offset < offset_of_ip6_daddr + 16) {
 			actions->nat.src_xlate = false;
 			idx = (offset - offset_of_ip6_daddr) / 4;
-			actions->nat.l3.ipv6.saddr.s6_addr32[idx] = htonl(val);
+			actions->nat.l3.ipv6.daddr.s6_addr32[idx] = htonl(val);
 		} else {
 			netdev_err(bp->dev,
 				   "%s: IPv6_hdr: Invalid pedit field\n",
-- 
2.51.0



