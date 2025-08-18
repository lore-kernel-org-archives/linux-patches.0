Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9BB335BAA;
	Mon, 18 Aug 2025 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524992; cv=none; b=NKhifwiTyg3OTDyG0qy4Ny610rfhXyPPtthuAr0Zvzux2+dLkieXf0bp8PndL2VKXF/NYelnJc0WqiEgngoosXqT1Iw1Sy5+kwXplwuq+oWL+KOX181zW4K/gRGkrCE7AA3c3cAk99AnCsfcMgBPtdATi3p73L7EjIx3LTsiHRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524992; c=relaxed/simple;
	bh=2ZaTOQA3oIkvM7ZY6AiqELhnFFg3+EdhhA+H4ivoXw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0po9BSBKSIOu2x/6QYy245qyBp9zDeh4iF5iCeQlalg/vo64TnzL+BZElco1KPHbJIlkmoMe6lcTLhXbZGhB3OiEqt+gdWzNcwZd8+8shKgWCpi0xp93GUHZMpB7H6up7xCaFaArxR/GcEHIhaIilAHwJTjNzzoBYiT/o73kvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gf3mqthp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gf3mqthp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DDFC4CEEB;
	Mon, 18 Aug 2025 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524991;
	bh=2ZaTOQA3oIkvM7ZY6AiqELhnFFg3+EdhhA+H4ivoXw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gf3mqthpnCH/9rTkHNMDX13bmZoJNTDx99R5mWIyJYcUSKg/Cdko5rwrZd84tNczt
	 njChBj2JccBbQD9s9IWKSzHvyL28prMesgIyj5a2Dmd/TsWzAusON55Q3G/pPPVbEF
	 9O4H0H1x5veqzr4jjxi1W7/ATEgu+jMijJ/H8aSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 125/570] staging: gpib: Add init response codes for new ni-usb-hs+
Date: Mon, 18 Aug 2025 14:41:52 +0200
Message-ID: <20250818124510.634461462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit f50d5e0c1f80d004510bf77cb0e1759103585c00 ]

A new version of a bona fide genuine NI-USB-HS+ adaptor
sends new response codes to the initialization sequence.

Add the checking for these response codes to suppress
console warning messages.

Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250722164810.2621-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index 7cf25c95787f..73ea72f34c0a 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -2079,10 +2079,10 @@ static int ni_usb_hs_wait_for_ready(struct ni_usb_priv *ni_priv)
 		}
 		if (buffer[++j] != 0x0) { // [6]
 			ready = 1;
-			// NI-USB-HS+ sends 0xf here
+			// NI-USB-HS+ sends 0xf or 0x19 here
 			if (buffer[j] != 0x2 && buffer[j] != 0xe && buffer[j] != 0xf &&
-			    buffer[j] != 0x16)	{
-				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x2, 0xe, 0xf or 0x16\n",
+			    buffer[j] != 0x16 && buffer[j] != 0x19) {
+				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x2, 0xe, 0xf, 0x16 or 0x19\n",
 					j, (int)buffer[j]);
 				unexpected = 1;
 			}
@@ -2110,11 +2110,11 @@ static int ni_usb_hs_wait_for_ready(struct ni_usb_priv *ni_priv)
 				j, (int)buffer[j]);
 			unexpected = 1;
 		}
-		if (buffer[++j] != 0x0) {
+		if (buffer[++j] != 0x0) { // [10] MC usb-488 sends 0x7 here, new HS+ sends 0x59
 			ready = 1;
-			if (buffer[j] != 0x96 && buffer[j] != 0x7 && buffer[j] != 0x6e) {
-// [10] MC usb-488 sends 0x7 here
-				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x96, 0x07 or 0x6e\n",
+			if (buffer[j] != 0x96 && buffer[j] != 0x7 && buffer[j] != 0x6e &&
+			    buffer[j] != 0x59) {
+				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x96, 0x07, 0x6e or 0x59\n",
 					j, (int)buffer[j]);
 				unexpected = 1;
 			}
-- 
2.39.5



