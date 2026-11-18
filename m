Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019213;
	b=Joj4DybjZxa4SYlyjSHbsVaheVaoqka7ekrc7l1r7eAIq9okohxPYH03s2ZtZWM67he4
	 TymrgoplSAEPIWPG5EYuuiQhqBr5GhZOplVzzKCkEWpo9Oi9lcoVevtNUwUR4NYbwRvtZ
	 oFzya0G68IJUfFpqs9tk2tlLMcSDgyN11YxKK9yNMzyLFs3pi9jjU83KEFFEDxslViHqZ
	 gWYN+JUTLrkCpF1l9yfuCZNvRVAFGmX8bt/nxNraRrAVdNndefSdCf+Le639LY3k5MiOa
	 qXntZ9vIGNJV94ZJqUPrR+4My1lo9fC6Es8n4zjjpgBwmQZ6kUxb89KacRMyI07ohcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DR30dvIx2RH3/yZ0Sy/Nj4G/SFkBbwq2hBYP2uEGWFk=;
	b=rAsySVYGPRidnLYSPsJ4Wnh0YLjqSvwR1dfIiXUrPRWAWTRpR02imea7Vp2Ln+DiYhwx
	 a0mFVU7AYeMauqVbwO6iPZ8EemZ3902fD2CS6PoJ6KipE0SpYnDAySyKtIaC2Xgm7R2rQ
	 0UyrFzT9LOLxY0vIFgydnm8iyIeqpohqvaaLGwO8pWqaYqSfGbSUkdSu7jLXru4dMcqk8
	 VJpj8U/k8iHoHhYFBD94AW5ONNBczLGzFpbIJiQbhofT+u6HXP6j2bQ9xBvftlAdB7mt8
	 WatBHjnRADz+AaYBEFEHMA34rlk1VC4Cohrkd9QVPEI/XYBaWb/B2E8yahpw5lApuMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtJ71Fkm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66A4606A33B;
	Wed, 18 Nov 2026 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtJ71Fkm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3421F000C4;
	Wed, 18 Nov 2026 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019213;
	bh=DR30dvIx2RH3/yZ0Sy/Nj4G/SFkBbwq2hBYP2uEGWFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtJ71FkmYn8COXEDc6o/3IrixpTDHagczKFiqjLfsagJ5CmtIVasRU0s2o6qB/3HO
	 0XjzOIu/BdMur/c4r08nl1kUYX8RkmXRsv+jHmvGijiltFWKtDGx11wCETW+MtZ683
	 INPwsRbnWDw3TUqE4dTJws4JMvccq5eaIosz78ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Maslanka <mmaslanka@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1515/2651] platform/chrome: cros_ec_typec: Poll for role swap completion
Date: Wed, 18 Nov 2026 15:45:55 +0100
Message-ID: <20261118150342.540644398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Maslanka <mmaslanka@google.com>

[ Upstream commit 2d3ee0bdb321ad84d9cf18d4bfd2b839293a695d ]

Depending on the EC USB-C stack (TCPMv2 vs PDC), EC_CMD_USB_PD_CONTROL
with a role swap request may either block until the swap completes or
queue the request asynchronously for the EC PD task and return the
current (pre-swap) role in the immediate response. On platforms where
the EC handles the swap asynchronously, checking resp.role right after
issuing the swap command sees the old role and fails with -EIO before
the USB PD handshake completes.

If the immediate response does not yet reflect the target role, poll
EC_CMD_USB_PD_CONTROL with USB_PD_CTRL_SWAP_NONE until the target role
is reached while connected, or until ROLE_SWAP_TIMEOUT_MS expires. The
timeout mirrors PD_ROLE_SWAP_TIMEOUT used by the TCPM port manager,
since a PR_Swap may legitimately take seconds when the partner answers
with Wait and the initiator retries.

While at it, report the failure modes the same way tcpm.c does, so that
userspace can tell a rejected swap from a disconnect: -ETIMEDOUT when
the partner never completes the swap, and -ENOTCONN when the port goes
away while waiting. Decoding of the swapped role is factored out into
cros_typec_resp_to_role() instead of being open coded for each swap
type, which also keeps an unhandled swap type from being misread as a
power role swap.

Fixes: ab229c2b72c3 ("platform/chrome: cros_ec_typec: Add role swap ops")
Signed-off-by: Marek Maslanka <mmaslanka@google.com>
Link: https://lore.kernel.org/r/20261007033837.708119-1-mmaslanka@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 94 +++++++++++++++++--------
 1 file changed, 65 insertions(+), 29 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 4427897eb3f59..5871fe031f14d 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -8,6 +8,8 @@
 
 #include <linux/acpi.h>
 #include <linux/array_size.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/overflow.h>
@@ -24,6 +26,14 @@
 
 #define DRV_NAME "cros-ec-typec"
 
+/*
+ * Mirrors PD_ROLE_SWAP_TIMEOUT used by the TCPM port manager: a PR_Swap may
+ * legitimately take seconds when the partner answers with Wait and the
+ * initiator retries.
+ */
+#define ROLE_SWAP_TIMEOUT_MS	10000
+#define ROLE_SWAP_DELAY_MS	20
+
 #define DP_PORT_VDO	(DP_CAP_DFP_D | DP_CAP_RECEPTACLE | \
 			 DP_CONF_SET_PIN_ASSIGN(BIT(DP_PIN_ASSIGN_C) | \
 						BIT(DP_PIN_ASSIGN_D) | \
@@ -60,12 +70,33 @@ static int cros_typec_enter_usb_mode(struct typec_port *tc_port, enum usb_mode m
 			  &req, sizeof(req), NULL, 0);
 }
 
+/*
+ * Decode the role relevant to @swap_type out of an EC_CMD_USB_PD_CONTROL
+ * response.
+ *
+ * Returns a value comparable against the typec class target role
+ * (TYPEC_DEVICE/TYPEC_HOST or TYPEC_SINK/TYPEC_SOURCE), or -EOPNOTSUPP if
+ * @swap_type is not a role swap this driver knows how to track.
+ */
+static int cros_typec_resp_to_role(struct ec_response_usb_pd_control_v2 *resp, u8 swap_type)
+{
+	switch (swap_type) {
+	case USB_PD_CTRL_SWAP_DATA:
+		return (resp->role & PD_CTRL_RESP_ROLE_DATA) ? TYPEC_HOST : TYPEC_DEVICE;
+	case USB_PD_CTRL_SWAP_POWER:
+		return (resp->role & PD_CTRL_RESP_ROLE_POWER) ? TYPEC_SOURCE : TYPEC_SINK;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int cros_typec_perform_role_swap(struct typec_port *tc_port, int target_role, u8 swap_type)
 {
 	struct cros_typec_port *port = typec_get_drvdata(tc_port);
 	struct cros_typec_data *data = port->typec_data;
 	struct ec_response_usb_pd_control_v2 resp;
 	struct ec_params_usb_pd_control req;
+	unsigned long end;
 	int role, ret;
 
 	/* Must be at least v1 to support role swap. */
@@ -83,18 +114,10 @@ static int cros_typec_perform_role_swap(struct typec_port *tc_port, int target_r
 	if (ret < 0)
 		return ret;
 
-	switch (swap_type) {
-	case USB_PD_CTRL_SWAP_DATA:
-		role = (resp.role & PD_CTRL_RESP_ROLE_DATA) ? TYPEC_HOST :
-						TYPEC_DEVICE;
-		break;
-	case USB_PD_CTRL_SWAP_POWER:
-		role = (resp.role & PD_CTRL_RESP_ROLE_POWER) ? TYPEC_SOURCE :
-						TYPEC_SINK;
-		break;
-	default:
+	role = cros_typec_resp_to_role(&resp, swap_type);
+	if (role < 0) {
 		dev_warn(data->dev, "Unsupported role swap type %d\n", swap_type);
-		return -EOPNOTSUPP;
+		return role;
 	}
 
 	if (role == target_role)
@@ -106,28 +129,41 @@ static int cros_typec_perform_role_swap(struct typec_port *tc_port, int target_r
 	if (ret < 0)
 		return ret;
 
-	switch (swap_type) {
-	case USB_PD_CTRL_SWAP_DATA:
-		role = resp.role & PD_CTRL_RESP_ROLE_DATA ? TYPEC_HOST : TYPEC_DEVICE;
-		if (role != target_role) {
-			dev_err(data->dev, "Data role swap failed despite EC returning success\n");
-			return -EIO;
+	/*
+	 * Depending on the EC USB-C stack (TCPMv2 vs PDC), EC_CMD_USB_PD_CONTROL
+	 * may either block until the swap completes or queue the request
+	 * asynchronously and return the pre-swap role. Poll until the target
+	 * role is reached while connected, or until the timeout expires.
+	 */
+	req.swap = USB_PD_CTRL_SWAP_NONE;
+	end = jiffies + msecs_to_jiffies(ROLE_SWAP_TIMEOUT_MS);
+	for (;;) {
+		if (!(resp.enabled & PD_CTRL_RESP_ENABLED_CONNECTED)) {
+			dev_warn(data->dev, "Port disconnected during role swap\n");
+			return -ENOTCONN;
 		}
-		typec_set_data_role(tc_port, target_role);
-		break;
-	case USB_PD_CTRL_SWAP_POWER:
-		role = resp.role & PD_CTRL_RESP_ROLE_POWER ? TYPEC_SOURCE : TYPEC_SINK;
-		if (role != target_role) {
-			dev_err(data->dev, "Power role swap failed despite EC returning success\n");
-			return -EIO;
+
+		if (cros_typec_resp_to_role(&resp, swap_type) == target_role)
+			break;
+
+		if (time_after_eq(jiffies, end)) {
+			dev_err(data->dev, "Timed out waiting for role swap to complete\n");
+			return -ETIMEDOUT;
 		}
-		typec_set_pwr_role(tc_port, target_role);
-		break;
-	default:
-		/* Should never execute */
-		break;
+
+		msleep(ROLE_SWAP_DELAY_MS);
+		ret = cros_ec_cmd(data->ec, data->pd_ctrl_ver,
+				  EC_CMD_USB_PD_CONTROL, &req, sizeof(req),
+				  &resp, sizeof(resp));
+		if (ret < 0)
+			return ret;
 	}
 
+	if (swap_type == USB_PD_CTRL_SWAP_DATA)
+		typec_set_data_role(tc_port, target_role);
+	else
+		typec_set_pwr_role(tc_port, target_role);
+
 	return 0;
 }
 
-- 
2.53.0



