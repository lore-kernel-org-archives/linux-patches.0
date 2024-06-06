Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C77F1A0DD7;
	Thu,  6 Jun 2024 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683168; cv=none; b=nP8jexmjfp5zaCBYfRSQf7yO82RDO/cX6c5gjH/r5dB3afXekxKyx6BuDDrtO9KZb1XjFG0Bqs8c0p18B1vubJlWowshfA7ZZ2Vi7U1u1PX7t177ZpVg+eAnTwgCR9Zd2SaMP9hNV1yyJXNVRdsAUZKVvd5cgYBAcK724fbteRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683168; c=relaxed/simple;
	bh=Pm+HdvO571aKd8ku0p31bBbAw8S2KI6glZC38l8LRzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC3J7MQ9TpiAhm2u9If0WQFQ3Sq07aRKWkQ6Bwz5FFILh7VrctQNC+Ip0yepOLTTnqTcBa/0Jp5Z3CqY36VsVpRh0ailM16280hj3abR0IWK5OnBnp8DnyT3rNAv0xypkRsGmclQdF/tMPZVRkrekgOwISLCe/8a7OavfaWqEmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcowRdBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcowRdBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FF7C2BD10;
	Thu,  6 Jun 2024 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683168;
	bh=Pm+HdvO571aKd8ku0p31bBbAw8S2KI6glZC38l8LRzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcowRdBDVY7aL0JpvTqODp++13OdV2b5gL5fX0gZey7bv6PdXoKns+EXoGyUOWdO4
	 L4L9G4eedzNIgvAcPMQ5Ko5wYoucJ635BUiqmi5nd/K+aMqDdOF8sh4alRqJfeNgqL
	 sBy+52uBK5uxwkj5glf24bYpCV3uKvdRrkm9RGRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xilin Wu <wuxilin123@gmail.com>
Subject: [PATCH 6.6 113/744] soc: qcom: pmic_glink: dont traverse clients list without a lock
Date: Thu,  6 Jun 2024 15:56:25 +0200
Message-ID: <20240606131736.025855488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 635ce0db89567ba62f64b79e8c6664ba3eff6516 ]

Take the client_lock before traversing the clients list at the
pmic_glink_state_notify_clients() function. This is required to keep the
list traversal safe from concurrent modification.

Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Tested-by: Xilin Wu <wuxilin123@gmail.com> # on QCS8550 AYN Odin 2
Link: https://lore.kernel.org/r/20240403-pmic-glink-fix-clients-v2-1-aed4e02baacc@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index d5a4e71633ed6..c6dca5278e61b 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -118,10 +118,12 @@ static int pmic_glink_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 
 	hdr = data;
 
+	mutex_lock(&pg->client_lock);
 	list_for_each_entry(client, &pg->clients, node) {
 		if (client->id == le32_to_cpu(hdr->owner))
 			client->cb(data, len, client->priv);
 	}
+	mutex_unlock(&pg->client_lock);
 
 	return 0;
 }
@@ -171,8 +173,10 @@ static void pmic_glink_state_notify_clients(struct pmic_glink *pg)
 	}
 
 	if (new_state != pg->client_state) {
+		mutex_lock(&pg->client_lock);
 		list_for_each_entry(client, &pg->clients, node)
 			client->pdr_notify(client->priv, new_state);
+		mutex_unlock(&pg->client_lock);
 		pg->client_state = new_state;
 	}
 }
-- 
2.43.0



