Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3EA217F55;
	Tue, 30 Sep 2025 15:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245501; cv=none; b=ClIt42M92O/5meAlFYBf7CgIP1e4DMaXpFYaVgH36iBcyvbMTmt8/KMmoCbnZoUUGltcS/bIKkyVN1AMiibUA/1LwsMJQoymgZmx3pMspPxgeOLRDyZ0a2yaafahSQ09dLvUEav+EjVzyiLk22gKSuC1Fpn1oMTqCnhvKp6PgEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245501; c=relaxed/simple;
	bh=4wyVwS+lQUoNtHjJ4ftAOhtA7bqsPdaJwdKiODWTSUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vh5lMicv7oCrUABgv/3Hni7KKmZU4Xw5zrwUfv+sqiBYzbp09wTe6462Frh995vKeqSODreQuf2f/8aJ+Pm7/CKPwRQWA3J7RgGw8fO/q+bobnalW3R4R0LDcD/5TEvFubhOr7CEDz64q1WWxZjlDkjW0/EJmNrIJzJ5iw3T+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT31R2Y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT31R2Y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106A3C4CEF0;
	Tue, 30 Sep 2025 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245501;
	bh=4wyVwS+lQUoNtHjJ4ftAOhtA7bqsPdaJwdKiODWTSUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GT31R2Y/UL9yweJils4EwZ3AE+vjQUUCF3CxZPTPYQIH0+QrKTRtZrgWa8GULvn7R
	 jgMcsts8YJHUCjyFKs2wnsLniolhQHDzMSqx8LD01OM9FE1961Aa4HWYKUQUKOr18f
	 3N2wuLZ3pY5X6VKDsUFrR2tT8ILpn1OF6C1nuUqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/73] bnxt_en: correct offset handling for IPv6 destination address
Date: Tue, 30 Sep 2025 16:47:41 +0200
Message-ID: <20250930143822.131466692@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4d6663ff84722..72677d140a888 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -244,7 +244,7 @@ bnxt_tc_parse_pedit(struct bnxt *bp, struct bnxt_tc_actions *actions,
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



