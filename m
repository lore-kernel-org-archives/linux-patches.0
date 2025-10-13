Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F887305E31;
	Mon, 13 Oct 2025 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368346; cv=none; b=KovCCdjuiJeV1x83dcDJqYPcRVB15a6Oj3t3A8LNC7iPNCwy+ZTVt6gcMXN6Fgwm/zEumaEDJyCd9y4k+651mD5dRhIjgtPNJ3M6m/afbJRW7/HYwEIVVykJXFPm9kvxRy8/kSGavpfkpO0K3OwdpBplYQLjSwXA5OZaKNycc/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368346; c=relaxed/simple;
	bh=kLtunDa2/IC23nuD1jgQZnWoOCywTOu8VFnsDI2DlJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8sbICugbgsSBuBUaYf9jL5dveYJGbBfW+SGbq8wEM/gA1FaWilLboNsKAqQfuk7Fuja6U3cLR7Wz1iW3C3nEApG1swPUbkuzDulFa9WIbKu9ENVFtUcJLOXYb0HsTXOqJwgHU5Q+MGO1i5fV9vTP7QrXKxACGTB2WMiw/GnDuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkrIU/1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkrIU/1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E3EC4CEE7;
	Mon, 13 Oct 2025 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368346;
	bh=kLtunDa2/IC23nuD1jgQZnWoOCywTOu8VFnsDI2DlJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkrIU/1IJ/5udps2NFrPqPjVo5bDHkGeVabtLegXTgnGRIv8Ls7bAdsK9kOIfHilx
	 a3cKNsO+dICTLH+g0muKoHILlko3sqSj9YCv603vAckBO9IysupBkvQMlbei9XyaIF
	 H1ATHGiqI4DJSkwIXyydm4IOVcfWUFN7jfovvdKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seppo Takalo <seppo.takalo@nordicsemi.no>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/262] tty: n_gsm: Dont block input queue by waiting MSC
Date: Mon, 13 Oct 2025 16:44:31 +0200
Message-ID: <20251013144330.769692282@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seppo Takalo <seppo.takalo@nordicsemi.no>

[ Upstream commit 3cf0b3c243e56bc43be560617416c1d9f301f44c ]

Currently gsm_queue() processes incoming frames and when opening
a DLC channel it calls gsm_dlci_open() which calls gsm_modem_update().
If basic mode is used it calls gsm_modem_upd_via_msc() and it
cannot block the input queue by waiting the response to come
into the same input queue.

Instead allow sending Modem Status Command without waiting for remote
end to respond. Define a new function gsm_modem_send_initial_msc()
for this purpose. As MSC is only valid for basic encoding, it does
not do anything for advanced or when convergence layer type 2 is used.

Fixes: 48473802506d ("tty: n_gsm: fix missing update of modem controls after DLCI open")
Signed-off-by: Seppo Takalo <seppo.takalo@nordicsemi.no>
Link: https://lore.kernel.org/r/20250827123221.1148666-1-seppo.takalo@nordicsemi.no
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 252849910588f..c917fc20b469a 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -461,6 +461,7 @@ static int gsm_send_packet(struct gsm_mux *gsm, struct gsm_msg *msg);
 static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr);
 static void gsmld_write_trigger(struct gsm_mux *gsm);
 static void gsmld_write_task(struct work_struct *work);
+static int gsm_modem_send_initial_msc(struct gsm_dlci *dlci);
 
 /**
  *	gsm_fcs_add	-	update FCS
@@ -2174,7 +2175,7 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
 	/* Send current modem state */
 	if (dlci->addr) {
-		gsm_modem_update(dlci, 0);
+		gsm_modem_send_initial_msc(dlci);
 	} else {
 		/* Start keep-alive control */
 		gsm->ka_num = 0;
@@ -4156,6 +4157,28 @@ static int gsm_modem_upd_via_msc(struct gsm_dlci *dlci, u8 brk)
 	return gsm_control_wait(dlci->gsm, ctrl);
 }
 
+/**
+ * gsm_modem_send_initial_msc - Send initial modem status message
+ *
+ * @dlci channel
+ *
+ * Send an initial MSC message after DLCI open to set the initial
+ * modem status lines. This is only done for basic mode.
+ * Does not wait for a response as we cannot block the input queue
+ * processing.
+ */
+static int gsm_modem_send_initial_msc(struct gsm_dlci *dlci)
+{
+	u8 modembits[2];
+
+	if (dlci->adaption != 1 || dlci->gsm->encoding != GSM_BASIC_OPT)
+		return 0;
+
+	modembits[0] = (dlci->addr << 2) | 2 | EA; /* DLCI, Valid, EA */
+	modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
+	return gsm_control_command(dlci->gsm, CMD_MSC, (const u8 *)&modembits, 2);
+}
+
 /**
  *	gsm_modem_update	-	send modem status line state
  *	@dlci: channel
-- 
2.51.0



