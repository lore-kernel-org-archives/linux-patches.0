Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A7115FA81;
	Mon, 17 Aug 2026 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976315; cv=none; b=q4LHm9seuGrPnwg/lppyfZSIOSP4fF1uMs9fOj8lXV+rOz1COkagfBvpH33tE/EPzEW7I8IloM+o5f3ii8w/7myYU+81wAKUIScxlf7oWSFO+NEWzT9A0sSBrNoNPm2rNiXEHR1wXc0Q7p1/TA9A8C6sSA/gaScSbbc/qh4xlKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976315; c=relaxed/simple;
	bh=5hTwErZ9QMVI+lEnvr7eocPiAkuEqIH2Tgehm2i4YKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTfuYkPnLea7SzuSj7GY15NGqaMgdnqOPTxzLUPih/+svD9MYAg4aBmT1xY82e1sWNeSOX7i4OCs2B/myY1tMLxgetu5O1ruSf35xnb3sUWv5Bb+POVCeTjrE4DIrVHl7ldMn/oozeq/+ToOwVoE4GARAB1kfyJwjPPnWKzwYMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXJpp7cS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXJpp7cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEA31F000E9;
	Mon, 17 Aug 2026 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976313;
	bh=hOUhfXxC7LI0QIYWKDodU7CLq87WgKFup/eARKlK/R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXJpp7cS974R+TVEinXeWXNFoDnkgKtix6UJOL/fV2Xh1uwRRArYGQPYGH/rC9KfC
	 tSUCDkayjzx8tdR3nZlshgrRwtecGfAqmr/wd/KIkIvFU+i0hK7DzRckiyWP52DbHx
	 FezkxJAgoTPnZ8nRAeuhhMDuuQ0xkOIPONKZ+bWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadym Kochan <vkochan@marvell.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/389] net: marvell: prestera: try to load previous fw version
Date: Mon, 17 Aug 2026 15:32:50 +0200
Message-ID: <20260817132551.799775979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Vadym Kochan <vkochan@marvell.com>

[ Upstream commit 47f26018a414ff640527be4ca814168e0b71eaf3 ]

Lets try to load previous fw version in case the latest one is missing on
existing system.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8ae344eb540a ("net: prestera: validate firmware header length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/prestera/prestera_pci.c  | 83 ++++++++++++++-----
 1 file changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index be5677623455c..39cd3d5010147 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -16,6 +16,9 @@
 #define PRESTERA_SUPP_FW_MAJ_VER	2
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
+#define PRESTERA_PREV_FW_MAJ_VER	2
+#define PRESTERA_PREV_FW_MIN_VER	0
+
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
 
 #define PRESTERA_FW_HDR_MAGIC		0x351D9D06
@@ -166,6 +169,8 @@ struct prestera_fw_evtq {
 };
 
 struct prestera_fw {
+	struct prestera_fw_rev rev_supp;
+	const struct firmware *bin;
 	struct workqueue_struct *wq;
 	struct prestera_device dev;
 	u8 __iomem *ldr_regs;
@@ -576,25 +581,24 @@ static void prestera_fw_rev_parse(const struct prestera_fw_header *hdr,
 static int prestera_fw_rev_check(struct prestera_fw *fw)
 {
 	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
-	u16 maj_supp = PRESTERA_SUPP_FW_MAJ_VER;
-	u16 min_supp = PRESTERA_SUPP_FW_MIN_VER;
 
-	if (rev->maj == maj_supp && rev->min >= min_supp)
+	if (rev->maj == fw->rev_supp.maj && rev->min >= fw->rev_supp.min)
 		return 0;
 
 	dev_err(fw->dev.dev, "Driver supports FW version only '%u.%u.x'",
-		PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
+		fw->rev_supp.maj, fw->rev_supp.min);
 
 	return -EINVAL;
 }
 
-static int prestera_fw_hdr_parse(struct prestera_fw *fw,
-				 const struct firmware *img)
+static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 {
-	struct prestera_fw_header *hdr = (struct prestera_fw_header *)img->data;
 	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
+	struct prestera_fw_header *hdr;
 	u32 magic;
 
+	hdr = (struct prestera_fw_header *)fw->bin->data;
+
 	magic = be32_to_cpu(hdr->magic_number);
 	if (magic != PRESTERA_FW_HDR_MAGIC) {
 		dev_err(fw->dev.dev, "FW img hdr magic is invalid");
@@ -609,11 +613,52 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw,
 	return prestera_fw_rev_check(fw);
 }
 
+static int prestera_fw_get(struct prestera_fw *fw)
+{
+	int ver_maj = PRESTERA_SUPP_FW_MAJ_VER;
+	int ver_min = PRESTERA_SUPP_FW_MIN_VER;
+	char fw_path[128];
+	int err;
+
+pick_fw_ver:
+	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
+		 ver_maj, ver_min);
+
+	err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
+	if (err) {
+		if (ver_maj == PRESTERA_SUPP_FW_MAJ_VER) {
+			ver_maj = PRESTERA_PREV_FW_MAJ_VER;
+			ver_min = PRESTERA_PREV_FW_MIN_VER;
+
+			dev_warn(fw->dev.dev,
+				 "missing latest %s firmware, fall-back to previous %u.%u version\n",
+				 fw_path, ver_maj, ver_min);
+
+			goto pick_fw_ver;
+		} else {
+			dev_err(fw->dev.dev, "failed to request previous firmware: %s\n",
+				fw_path);
+			return err;
+		}
+	}
+
+	dev_info(fw->dev.dev, "Loading %s ...", fw_path);
+
+	fw->rev_supp.maj = ver_maj;
+	fw->rev_supp.min = ver_min;
+	fw->rev_supp.sub = 0;
+
+	return 0;
+}
+
+static void prestera_fw_put(struct prestera_fw *fw)
+{
+	release_firmware(fw->bin);
+}
+
 static int prestera_fw_load(struct prestera_fw *fw)
 {
 	size_t hlen = sizeof(struct prestera_fw_header);
-	const struct firmware *f;
-	char fw_path[128];
 	int err;
 
 	err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_READY_REG,
@@ -632,30 +677,24 @@ static int prestera_fw_load(struct prestera_fw *fw)
 
 	fw->ldr_wr_idx = 0;
 
-	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
-		 PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
-
-	err = request_firmware_direct(&f, fw_path, fw->dev.dev);
-	if (err) {
-		dev_err(fw->dev.dev, "failed to request firmware file\n");
+	err = prestera_fw_get(fw);
+	if (err)
 		return err;
-	}
 
-	err = prestera_fw_hdr_parse(fw, f);
+	err = prestera_fw_hdr_parse(fw);
 	if (err) {
 		dev_err(fw->dev.dev, "FW image header is invalid\n");
 		goto out_release;
 	}
 
-	prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, f->size - hlen);
+	prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, fw->bin->size - hlen);
 	prestera_ldr_write(fw, PRESTERA_LDR_CTL_REG, PRESTERA_LDR_CTL_DL_START);
 
-	dev_info(fw->dev.dev, "Loading %s ...", fw_path);
-
-	err = prestera_ldr_fw_send(fw, f->data + hlen, f->size - hlen);
+	err = prestera_ldr_fw_send(fw, fw->bin->data + hlen,
+				   fw->bin->size - hlen);
 
 out_release:
-	release_firmware(f);
+	prestera_fw_put(fw);
 	return err;
 }
 
-- 
2.53.0



