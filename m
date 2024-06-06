Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738FC1AED31;
	Thu,  6 Jun 2024 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683341; cv=none; b=CZu3ictC/D0/ev83TnmlPyZsx7CRVXx5FDNwpYKYG5Qjj0TPSfOySJEGRnWA1oOONu8QgbAX9uP7juIIeLrcLvaKWTEka2+Z9/WxATzQ4gI5MMMOCrAm4+yA2mkqwGoxpEOWJ0Fsm+JzbNablBohaH5qOUvRgkvd0W1zgosHOsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683341; c=relaxed/simple;
	bh=c3BGmr0cVSEc9Wv5s80mKlTv5D5HQGAJBJysXrzGYjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZHKkm9uRzkxo1M1BfXvZXN9PGLSrmk+lUiAO5E63ZXCmtzGg/eKMVJPw73Cu6e9vUUlkwMTOXupXg8bQARqs8sSXYejqS5sDyOukaqjqjhsb7kikQP2OLEeEE3Ar7SYM0FOUnWzKlBG0mwdYtE6+JPExmGYLNIHgTGeLkCcFxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mluILfJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mluILfJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D9AC2BD10;
	Thu,  6 Jun 2024 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683341;
	bh=c3BGmr0cVSEc9Wv5s80mKlTv5D5HQGAJBJysXrzGYjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mluILfJoIxqQMdXe5qd23gr6TR3kFdWzyab/NI/1IyOx16paG+xRYGB6mdkiLRyPZ
	 qN3s+uo0ZaEu7PPBQd2uDnXAh9EcMkp/GVBRrFPPrIZLe9YVF0Cah7k89lKsBovf0b
	 YYRbZU6Z5uIAqOwCi408LtDT59cSMhv3dvQZPJZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aapo Vienamo <aapo.vienamo@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/744] mtd: core: Report error if first mtd_otp_size() call fails in mtd_otp_nvmem_add()
Date: Thu,  6 Jun 2024 15:59:14 +0200
Message-ID: <20240606131741.453020967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aapo Vienamo <aapo.vienamo@linux.intel.com>

[ Upstream commit d44f0bbbd8d182debcce88bda55b05269f3d33d6 ]

Jump to the error reporting code in mtd_otp_nvmem_add() if the
mtd_otp_size() call fails. Without this fix, the error is not logged.

Signed-off-by: Aapo Vienamo <aapo.vienamo@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240313173425.1325790-2-aapo.vienamo@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 5c32208b17a1d..97ca2a897f1d4 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -955,8 +955,10 @@ static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 
 	if (mtd->_get_user_prot_info && mtd->_read_user_prot_reg) {
 		size = mtd_otp_size(mtd, true);
-		if (size < 0)
-			return size;
+		if (size < 0) {
+			err = size;
+			goto err;
+		}
 
 		if (size > 0) {
 			nvmem = mtd_otp_nvmem_register(mtd, "user-otp", size,
-- 
2.43.0



