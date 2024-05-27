Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE1C15FCE0;
	Mon, 27 May 2024 19:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836514; cv=none; b=mxMFo1g5beaOWYLhabDkgb6kB9XvvbbYBPmVdFA2DjKr0mewAgnU8W98n+M1S1q413RPlC6U6kT/LS4XQLC+lj8H449hvoneffmOYrrpJMZAxoFcNX//rHKvzMrJzFnEsOGfTFb+LcyULzLwe9jlRu3IbvFAkDuj6OnUYoXax/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836514; c=relaxed/simple;
	bh=ySTjCzUrytRBH/oeJblpE2oseSKc2wsdZaEDuIdaDwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkajDWGq+Wb/imKSlGCOE5Oa/2LPnvzc0sFLxrzXxbGZVT3C8pfZ4yINjqxPXmlxE8WrsUlX9544f1D7DLV4qZDSLdpQv2nsUiziHQhj0PVdG0xcf9++vJkLr3qB5P59nCqMnB7YgwW/mEjrK2TMpKRcgioIcx/ij3vR4lrl+Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9alIxt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9alIxt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245DAC2BBFC;
	Mon, 27 May 2024 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836513;
	bh=ySTjCzUrytRBH/oeJblpE2oseSKc2wsdZaEDuIdaDwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9alIxt9IyUr2PUt1EQ/ciFxGhc7NDAz2/EMm2Z1Q5RXZ3x+PpyyaVDXDzSz7r7Um
	 FraBLl9fbv70jnxa9D6F78S9e0ZS3kRjih8fNn9HDYmDmKNBFv1NZjo7tq+5gCoja/
	 5fzuPLGaJNn9RzoUGwz5BpY2J709iYpu+nrogXws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 082/427] soc: qcom: pmic_glink: Make client-lock non-sleeping
Date: Mon, 27 May 2024 20:52:09 +0200
Message-ID: <20240527185609.375410956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 9329933699b32d467a99befa20415c4b2172389a ]

The recently introduced commit '635ce0db8956 ("soc: qcom: pmic_glink:
don't traverse clients list without a lock")' ensured that the clients
list is not modified while traversed.

But the callback is made from the GLINK IRQ handler and as such this
mutual exclusion can not be provided by a (sleepable) mutex.

Replace the mutex with a spinlock.

Fixes: 635ce0db8956 ("soc: qcom: pmic_glink: don't traverse clients list without a lock")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240430-pmic-glink-sleep-while-atomic-v1-1-88fb493e8545@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index e85a12ec2aab1..823fd108fa039 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/soc/qcom/pdr.h>
 #include <linux/soc/qcom/pmic_glink.h>
+#include <linux/spinlock.h>
 
 enum {
 	PMIC_GLINK_CLIENT_BATT = 0,
@@ -36,7 +37,7 @@ struct pmic_glink {
 	unsigned int pdr_state;
 
 	/* serializing clients list updates */
-	struct mutex client_lock;
+	spinlock_t client_lock;
 	struct list_head clients;
 };
 
@@ -58,10 +59,11 @@ static void _devm_pmic_glink_release_client(struct device *dev, void *res)
 {
 	struct pmic_glink_client *client = (struct pmic_glink_client *)res;
 	struct pmic_glink *pg = client->pg;
+	unsigned long flags;
 
-	mutex_lock(&pg->client_lock);
+	spin_lock_irqsave(&pg->client_lock, flags);
 	list_del(&client->node);
-	mutex_unlock(&pg->client_lock);
+	spin_unlock_irqrestore(&pg->client_lock, flags);
 }
 
 struct pmic_glink_client *devm_pmic_glink_register_client(struct device *dev,
@@ -72,6 +74,7 @@ struct pmic_glink_client *devm_pmic_glink_register_client(struct device *dev,
 {
 	struct pmic_glink_client *client;
 	struct pmic_glink *pg = dev_get_drvdata(dev->parent);
+	unsigned long flags;
 
 	client = devres_alloc(_devm_pmic_glink_release_client, sizeof(*client), GFP_KERNEL);
 	if (!client)
@@ -84,12 +87,12 @@ struct pmic_glink_client *devm_pmic_glink_register_client(struct device *dev,
 	client->priv = priv;
 
 	mutex_lock(&pg->state_lock);
-	mutex_lock(&pg->client_lock);
+	spin_lock_irqsave(&pg->client_lock, flags);
 
 	list_add(&client->node, &pg->clients);
 	client->pdr_notify(client->priv, pg->client_state);
 
-	mutex_unlock(&pg->client_lock);
+	spin_unlock_irqrestore(&pg->client_lock, flags);
 	mutex_unlock(&pg->state_lock);
 
 	devres_add(dev, client);
@@ -112,6 +115,7 @@ static int pmic_glink_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 	struct pmic_glink_client *client;
 	struct pmic_glink_hdr *hdr;
 	struct pmic_glink *pg = dev_get_drvdata(&rpdev->dev);
+	unsigned long flags;
 
 	if (len < sizeof(*hdr)) {
 		dev_warn(pg->dev, "ignoring truncated message\n");
@@ -120,12 +124,12 @@ static int pmic_glink_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 
 	hdr = data;
 
-	mutex_lock(&pg->client_lock);
+	spin_lock_irqsave(&pg->client_lock, flags);
 	list_for_each_entry(client, &pg->clients, node) {
 		if (client->id == le32_to_cpu(hdr->owner))
 			client->cb(data, len, client->priv);
 	}
-	mutex_unlock(&pg->client_lock);
+	spin_unlock_irqrestore(&pg->client_lock, flags);
 
 	return 0;
 }
@@ -165,6 +169,7 @@ static void pmic_glink_state_notify_clients(struct pmic_glink *pg)
 {
 	struct pmic_glink_client *client;
 	unsigned int new_state = pg->client_state;
+	unsigned long flags;
 
 	if (pg->client_state != SERVREG_SERVICE_STATE_UP) {
 		if (pg->pdr_state == SERVREG_SERVICE_STATE_UP && pg->ept)
@@ -175,10 +180,10 @@ static void pmic_glink_state_notify_clients(struct pmic_glink *pg)
 	}
 
 	if (new_state != pg->client_state) {
-		mutex_lock(&pg->client_lock);
+		spin_lock_irqsave(&pg->client_lock, flags);
 		list_for_each_entry(client, &pg->clients, node)
 			client->pdr_notify(client->priv, new_state);
-		mutex_unlock(&pg->client_lock);
+		spin_unlock_irqrestore(&pg->client_lock, flags);
 		pg->client_state = new_state;
 	}
 }
@@ -265,7 +270,7 @@ static int pmic_glink_probe(struct platform_device *pdev)
 	pg->dev = &pdev->dev;
 
 	INIT_LIST_HEAD(&pg->clients);
-	mutex_init(&pg->client_lock);
+	spin_lock_init(&pg->client_lock);
 	mutex_init(&pg->state_lock);
 
 	match_data = (unsigned long *)of_device_get_match_data(&pdev->dev);
-- 
2.43.0



