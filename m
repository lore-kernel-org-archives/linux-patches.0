Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F025E5D746;
	Tue, 23 Jan 2024 01:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974394; cv=none; b=YdsuYGdh7NbnXLv/9gpbKCBfga2Kai/9fdTpVdXH1nkwUSkwfNJQL/ebfdFp8YZPcwwyK6ylxkzPmTV1JRdED5vK6cbFCJRYrkM4QS9pjokAXnjWgAkq5UT23+6Wwo+hH37pNWXfge/4KDufd8toAFZKEMuECcD/WtFRJBqmMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974394; c=relaxed/simple;
	bh=YcnDSCiMX+EqDuC0hOx4dx+Jr1Ub/q3q9LLFL582jcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhQLDJGQThhBqYm2D7THtWvWuOETwm7aPkPv71BNdIVKbjpZcvR8xPbeJNqyrwQpH6wCLVvZSvcKUwXN2j9I1CUGAycanW5CC2a5gkkBYEiInDPjfQScXGfhPp6DNxTOvQ6tgHZ79UTTqPYr/NMiHXvxRWa9ILSs/5ETiPjS2SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mo/bLGXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mo/bLGXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE62C43390;
	Tue, 23 Jan 2024 01:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974393;
	bh=YcnDSCiMX+EqDuC0hOx4dx+Jr1Ub/q3q9LLFL582jcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mo/bLGXER2fc+epcrLmbAQsFYB7IgTGPOv4XzmhkGkFTFLsUu9aHpb2zIoovoiREO
	 gbqk0v6ncIqbNI/MoXjqMW6m6nZcv7tZVV+nO6cpwPRxL7jQCVjgye+72ib/sfwMso
	 Xbv1VL0lNsNNs36weHjKyEbZ7npVglTp5Rt4w9KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/374] media: dvb-frontends: m88ds3103: Fix a memory leak in an error handling path of m88ds3103_probe()
Date: Mon, 22 Jan 2024 15:57:43 -0800
Message-ID: <20240122235751.820637017@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e03fac025b51..fdf993da3001 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1898,7 +1898,7 @@ static int m88ds3103_probe(struct i2c_client *client,
 		/* get frontend address */
 		ret = regmap_read(dev->regmap, 0x29, &utmp);
 		if (ret)
-			goto err_kfree;
+			goto err_del_adapters;
 		dev->dt_addr = ((utmp & 0x80) == 0) ? 0x42 >> 1 : 0x40 >> 1;
 		dev_dbg(&client->dev, "dt addr is 0x%02x\n", dev->dt_addr);
 
@@ -1906,11 +1906,14 @@ static int m88ds3103_probe(struct i2c_client *client,
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



