Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629571F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958CCC433C9;
	Fri, 21 Jul 2023 16:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955861;
	bh=VmYeCPCHsVtjH7JQm/J2L2HfMN9n6FsfzYsiipcUjDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTLBxizjKqTgAyzFnglgH8LVAGIWCnK57voeL9LHb8t00fa2zzGyJlBQiWG3AUuWp
	 0WgOlR6+6oGWaEdYYOqKS0b3pwa8+w4MpSrNn3L5vfqvSIHeV1GR72nVo3gXsuTCI/
	 zvKoOO3kNW1Hv+J5KknGUqV5OPollFprQ0x6Slo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 056/292] s390/ism: Do not unregister clients with registered DMBs
Date: Fri, 21 Jul 2023 18:02:45 +0200
Message-ID: <20230721160531.205665563@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 266deeea34ffd28c6b6a63edf2af9b5a07161c24 ]

When ism_unregister_client() is called but the client still has DMBs
registered it returns -EBUSY and prints an error. This only happens
after the client has already been unregistered however. This is
unexpected as the unregister claims to have failed. Furthermore as this
implies a client bug a WARN() is more appropriate. Thus move the
deregistration after the check and use WARN().

Fixes: 89e7d2ba61b7 ("net/ism: Add new API for client registration")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index d65571b3d5cad..6db5cf7e901f9 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -96,29 +96,32 @@ int ism_unregister_client(struct ism_client *client)
 	int rc = 0;
 
 	mutex_lock(&ism_dev_list.mutex);
-	mutex_lock(&clients_lock);
-	clients[client->id] = NULL;
-	if (client->id + 1 == max_client)
-		max_client--;
-	mutex_unlock(&clients_lock);
 	list_for_each_entry(ism, &ism_dev_list.list, list) {
 		spin_lock_irqsave(&ism->lock, flags);
 		/* Stop forwarding IRQs and events */
 		ism->subs[client->id] = NULL;
 		for (int i = 0; i < ISM_NR_DMBS; ++i) {
 			if (ism->sba_client_arr[i] == client->id) {
-				pr_err("%s: attempt to unregister client '%s'"
-				       "with registered dmb(s)\n", __func__,
-				       client->name);
+				WARN(1, "%s: attempt to unregister '%s' with registered dmb(s)\n",
+				     __func__, client->name);
 				rc = -EBUSY;
-				goto out;
+				goto err_reg_dmb;
 			}
 		}
 		spin_unlock_irqrestore(&ism->lock, flags);
 	}
-out:
 	mutex_unlock(&ism_dev_list.mutex);
 
+	mutex_lock(&clients_lock);
+	clients[client->id] = NULL;
+	if (client->id + 1 == max_client)
+		max_client--;
+	mutex_unlock(&clients_lock);
+	return rc;
+
+err_reg_dmb:
+	spin_unlock_irqrestore(&ism->lock, flags);
+	mutex_unlock(&ism_dev_list.mutex);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ism_unregister_client);
-- 
2.39.2



