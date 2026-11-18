Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027626;
	b=n/0CCSyFEccNQ4K9FF276UoyXNccGYBj265IMDPiQop5tYY9szkyv435tpovstE3dFkl
	 mMSn/ruQ9SlXvboRUu6/Pjwj62e0MFJEm8eJiKZHX/s5aaC3aSoibxqyjE8CxcieKN8D4
	 +6ogJubligqxVDRkC6JFx5J0t7BzS2Uw4xcYPw28Eo0QEyqZTMfN5HfRw56Q+58WYK+Ep
	 wQmn/fpi3NdyrS9NOgpeDWY1ZfLIVYJr93ZBsKmOxPTCtSA03x/uWNL7YJK4BYEmJI2l4
	 FAsMfn7wihtVZOd//AvYLLQZ65E85mExNCw+yDjLj+Umy47FniIH8CPRysE+w83sbZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5yA0MS8wn1mzyBjBg4BqhObAVvVAYyfSV54aKQKbmf8=;
	b=RrboKZwS8AEoQLb2eG/XQ0LR9IlLD5OXZN9olQTU+DscWiXYsSdhe4NVOg6jHGtvs+zj
	 8F0jWn2Sc60MiZ6FKicsZnpjiIFJpabfOIOHsfaVD5a5RfXXrOb1Laz+RVN72EwxiBo9j
	 JuGaCku7L6N7XH0T7UgXXFEo/49pH5YZwbPLawElg0iGmpBvkpxjpriHXxg7wxkJTkTsk
	 DmMiH+oUKgGhHFiR1jYuaqvk3x5Y2YOMWIIHTq64ItHGJ87b/Kce2OglKuL2jZPskedoD
	 23eMBq6o1U9xUww60GtUZ/N2od8p+pefXEVFWKR7gvx1JZbRaESKUrgtTMmZcZzq0Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LThROFap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E499606A333;
	Wed, 18 Nov 2026 18:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LThROFap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8581F000C4;
	Wed, 18 Nov 2026 18:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027626;
	bh=5yA0MS8wn1mzyBjBg4BqhObAVvVAYyfSV54aKQKbmf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LThROFap1EJ1FpSisEjh/PjN+zwDMZNYSjdkpjz7bT77SPQdeuDsCI8kLpa9qXlvT
	 S3Puoq4awRZ7tDkpzYvqhMo41EOK5OWjOglE3SCGQtiFdtoX16mOHRBl+dhVG1o0g9
	 pY8scFZk5IlK0xvDo7AaexTO09yTd2PPaB8heXQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Carlo Szelinsky <github@szelinsky.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1855/2151] net: pse-pd: si3474: fix use-after-free in ancillary client error path
Date: Wed, 18 Nov 2026 15:59:50 +0100
Message-ID: <20261118150229.368909490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlo Szelinsky <github@szelinsky.de>

[ Upstream commit 70c29b35fd87f87a7b8dad6eb8d55ce54a0d549a ]

If devm_add_action_or_reset() fails, it has already unregistered the
ancillary I2C client, and the error message then reads that client's
device. It can only fail with -ENOMEM, which is already reported, so
drop the message.

Found by code inspection. Not reproduced.

Fixes: a2317231df4b ("net: pse-pd: Add Si3474 PSE controller driver")
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Signed-off-by: Carlo Szelinsky <github@szelinsky.de>
Link: https://patch.msgid.link/20261020171134.852878-2-github@szelinsky.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/si3474.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/pse-pd/si3474.c b/drivers/net/pse-pd/si3474.c
index aa07ffbce54d7..77c3e92a154b7 100644
--- a/drivers/net/pse-pd/si3474.c
+++ b/drivers/net/pse-pd/si3474.c
@@ -516,10 +516,8 @@ static int si3474_i2c_probe(struct i2c_client *client)
 		return PTR_ERR(priv->client[1]);
 
 	ret = devm_add_action_or_reset(dev, si3474_ancillary_i2c_remove, priv->client[1]);
-	if (ret < 0) {
-		dev_err(&priv->client[1]->dev, "Cannot register remove callback\n");
+	if (ret)
 		return ret;
-	}
 
 	ret = i2c_smbus_read_byte_data(priv->client[1], VENDOR_IC_ID_REG);
 	if (ret < 0) {
-- 
2.53.0



