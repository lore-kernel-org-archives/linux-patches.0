Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0200C2F8BE7;
	Tue, 12 Aug 2025 17:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021403; cv=none; b=IDJX9vAb80Kyy/7Rl9LHZ8vLAKIlx2VJ3U4F0hqCbfAwJ4RPkuT+xB5uAHWng2eqnpJ5tv8k6SwYreK6JfJQWdoIU8lMZ1jGSr50xYcPO9UZ5ATVJRf0NX1NkwLVo3MmeeiNghnlhYZC53L1QZlo1bzcSVvppnSkc12wji7ZpAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021403; c=relaxed/simple;
	bh=Sm6Y4WsetivurHkKZZ1muCCAWIZL3UbYG7eenb811Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJnx3GMBHlg/XQnko91QfLE19JDSXfE+4A6KYRJ7o4A03MvdZiLce1PEiKRG2SZgU4zQKf57/cblRfVK5Btnxl8werJ6/lfb1/iMCvc0Yza7EkMwwfkUZ21uHrEnbvEcePbDRfPILFOnDN65MymlCHJCfB3P203yqQkQtG3t/xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFTmR+7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFTmR+7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B1CC4CEF0;
	Tue, 12 Aug 2025 17:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021402;
	bh=Sm6Y4WsetivurHkKZZ1muCCAWIZL3UbYG7eenb811Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFTmR+7dGizIojhoK4tTmPb9pLiPFm9omYl9vKmcIq9O3mcq+CNOU1QAdVLhc7OaM
	 CqXhlE3YaP9iebdwVT+s/qJBv4lAKJJoCq8n37c3g3EUuzNwEte1PveA3/tLfVaPRe
	 1Upe96EWUuEW4OkkYKgY4x5p+yTmq8zj1QfN7H9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/262] mtd: fix possible integer overflow in erase_xfer()
Date: Tue, 12 Aug 2025 19:28:19 +0200
Message-ID: <20250812172957.821408974@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Stepchenko <sid@itb.spb.ru>

[ Upstream commit 9358bdb9f9f54d94ceafc650deffefd737d19fdd ]

The expression '1 << EraseUnitSize' is evaluated in int, which causes
a negative result when shifting by 31 - the upper bound of the valid
range [10, 31], enforced by scan_header(). This leads to incorrect
extension when storing the result in 'erase->len' (uint64_t), producing
a large unexpected value.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ftl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 8c22064ead38..f2bd1984609c 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -344,7 +344,7 @@ static int erase_xfer(partition_t *part,
             return -ENOMEM;
 
     erase->addr = xfer->Offset;
-    erase->len = 1 << part->header.EraseUnitSize;
+    erase->len = 1ULL << part->header.EraseUnitSize;
 
     ret = mtd_erase(part->mbd.mtd, erase);
     if (!ret) {
-- 
2.39.5



