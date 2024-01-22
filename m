Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D84442E;
	Tue, 23 Jan 2024 00:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969591; cv=none; b=IoUZTWAMXGdEW2a1BGNwGAxGyqhrwRUK8hVHCqv1Nd4kkivNagZl1pGcF0uZHjQAYq6yLx+xWh/l/q+4pBmzrmmX/qIUnXXQHL3OWQUPebZ1zvqt/yVfDodoYWw6IH3b6Vi5PUSbrgd3TUXsfyceHGzFSLLyLmNeauJGGbvqFCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969591; c=relaxed/simple;
	bh=EVZ2VrUJuios9yHW31Lt+ySYvNDg3pMxW0N5FcWzoio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn/+8kYhnAMWkqgCzANxRRk9ZrUeGwhiB/6yg3qIsiR9ach0xVMSEusvH44RsIfUuiJgNZdxQJgj2FrkBWKkK+eRotkk7E0xX3nedExcYNXCFeuC2+vF2dO5EP7FFXRH5UkLy7x/jGcqg0n+FVxhsJvkySrJsn5PbH24vCXQCLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9gFJ/dW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9gFJ/dW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7344C43390;
	Tue, 23 Jan 2024 00:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969591;
	bh=EVZ2VrUJuios9yHW31Lt+ySYvNDg3pMxW0N5FcWzoio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9gFJ/dW4n82H+634AY+SobIqFMcgTyeJDV814GsD7jh+9m2ALtkctvf7vtCEfluT
	 cq6aQj0ufrVlsL/xbPjs6t4IbyKvqPG40UWjYHpqn/Duypjioi/ICY8uS84mwbiYAK
	 wevP5WteaWYmzs17glMlc1Djcy1elKxTHrTQWrtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 318/641] media: dvb-frontends: m88ds3103: Fix a memory leak in an error handling path of m88ds3103_probe()
Date: Mon, 22 Jan 2024 15:53:42 -0800
Message-ID: <20240122235827.831294549@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5b2f885e2f6f482d05c23f04c8240f7b4fc5bdb5 ]

If an error occurs after a successful i2c_mux_add_adapter(), then
i2c_mux_del_adapters() should be called to free some resources, as
already done in the remove function.

Fixes: e6089feca460 ("media: m88ds3103: Add support for ds3103b demod")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/m88ds3103.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 26c67ef05d13..e0272054fca5 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1894,7 +1894,7 @@ static int m88ds3103_probe(struct i2c_client *client)
 		/* get frontend address */
 		ret = regmap_read(dev->regmap, 0x29, &utmp);
 		if (ret)
-			goto err_kfree;
+			goto err_del_adapters;
 		dev->dt_addr = ((utmp & 0x80) == 0) ? 0x42 >> 1 : 0x40 >> 1;
 		dev_dbg(&client->dev, "dt addr is 0x%02x\n", dev->dt_addr);
 
@@ -1902,11 +1902,14 @@ static int m88ds3103_probe(struct i2c_client *client)
 						      dev->dt_addr);
 		if (IS_ERR(dev->dt_client)) {
 			ret = PTR_ERR(dev->dt_client);
-			goto err_kfree;
+			goto err_del_adapters;
 		}
 	}
 
 	return 0;
+
+err_del_adapters:
+	i2c_mux_del_adapters(dev->muxc);
 err_kfree:
 	kfree(dev);
 err:
-- 
2.43.0



