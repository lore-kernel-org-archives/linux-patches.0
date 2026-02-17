Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3464F29A1;
	Tue, 17 Feb 2026 20:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361601; cv=none; b=a+RND0oLvcM31CoL3B4waWZkGrwhQLJ4ZP11fZUkVbFQuJE2AeLf5CSSFuyGWJ3v30/6DCG2Orz+iRoVhoNjsJ7AY5VGIYUE23VkiJMkW76MFlmIiG7yYyBpPcQWPUGB/RzW53Mk6jrECy7RY8wQemwMlLVE+CV16N8dYBBvSZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361601; c=relaxed/simple;
	bh=ZpUvEL5TxU2tegnmm4qA6KsgzWq+E44BsRNke5liy8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1GvBF37sAupVC4odZ98MrUX2tTgdCEFqnDDgv1C7zP+cebHI/Bqik7fRny9tjG9UUI3Nqb1efxbRuazcqQcOwwa5jCAv1ZjVRnOma+NeBxqaJgzsmeigfaYM66BZfJKhmoBzPnERq4i8GuU9zmAS2HUYOpuYSBDXWpX2H9OCY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkrjinLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkrjinLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C907C4CEF7;
	Tue, 17 Feb 2026 20:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361601;
	bh=ZpUvEL5TxU2tegnmm4qA6KsgzWq+E44BsRNke5liy8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkrjinLDVcx315lCvD/qK9lQA+lu1fELweJp5ESmlVFapuSPFI+ZJLg0fBlOjSYYj
	 cuUK53LoZMs+MbC70xb2BMBm/kONlqAyOgBdmHZKYszFZ/XQ7jtT7ZazDK5QLoQbiX
	 EbylbJ15dc3hAX8LlDsco0mM65DR7D3XIp3Vgs80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 02/42] bnxt_en: Change FW message timeout warning
Date: Tue, 17 Feb 2026 21:31:53 +0100
Message-ID: <20260217200006.096356325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

commit 0fcad44a86bdc2b5f202d91ba1eeeee6fceb7b25 upstream.

The firmware advertises a "hwrm_cmd_max_timeout" value to the driver
for NVRAM and coredump related functions that can take tens of seconds
to complete.  The driver polls for the operation to complete under
mutex and may trigger hung task watchdog warning if the wait is too long.
To warn the user about this, the driver currently prints a warning if
this advertised value exceeds 40 seconds:

Device requests max timeout of %d seconds, may trigger hung task watchdog

Initially, we chose 40 seconds, well below the kernel's default
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT (120 seconds) to avoid triggering
the hung task watchdog.  But 60 seconds is the timeout on most
production FW and cannot be reduced further.  Change the driver's warning
threshold to 60 seconds to avoid triggering this warning on all
production devices.  We also print the warning if the value exceeds
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT which may be set to architecture
specific defaults as low as 10 seconds.

Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250417172448.1206107-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c      |   11 +++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h |    2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9770,7 +9770,7 @@ static int bnxt_hwrm_ver_get(struct bnxt
 	struct hwrm_ver_get_input *req;
 	u16 fw_maj, fw_min, fw_bld, fw_rsv;
 	u32 dev_caps_cfg, hwrm_ver;
-	int rc, len;
+	int rc, len, max_tmo_secs;
 
 	rc = hwrm_req_init(bp, req, HWRM_VER_GET);
 	if (rc)
@@ -9843,9 +9843,12 @@ static int bnxt_hwrm_ver_get(struct bnxt
 	bp->hwrm_cmd_max_timeout = le16_to_cpu(resp->max_req_timeout) * 1000;
 	if (!bp->hwrm_cmd_max_timeout)
 		bp->hwrm_cmd_max_timeout = HWRM_CMD_MAX_TIMEOUT;
-	else if (bp->hwrm_cmd_max_timeout > HWRM_CMD_MAX_TIMEOUT)
-		netdev_warn(bp->dev, "Device requests max timeout of %d seconds, may trigger hung task watchdog\n",
-			    bp->hwrm_cmd_max_timeout / 1000);
+	max_tmo_secs = bp->hwrm_cmd_max_timeout / 1000;
+	if (bp->hwrm_cmd_max_timeout > HWRM_CMD_MAX_TIMEOUT ||
+	    max_tmo_secs > CONFIG_DEFAULT_HUNG_TASK_TIMEOUT) {
+		netdev_warn(bp->dev, "Device requests max timeout of %d seconds, may trigger hung task watchdog (kernel default %ds)\n",
+			    max_tmo_secs, CONFIG_DEFAULT_HUNG_TASK_TIMEOUT);
+	}
 
 	if (resp->hwrm_intf_maj_8b >= 1) {
 		bp->hwrm_max_req_len = le16_to_cpu(resp->max_req_win_len);
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -58,7 +58,7 @@ void hwrm_update_token(struct bnxt *bp,
 
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
 #define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
-#define HWRM_CMD_MAX_TIMEOUT		40000U
+#define HWRM_CMD_MAX_TIMEOUT		60000U
 #define SHORT_HWRM_CMD_TIMEOUT		20
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)


