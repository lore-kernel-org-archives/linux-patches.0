Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448C34164B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301171; cv=none; b=NZIx2Jl9q1WkEgKhRttvnhpvYvccfjzvVyBep5yac7X7ULQ8pKwp2eq8GSbBviTQSq5g4DuXEodKJMsbQLaBHMOJUZtdEiPKa2pI2vJC/sttbuGJ6LuPh4vZWCn6iLotHHjh0WEZoAoe7RTaphICtRxXg9SUhlhkD4h3jYX+CRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301171; c=relaxed/simple;
	bh=vDZ/7HLswCBu3RNHT/Isx3jQGWhJcnEeUc0aAdaKRdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXtoOmHQFPWraBItmOq9DotA++GFVutjfgscYtm+JFNJqtyYpBFkSUyuLypTElWTJuQUYSa71FX7jr/k2K32zn9B//nvAcIrf6sUrBj5WZVVtng+Z0o5sKGvzda7RIzlX4LQ87Yo+8ka4NbBEgXEh/ZziqN+9zKSDrEU/mavN24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jfvbmql5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jfvbmql5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE91C19423;
	Sat, 28 Feb 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301171;
	bh=vDZ/7HLswCBu3RNHT/Isx3jQGWhJcnEeUc0aAdaKRdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jfvbmql5egebDkUmfbwtNf/wnOzcSMYcfThtG5wtBp/Y3cJ5oWuoXQ+Rx2tZcYwia
	 fBrKotlmqATzl4XAHqEv+1/cDxUNZNYJOBFOT1Z5H0mgyo3BCBmmxrhvzFNpb9Zvy0
	 YCSHgFUWc6mKOJMh1Vnn5EL/FhdeSInjkWPsZb0VafNQPQCqqpM9x0G0h9HJ4odZKP
	 OZvoOlD0Br5a2ApNGge8fNHGx9/T+ZRs79A0RsniN0yhQP7/OGBfNv5wo8ole3lCpH
	 2KSvDkkhp1kQRocpSoAD397+kzOVzw2Cy55rBZVJHov5g313ptMadGL5hHTw0pMt5R
	 jrypJP5ZPvwaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <gu_0233@qq.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 338/752] misc: ti_fpc202: fix a potential memory leak in probe function
Date: Sat, 28 Feb 2026 12:40:49 -0500
Message-ID: <20260228174750.1542406-338-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit dad9f13d967b4e53e8eaf5f9c690f8e778ad9802 ]

Use for_each_child_of_node_scoped() to simplify the code and ensure the
device node reference is automatically released when the loop scope
ends.

Signed-off-by: Felix Gu <gu_0233@qq.com>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://patch.msgid.link/tencent_FA1AC670F5CF49873F88A44424F866994A08@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ti_fpc202.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/ti_fpc202.c b/drivers/misc/ti_fpc202.c
index 7964e46c74482..8eb2b5ac98506 100644
--- a/drivers/misc/ti_fpc202.c
+++ b/drivers/misc/ti_fpc202.c
@@ -309,7 +309,6 @@ static void fpc202_remove_port(struct fpc202_priv *priv, int port_id)
 static int fpc202_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
-	struct device_node *i2c_handle;
 	struct fpc202_priv *priv;
 	int ret, port_id;
 
@@ -357,7 +356,7 @@ static int fpc202_probe(struct i2c_client *client)
 
 	bitmap_zero(priv->probed_ports, FPC202_NUM_PORTS);
 
-	for_each_child_of_node(dev->of_node, i2c_handle) {
+	for_each_child_of_node_scoped(dev->of_node, i2c_handle) {
 		ret = of_property_read_u32(i2c_handle, "reg", &port_id);
 		if (ret) {
 			if (ret == -EINVAL)
-- 
2.51.0

