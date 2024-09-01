Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A5F17E00C;
	Sun,  1 Sep 2024 16:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209086; cv=none; b=OmEmLskjrdagIvuxczHZku6epQYttbZYAwNQJYxuri/+OOG3BcnFmCjUWu2zzzUQhzcNVubhZJa8xstsD/8zBTgot9yH3WBe+qKp20/qUQpyfJ2dBA5McqEX1jlNrXSkoockC4t6WFV8jml51x28QMy4W3T/tddetqLHONfkbek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209086; c=relaxed/simple;
	bh=r4h7pHqMcKo3M7ktPkgyOxOxlpVfb4/NrFD0JtFvn9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb4+LZ/4m27RVrHPelNjauqayxdhJh1RRP4ct7F5Fl+YRHc4nDly+rWq2R4te6X1e2KCyNaLnFbAHW9KH1YXoqBgrlkIc01bxfuKPEmy8Piv8rkOTu0r2muIcaIp1Va69hRLiQYljMzeA/7YRlTwGLUenkVFHKlWB/ryatMJY/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FptuRMTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FptuRMTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C41C4CEC3;
	Sun,  1 Sep 2024 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209086;
	bh=r4h7pHqMcKo3M7ktPkgyOxOxlpVfb4/NrFD0JtFvn9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FptuRMTkadiKmmVAiB6+fWmlcfZGKIHV47oawalGluwcZJTxbnH+fXdqhCQcF4/LJ
	 mG03Wk0R7748HQjlotr0COA5ckhZaaC/MV3uqB4/SDhBoGdiFPGSIsgxzx3drn7U+d
	 uBhXi54cvRZVph9tnSbT8Oq3liHNC1lin0REZri4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Lars Poeschel <poeschel@lemonage.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/134] nfc: pn533: Add dev_up/dev_down hooks to phy_ops
Date: Sun,  1 Sep 2024 18:17:48 +0200
Message-ID: <20240901160814.672236778@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars Poeschel <poeschel@lemonage.de>

[ Upstream commit 0bf2840ccc6efcba82d83b224dcde19dea9f1ee3 ]

This adds hooks for dev_up and dev_down to the phy_ops. They are
optional.
The idea is to inform the phy driver when the nfc chip is really going
to be used. When it is not used, the phy driver can suspend it's
interface to the nfc chip to save some power. The nfc chip is considered
not in use before dev_up and after dev_down.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: febccb39255f ("nfc: pn533: Add poll mod list filling check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 12 +++++++++++-
 drivers/nfc/pn533/pn533.h |  9 +++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 1e90ff17f87db..c36cd68b47eb5 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2465,6 +2465,9 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 
+	if (dev->phy_ops->dev_up)
+		dev->phy_ops->dev_up(dev);
+
 	if (dev->device_type == PN533_DEVICE_PN532) {
 		int rc = pn532_sam_configuration(nfc_dev);
 
@@ -2477,7 +2480,14 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 
 static int pn533_dev_down(struct nfc_dev *nfc_dev)
 {
-	return pn533_rf_field(nfc_dev, 0);
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+	int ret;
+
+	ret = pn533_rf_field(nfc_dev, 0);
+	if (dev->phy_ops->dev_down && !ret)
+		dev->phy_ops->dev_down(dev);
+
+	return ret;
 }
 
 static struct nfc_ops pn533_nfc_ops = {
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 8bf9d6ece0f50..570ee0a3e832b 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -207,6 +207,15 @@ struct pn533_phy_ops {
 			  struct sk_buff *out);
 	int (*send_ack)(struct pn533 *dev, gfp_t flags);
 	void (*abort_cmd)(struct pn533 *priv, gfp_t flags);
+	/*
+	 * dev_up and dev_down are optional.
+	 * They are used to inform the phy layer that the nfc chip
+	 * is going to be really used very soon. The phy layer can then
+	 * bring up it's interface to the chip and have it suspended for power
+	 * saving reasons otherwise.
+	 */
+	void (*dev_up)(struct pn533 *priv);
+	void (*dev_down)(struct pn533 *priv);
 };
 
 
-- 
2.43.0



