Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A1C6088F;
	Wed,  6 Nov 2024 12:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896256; cv=none; b=G9Rc0lwF97mN/Rq1ahwwJttZh4dcD87ptIa9vNJ+vC5ad+B+DMOUmhvD1BzgIDwEbvF9j/XAYzAY0FPuI4g4aFe3iXf8/ZmYp+6aB6fMLiMh76XWzRuMDlSZs9aS3USaa5ZjuXbQQeTLxSvGVmtZvor4+SNHt9Rpi5HZEJZ8GZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896256; c=relaxed/simple;
	bh=sFYz4a6pPRiz3OSGFm5h33QRSHnvHui+ZfZxKyCEzeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9tOev2HIFUTKBfj9yhGiJow/nTT0Z3B2lNWlRWDzNLHAFoIRt1ZRp2njs6koDAq4wSZ4woNW/VQk+bRY0y+ERGUmpdEuBcgJT1IT2VsOk31zpOUpvXg2+8gIqs+R8HAhdjiE+6VT+CSc7RN7BygjNfQxUSDpctQbsGm474J/aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZBef6vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZBef6vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D275AC4CECD;
	Wed,  6 Nov 2024 12:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896256;
	bh=sFYz4a6pPRiz3OSGFm5h33QRSHnvHui+ZfZxKyCEzeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZBef6vx+v/aZFLDFXe5hDZHfey9EEWh2+Bb3eCU1zFYTJFRzBMUxiTd6H4s0/U11
	 TlhD3Dr8OWwBBe9CHJ1ZpLU6P/vSwZp+UIle1MtHovQH88Ytt8Dtqx05w5Qx3tDWNz
	 Tp8NuDVIUo6mih9dNMRlJz5L/FUb2/hMtjymFGzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 142/245] soc: qcom: pmic_glink: Handle GLINK intent allocation rejections
Date: Wed,  6 Nov 2024 13:03:15 +0100
Message-ID: <20241106120322.723248484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit f8c879192465d9f328cb0df07208ef077c560bb1 upstream.

Some versions of the pmic_glink firmware does not allow dynamic GLINK
intent allocations, attempting to send a message before the firmware has
allocated its receive buffers and announced these intent allocations
will fail. When this happens something like this showns up in the log:

    pmic_glink_altmode.pmic_glink_altmode pmic_glink.altmode.0: failed to send altmode request: 0x10 (-125)
    pmic_glink_altmode.pmic_glink_altmode pmic_glink.altmode.0: failed to request altmode notifications: -125
    ucsi_glink.pmic_glink_ucsi pmic_glink.ucsi.0: failed to send UCSI read request: -125
    qcom_battmgr.pmic_glink_power_supply pmic_glink.power-supply.0: failed to request power notifications

GLINK has been updated to distinguish between the cases where the remote
is going down (-ECANCELED) and the intent allocation being rejected
(-EAGAIN).

Retry the send until intent buffers becomes available, or an actual
error occur.

To avoid infinitely waiting for the firmware in the event that this
misbehaves and no intents arrive, an arbitrary 5 second timeout is
used.

This patch was developed with input from Chris Lew.

Reported-by: Johan Hovold <johan@kernel.org>
Closes: https://lore.kernel.org/all/Zqet8iInnDhnxkT9@hovoldconsulting.com/#t
Cc: stable@vger.kernel.org # rpmsg: glink: Handle rejected intent request better
Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Link: https://lore.kernel.org/r/20241023-pmic-glink-ecancelled-v2-2-ebc268129407@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pmic_glink.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2022, Linaro Ltd
  */
 #include <linux/auxiliary_bus.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -13,6 +14,8 @@
 #include <linux/soc/qcom/pmic_glink.h>
 #include <linux/spinlock.h>
 
+#define PMIC_GLINK_SEND_TIMEOUT (5 * HZ)
+
 enum {
 	PMIC_GLINK_CLIENT_BATT = 0,
 	PMIC_GLINK_CLIENT_ALTMODE,
@@ -112,13 +115,29 @@ EXPORT_SYMBOL_GPL(pmic_glink_client_regi
 int pmic_glink_send(struct pmic_glink_client *client, void *data, size_t len)
 {
 	struct pmic_glink *pg = client->pg;
+	bool timeout_reached = false;
+	unsigned long start;
 	int ret;
 
 	mutex_lock(&pg->state_lock);
-	if (!pg->ept)
+	if (!pg->ept) {
 		ret = -ECONNRESET;
-	else
-		ret = rpmsg_send(pg->ept, data, len);
+	} else {
+		start = jiffies;
+		for (;;) {
+			ret = rpmsg_send(pg->ept, data, len);
+			if (ret != -EAGAIN)
+				break;
+
+			if (timeout_reached) {
+				ret = -ETIMEDOUT;
+				break;
+			}
+
+			usleep_range(1000, 5000);
+			timeout_reached = time_after(jiffies, start + PMIC_GLINK_SEND_TIMEOUT);
+		}
+	}
 	mutex_unlock(&pg->state_lock);
 
 	return ret;


