Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D97DBA34;
	Mon,  6 Jan 2025 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179131; cv=none; b=fdhpfGsW+UadQ5OlLjKZRjfTpv6F/Fw1TVlp079KeuBJ1L5ufI9/oeDyTvrEDyguqcCRx8A0zQCz5XxTDLZ2CLtstLnLdzNuZHUqZ8qa+3ty1OM5wTUirrmNPYPxmNLWa5g7q4wnnnJrESZPnDC/U6CavvvzP+WOvhKKp5v0Qc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179131; c=relaxed/simple;
	bh=/U8NJTAwZQMZmxUU97oEYdbfOvsh+km0LtNaMolrYWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1VV4bABhyvAre1oz3SXEBOyoLSKJrn2Vfxp4TrIITNHspnHpC73sBVhc1VZHXGV7SMRAFyI2YD1GHNOEX7w1QtRSRZSJp6LY6MwHkl9GUMi7/ZUpuQzUp9jiJGQQ0qaFkDJOdmaL7LKJ2EWVpG+D367xUeXH7OdrIuaNe2joLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxMc6QdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxMc6QdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D294C4CEEB;
	Mon,  6 Jan 2025 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179130;
	bh=/U8NJTAwZQMZmxUU97oEYdbfOvsh+km0LtNaMolrYWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxMc6QdBLNX+UnMAe6saIZyMS/O0/RgshwStfq7RxqSZ4hvWVyfUV8w5ZDZ9lLXX5
	 PT5+Jc1pHmERp1+HZ9iT66UwfzGB7D7H+vIv9HA6EIqwCrFc6I8MwET0DizfHVrMsF
	 ijHuxi4Ve0OYcKtLlZmetJAoE9yr/nDAPpV9bIaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 36/93] mtd: diskonchip: Cast an operand to prevent potential overflow
Date: Mon,  6 Jan 2025 16:17:12 +0100
Message-ID: <20250106151130.064855333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

commit 9b458e8be0d13e81ed03fffa23f8f9b528bbd786 upstream.

There may be a potential integer overflow issue in inftl_partscan().
parts[0].size is defined as "uint64_t"  while mtd->erasesize and
ip->firstUnit are defined as 32-bit unsigned integer. The result of
the calculation will be limited to 32 bits without correct casting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/diskonchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -1221,7 +1221,7 @@ static inline int __init inftl_partscan(
 		    (i == 0) && (ip->firstUnit > 0)) {
 			parts[0].name = " DiskOnChip IPL / Media Header partition";
 			parts[0].offset = 0;
-			parts[0].size = mtd->erasesize * ip->firstUnit;
+			parts[0].size = (uint64_t)mtd->erasesize * ip->firstUnit;
 			numparts = 1;
 		}
 


