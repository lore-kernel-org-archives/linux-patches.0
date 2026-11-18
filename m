Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021419;
	b=OBA4Az0WuHbezvpEyLIemWOvqSpwAg//CMG80X3rvdC7mC+C2zY0jC12Hcqdcct7XexD
	 9Tp8mmB0byDxm1Rd9LN6rPNPpSkW0IuPVD9lfruYonoArPjnirx22khYe0BzNfJVpHXO5
	 OLvSiXcPVIwb7hR2nbD0FLZtUX1AhidjkEKxV3j7+Ac3cYK1kxUGtRGMyc34vfKoFQZgd
	 Ijug2BqVSy2Jxo6m/Pv9o6/jS19t4AMpkuc/frW2vBz1OzkJRRRW1uEPJeZysENmoh0G3
	 5c4WKPyRB754YaGwMk2rX9d0qki0VVy2jGBydAwjCb+Zkol0DCsgkhGtzc5quxD2o3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cg6KzpWfafCr47hQLhEl3fTZokz6DupS0oFmMdU9Rek=;
	b=Gz/UU7xSTC7mUwbuBx6sHJgdBp8fZxmsrXecMRTQW/FcRneZKfjCAxIHOcQxBujsZc8o
	 eawIxv9yXQ7N07hyh4+vmapJq5TYy9U7TbPQuOkCS727H5TeI1Nwc8rDWIp8wSN4wocaY
	 JeJZ0Y132pqEVxK4SL48OnMBwsnGfYL7lR0K6uikMz5p+izgXlEeePPOqJ9gG1J2QHTTm
	 z+mWFUbhiHeir2vugv9c8ydWqJp9SNt2aJaxHJh4WjQJtnYD6hz59IwBguWYH4PCF3iu1
	 6iAfU2vlz0zbfX7OaaMCSjGgfELHFd6URlEUY2jQ+5PbZelmX5LhMKPxG4+oIl0dpkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdjuq0Am;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63C160A262A;
	Wed, 18 Nov 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdjuq0Am
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09C61F000CA;
	Wed, 18 Nov 2026 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021419;
	bh=Cg6KzpWfafCr47hQLhEl3fTZokz6DupS0oFmMdU9Rek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdjuq0AmUT1P6ZTaR7MG0WYDX/4vGaua8SDyZ66QtQ2HLdZH8zmpyxMCNy/6Lt1KC
	 3IUnwsu/P+obzEr4EjeDp/MGmzOzqUXKJeYT5lzKZV0EXVlRq44O5Z0zG9ZrrRx8mz
	 w1Pygyy2Br3pq+vSxxlNuITMJeMcgUiM/KSAND2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Carlo Szelinsky <github@szelinsky.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2300/2651] net: pse-pd: si3474: fix use-after-free in ancillary client error path
Date: Wed, 18 Nov 2026 15:59:00 +0100
Message-ID: <20261118150408.019094398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1845b9c51cf7a..2f4f241a48af6 100644
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



