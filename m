Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B3414A088;
	Tue,  3 Dec 2024 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242038; cv=none; b=YvRTdRVXWaTa66z+TQ3LjP/2nuCDMHo2Zzv/vXMfl4MyoQkOCNHKKW4bIJzT7fxDo/los4PSgYqdXwH8/Siu9UflChQk97SBAyFyVk+0k0R+0rWjzRerbiYcksgAVh6oG24EyvdDWom+hpV1z7V1Dbq49JUZPESriURNmoVMlMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242038; c=relaxed/simple;
	bh=lNBYxpwpn/PLIw6NJk3JKgt0MgiM2U5PKwWgSGvqfcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyVoLKMDQlG+SPcOq2a6mpyjIp2lrgCNC4KWN/OCvz+aViK+NVy9Sy0+Dpz9vQ5kA8Sw8X3h4KF6cJZJ8NOlZshKZYcKQm3ukvVegUbEsRDZPnNuzSmyyonnGJAmNSdJwJZpO1ztE2hLymKKpeg8v0ogqV/1GwOTdGESTxNEZfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+6Grh1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+6Grh1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C7C4CECF;
	Tue,  3 Dec 2024 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242038;
	bh=lNBYxpwpn/PLIw6NJk3JKgt0MgiM2U5PKwWgSGvqfcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+6Grh1FjBdvHNOerzMvGdkDcZsN2d+4Cxsy2zbAM0nzI/Ev4+yhmbrnfCWieH+/v
	 xFiGKC5VIVPgMiOZFqIK3AP91JDEzrh9DWn1DloquhMet+JkaH4DSFySqOkjuuHTOT
	 a6vvrO5kD2nGAgDEBEDhe9c1f9KS4IyObN/L84VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 590/826] iio: light: al3010: Fix an error handling path in al3010_probe()
Date: Tue,  3 Dec 2024 15:45:17 +0100
Message-ID: <20241203144806.763710196@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a4b7064d34186cf4970fe0333c3b27346cf8f819 ]

If i2c_smbus_write_byte_data() fails in al3010_init(),
al3010_set_pwr(false) is not called.

In order to avoid such a situation, move the devm_add_action_or_reset()
witch calls al3010_set_pwr(false) right after a successful
al3010_set_pwr(true).

Fixes: c36b5195ab70 ("iio: light: add Dyna-Image AL3010 driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/ee5d10a2dd2b70f29772d5df33774d3974a80f30.1725993353.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/al3010.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/light/al3010.c b/drivers/iio/light/al3010.c
index 53569587ccb7b..7cbb8b2033009 100644
--- a/drivers/iio/light/al3010.c
+++ b/drivers/iio/light/al3010.c
@@ -87,7 +87,12 @@ static int al3010_init(struct al3010_data *data)
 	int ret;
 
 	ret = al3010_set_pwr(data->client, true);
+	if (ret < 0)
+		return ret;
 
+	ret = devm_add_action_or_reset(&data->client->dev,
+				       al3010_set_pwr_off,
+				       data);
 	if (ret < 0)
 		return ret;
 
@@ -190,12 +195,6 @@ static int al3010_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	ret = devm_add_action_or_reset(&client->dev,
-					al3010_set_pwr_off,
-					data);
-	if (ret < 0)
-		return ret;
-
 	return devm_iio_device_register(&client->dev, indio_dev);
 }
 
-- 
2.43.0



