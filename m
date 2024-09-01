Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F14844C97;
	Sun,  1 Sep 2024 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208095; cv=none; b=NT38Sx9XIvIPErgXcDIT+GN6og5/KWtQXqNFLTjQKZ5Mypbr39Fk4RERKPEOTtnMvWKVdBghMvY9S/RQdPbtAmIUuI2wamDnFAfh1CT9j8Q0hxhceIxajK9aaVUs1V0BeopBqxRDqLq46IL6BZP+GLZd0Bm/WECT951WzhLdI+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208095; c=relaxed/simple;
	bh=bOwNR/N2MNGLAfivG3k3UhTbUzTxk+g0Xl/tAr+mBFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKDzDCJrixsyHn1e+YXdZorX309ZtxIYtpcojC28G1K4jtKwRTuQnXQE0obaU4QP0nqnE2us51imUVC/SxmLRVxXrpDT5pRgMZFAwU/o50t29EEAEC9bwW9KKyqxRwlhPm/UyNpT+rzMYZXDYYMz67hLv/Rqb7MoULHcCuOo9+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDY8xtuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDY8xtuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F92C4CEC3;
	Sun,  1 Sep 2024 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208095;
	bh=bOwNR/N2MNGLAfivG3k3UhTbUzTxk+g0Xl/tAr+mBFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDY8xtuYXFPmZ2GMmV1WPaZgC6OyfFaS8uBI9UE1XhENRIeffI9+/bI2HEDZ9HUHf
	 ZIKpALA2psGwUHb8Zp7bXmgtSLP7nOtyoBDMbFJeNIk4PQ7+eJ1gd3CQCmqEmD09fd
	 dwR/Kkh37b5Biu4tDXan8YnIxYi6j77AjtXOAlFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 72/93] soc: qcom: pmic_glink: Fix race during initialization
Date: Sun,  1 Sep 2024 18:16:59 +0200
Message-ID: <20240901160810.447896250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Bjorn Andersson <quic_bjorande@quicinc.com>

commit 3568affcddd68743e25aa3ec1647d9b82797757b upstream.

As pointed out by Stephen Boyd it is possible that during initialization
of the pmic_glink child drivers, the protection-domain notifiers fires,
and the associated work is scheduled, before the client registration
returns and as a result the local "client" pointer has been initialized.

The outcome of this is a NULL pointer dereference as the "client"
pointer is blindly dereferenced.

Timeline provided by Stephen:
 CPU0                               CPU1
 ----                               ----
 ucsi->client = NULL;
 devm_pmic_glink_register_client()
  client->pdr_notify(client->priv, pg->client_state)
   pmic_glink_ucsi_pdr_notify()
    schedule_work(&ucsi->register_work)
    <schedule away>
                                    pmic_glink_ucsi_register()
                                     ucsi_register()
                                      pmic_glink_ucsi_read_version()
                                       pmic_glink_ucsi_read()
                                        pmic_glink_ucsi_read()
                                         pmic_glink_send(ucsi->client)
                                         <client is NULL BAD>
 ucsi->client = client // Too late!

This code is identical across the altmode, battery manager and usci
child drivers.

Resolve this by splitting the allocation of the "client" object and the
registration thereof into two operations.

This only happens if the protection domain registry is populated at the
time of registration, which by the introduction of commit '1ebcde047c54
("soc: qcom: add pd-mapper implementation")' became much more likely.

Reported-by: Amit Pundir <amit.pundir@linaro.org>
Closes: https://lore.kernel.org/all/CAMi1Hd2_a7TjA7J9ShrAbNOd_CoZ3D87twmO5t+nZxC9sX18tA@mail.gmail.com/
Reported-by: Johan Hovold <johan@kernel.org>
Closes: https://lore.kernel.org/all/ZqiyLvP0gkBnuekL@hovoldconsulting.com/
Reported-by: Stephen Boyd <swboyd@chromium.org>
Closes: https://lore.kernel.org/all/CAE-0n52JgfCBWiFQyQWPji8cq_rCsviBpW-m72YitgNfdaEhQg@mail.gmail.com/
Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20240820-pmic-glink-v6-11-races-v3-1-eec53c750a04@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/qcom_battmgr.c   |   16 ++++++++++------
 drivers/soc/qcom/pmic_glink.c         |   28 ++++++++++++++++++----------
 drivers/soc/qcom/pmic_glink_altmode.c |   17 +++++++++++------
 drivers/usb/typec/ucsi/ucsi_glink.c   |   16 ++++++++++------
 include/linux/soc/qcom/pmic_glink.h   |   11 ++++++-----
 5 files changed, 55 insertions(+), 33 deletions(-)

--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1384,12 +1384,16 @@ static int qcom_battmgr_probe(struct aux
 					     "failed to register wireless charing power supply\n");
 	}
 
-	battmgr->client = devm_pmic_glink_register_client(dev,
-							  PMIC_GLINK_OWNER_BATTMGR,
-							  qcom_battmgr_callback,
-							  qcom_battmgr_pdr_notify,
-							  battmgr);
-	return PTR_ERR_OR_ZERO(battmgr->client);
+	battmgr->client = devm_pmic_glink_client_alloc(dev, PMIC_GLINK_OWNER_BATTMGR,
+						       qcom_battmgr_callback,
+						       qcom_battmgr_pdr_notify,
+						       battmgr);
+	if (IS_ERR(battmgr->client))
+		return PTR_ERR(battmgr->client);
+
+	pmic_glink_client_register(battmgr->client);
+
+	return 0;
 }
 
 static const struct auxiliary_device_id qcom_battmgr_id_table[] = {
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -69,15 +69,14 @@ static void _devm_pmic_glink_release_cli
 	spin_unlock_irqrestore(&pg->client_lock, flags);
 }
 
-struct pmic_glink_client *devm_pmic_glink_register_client(struct device *dev,
-							  unsigned int id,
-							  void (*cb)(const void *, size_t, void *),
-							  void (*pdr)(void *, int),
-							  void *priv)
+struct pmic_glink_client *devm_pmic_glink_client_alloc(struct device *dev,
+						       unsigned int id,
+						       void (*cb)(const void *, size_t, void *),
+						       void (*pdr)(void *, int),
+						       void *priv)
 {
 	struct pmic_glink_client *client;
 	struct pmic_glink *pg = dev_get_drvdata(dev->parent);
-	unsigned long flags;
 
 	client = devres_alloc(_devm_pmic_glink_release_client, sizeof(*client), GFP_KERNEL);
 	if (!client)
@@ -88,6 +87,18 @@ struct pmic_glink_client *devm_pmic_glin
 	client->cb = cb;
 	client->pdr_notify = pdr;
 	client->priv = priv;
+	INIT_LIST_HEAD(&client->node);
+
+	devres_add(dev, client);
+
+	return client;
+}
+EXPORT_SYMBOL_GPL(devm_pmic_glink_client_alloc);
+
+void pmic_glink_client_register(struct pmic_glink_client *client)
+{
+	struct pmic_glink *pg = client->pg;
+	unsigned long flags;
 
 	mutex_lock(&pg->state_lock);
 	spin_lock_irqsave(&pg->client_lock, flags);
@@ -98,11 +109,8 @@ struct pmic_glink_client *devm_pmic_glin
 	spin_unlock_irqrestore(&pg->client_lock, flags);
 	mutex_unlock(&pg->state_lock);
 
-	devres_add(dev, client);
-
-	return client;
 }
-EXPORT_SYMBOL_GPL(devm_pmic_glink_register_client);
+EXPORT_SYMBOL_GPL(pmic_glink_client_register);
 
 int pmic_glink_send(struct pmic_glink_client *client, void *data, size_t len)
 {
--- a/drivers/soc/qcom/pmic_glink_altmode.c
+++ b/drivers/soc/qcom/pmic_glink_altmode.c
@@ -529,12 +529,17 @@ static int pmic_glink_altmode_probe(stru
 			return ret;
 	}
 
-	altmode->client = devm_pmic_glink_register_client(dev,
-							  altmode->owner_id,
-							  pmic_glink_altmode_callback,
-							  pmic_glink_altmode_pdr_notify,
-							  altmode);
-	return PTR_ERR_OR_ZERO(altmode->client);
+	altmode->client = devm_pmic_glink_client_alloc(dev,
+						       altmode->owner_id,
+						       pmic_glink_altmode_callback,
+						       pmic_glink_altmode_pdr_notify,
+						       altmode);
+	if (IS_ERR(altmode->client))
+		return PTR_ERR(altmode->client);
+
+	pmic_glink_client_register(altmode->client);
+
+	return 0;
 }
 
 static const struct auxiliary_device_id pmic_glink_altmode_id_table[] = {
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -376,12 +376,16 @@ static int pmic_glink_ucsi_probe(struct
 					"failed to acquire orientation-switch\n");
 	}
 
-	ucsi->client = devm_pmic_glink_register_client(dev,
-						       PMIC_GLINK_OWNER_USBC,
-						       pmic_glink_ucsi_callback,
-						       pmic_glink_ucsi_pdr_notify,
-						       ucsi);
-	return PTR_ERR_OR_ZERO(ucsi->client);
+	ucsi->client = devm_pmic_glink_client_alloc(dev, PMIC_GLINK_OWNER_USBC,
+						    pmic_glink_ucsi_callback,
+						    pmic_glink_ucsi_pdr_notify,
+						    ucsi);
+	if (IS_ERR(ucsi->client))
+		return PTR_ERR(ucsi->client);
+
+	pmic_glink_client_register(ucsi->client);
+
+	return 0;
 }
 
 static void pmic_glink_ucsi_remove(struct auxiliary_device *adev)
--- a/include/linux/soc/qcom/pmic_glink.h
+++ b/include/linux/soc/qcom/pmic_glink.h
@@ -23,10 +23,11 @@ struct pmic_glink_hdr {
 
 int pmic_glink_send(struct pmic_glink_client *client, void *data, size_t len);
 
-struct pmic_glink_client *devm_pmic_glink_register_client(struct device *dev,
-							  unsigned int id,
-							  void (*cb)(const void *, size_t, void *),
-							  void (*pdr)(void *, int),
-							  void *priv);
+struct pmic_glink_client *devm_pmic_glink_client_alloc(struct device *dev,
+						       unsigned int id,
+						       void (*cb)(const void *, size_t, void *),
+						       void (*pdr)(void *, int),
+						       void *priv);
+void pmic_glink_client_register(struct pmic_glink_client *client);
 
 #endif


