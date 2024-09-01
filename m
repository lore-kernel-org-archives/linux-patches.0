Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2B1C68C;
	Sun,  1 Sep 2024 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208621; cv=none; b=jYzB5548i0TF5XVoe9wRrCN9lVGcMzpNbkPZO45e1L+7c7PAAGNdz9Sb+5ss3zZhMUcdf5a9DRdFnydCKHG2WrwOIRW0S3Vr+q1FkDVeub4X2o6bIXBvu6OJHr962wi3myhVF0SlB9qhhVqYPozBff9SN7VuhxDAfWpaPc4RGUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208621; c=relaxed/simple;
	bh=11fgy+a2cVXxhgiFmSXN1zjHR+ElqQGo667JBRbieWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbxBGW1Jy/0x8vRVNvdm2Bs2ItdttJWdLGaimVplGUpKEb6G0Ss5QHakxgEi4twDCYIaUvBS8SZYEaK//S/sQPhJMxuWAPDxwMsrDctaySgfXeASLdCkYm/MIg+JLZEvjfGa8txiAmGHdOboBqVCWp7GFift4A4pqGtXJq/rMLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ1mR+Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ1mR+Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6766EC4CEC3;
	Sun,  1 Sep 2024 16:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208620;
	bh=11fgy+a2cVXxhgiFmSXN1zjHR+ElqQGo667JBRbieWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ1mR+TdQRBT3BiyxEzrthAX2DsH3HnaNmzUYisNi86RfmH5+pkSQuWLPgg7toLI2
	 N8WnIuuXj814rBCDnQwReHxQKexkyV8Aly5F3dmG5kZhtoGRO+ZtLFUPXSy4p0aq4j
	 Qz5/FrtwvIyxZKnze0vdP4KkQ9GrHR9BLtl3mN9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 139/149] usb: typec: ucsi: Move unregister out of atomic section
Date: Sun,  1 Sep 2024 18:17:30 +0200
Message-ID: <20240901160822.674705339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

commit 11bb2ffb679399f99041540cf662409905179e3a upstream.

Commit '9329933699b3 ("soc: qcom: pmic_glink: Make client-lock
non-sleeping")' moved the pmic_glink client list under a spinlock, as it
is accessed by the rpmsg/glink callback, which in turn is invoked from
IRQ context.

This means that ucsi_unregister() is now called from atomic context,
which isn't feasible as it's expecting a sleepable context. An effort is
under way to get GLINK to invoke its callbacks in a sleepable context,
but until then lets schedule the unregistration.

A side effect of this is that ucsi_unregister() can now happen
after the remote processor, and thereby the communication link with it, is
gone. pmic_glink_send() is amended with a check to avoid the resulting NULL
pointer dereference.
This does however result in the user being informed about this error by
the following entry in the kernel log:

  ucsi_glink.pmic_glink_ucsi pmic_glink.ucsi.0: failed to send UCSI write request: -5

Fixes: 9329933699b3 ("soc: qcom: pmic_glink: Make client-lock non-sleeping")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20240820-pmic-glink-v6-11-races-v3-2-eec53c750a04@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pmic_glink.c       |   10 +++++++++-
 drivers/usb/typec/ucsi/ucsi_glink.c |   27 ++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 6 deletions(-)

--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -112,8 +112,16 @@ EXPORT_SYMBOL_GPL(pmic_glink_client_regi
 int pmic_glink_send(struct pmic_glink_client *client, void *data, size_t len)
 {
 	struct pmic_glink *pg = client->pg;
+	int ret;
 
-	return rpmsg_send(pg->ept, data, len);
+	mutex_lock(&pg->state_lock);
+	if (!pg->ept)
+		ret = -ECONNRESET;
+	else
+		ret = rpmsg_send(pg->ept, data, len);
+	mutex_unlock(&pg->state_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pmic_glink_send);
 
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -72,6 +72,9 @@ struct pmic_glink_ucsi {
 
 	struct work_struct notify_work;
 	struct work_struct register_work;
+	spinlock_t state_lock;
+	bool ucsi_registered;
+	bool pd_running;
 
 	u8 read_buf[UCSI_BUF_SIZE];
 };
@@ -271,8 +274,20 @@ static void pmic_glink_ucsi_notify(struc
 static void pmic_glink_ucsi_register(struct work_struct *work)
 {
 	struct pmic_glink_ucsi *ucsi = container_of(work, struct pmic_glink_ucsi, register_work);
+	unsigned long flags;
+	bool pd_running;
 
-	ucsi_register(ucsi->ucsi);
+	spin_lock_irqsave(&ucsi->state_lock, flags);
+	pd_running = ucsi->pd_running;
+	spin_unlock_irqrestore(&ucsi->state_lock, flags);
+
+	if (!ucsi->ucsi_registered && pd_running) {
+		ucsi_register(ucsi->ucsi);
+		ucsi->ucsi_registered = true;
+	} else if (ucsi->ucsi_registered && !pd_running) {
+		ucsi_unregister(ucsi->ucsi);
+		ucsi->ucsi_registered = false;
+	}
 }
 
 static void pmic_glink_ucsi_callback(const void *data, size_t len, void *priv)
@@ -296,11 +311,12 @@ static void pmic_glink_ucsi_callback(con
 static void pmic_glink_ucsi_pdr_notify(void *priv, int state)
 {
 	struct pmic_glink_ucsi *ucsi = priv;
+	unsigned long flags;
 
-	if (state == SERVREG_SERVICE_STATE_UP)
-		schedule_work(&ucsi->register_work);
-	else if (state == SERVREG_SERVICE_STATE_DOWN)
-		ucsi_unregister(ucsi->ucsi);
+	spin_lock_irqsave(&ucsi->state_lock, flags);
+	ucsi->pd_running = (state == SERVREG_SERVICE_STATE_UP);
+	spin_unlock_irqrestore(&ucsi->state_lock, flags);
+	schedule_work(&ucsi->register_work);
 }
 
 static void pmic_glink_ucsi_destroy(void *data)
@@ -348,6 +364,7 @@ static int pmic_glink_ucsi_probe(struct
 	init_completion(&ucsi->read_ack);
 	init_completion(&ucsi->write_ack);
 	init_completion(&ucsi->sync_ack);
+	spin_lock_init(&ucsi->state_lock);
 	mutex_init(&ucsi->lock);
 
 	ucsi->ucsi = ucsi_create(dev, &pmic_glink_ucsi_ops);


