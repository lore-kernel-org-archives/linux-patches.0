Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622418;
	b=CsXY5d+zVVpgXwWh0ITw2c0dZvI1QZWn49yXqn9oQvhg5KIQc0gqXsIbILjca6etHa1+
	 Qw9DaE44k+1x1vL67LB938cobcKNhXgw2BIjFn+IfCB2b+3Dro8+tUFA6vICV+PsKSiC8
	 Ss7FUeB6+YYeFin0w+Yaao8dXaq/oe8a9Q7/f/RMx0G49kdu6jhlCAEudcv7i/gz+KSj3
	 DfLsCN7VzKX9d6JHtZiZLGmN132ZkxoRZsVOtQGuu8QEV4e3IE02IsSQ9NCZPQooZxijj
	 OZ5JTvF2VJScga0Kz34n1BdHGna8Gs7cEn4We+csne0LLxqnZfcHRjPUuilO/xsiYCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fzWJk4saKyubotROdLYQ9hB6s0w4lhVT7AnQiO+Uv6I=;
	b=PDdBruRIUgvNDVrvQ9/ZAm2BqWfpnsq2AmFU4p4q9WWz86n0VHm7kWOuTBZwNrwFRwS+
	 QyHwnBnGiQGP2Iy1l2h7NkJbpomNSEEEVP0T24Drv4awgOis/Wi4rJfRvVg+eN3DpPsTE
	 Y5kStBi5kJicjzHJGv2xusv9YCq3A2vQ62WwCyEwtqhi5Z52oNzKrLQi5A2yD79DK6+ZG
	 g17/WqxCZQNyeXWA61pLGfbJW8NimyqYnd5lgXqMbv/MMMab11bgGzDJbGnb1Vmk/BrSi
	 ZGMPu6OFUmRXknDjSPIX21upfoYlQIOdhLibYSJhji838eyGQby21VbIVVdwUPNA5Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14gSW+Ly;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD67606A32D;
	Wed, 25 Nov 2026 16:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14gSW+Ly
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E551F000EC;
	Wed, 25 Nov 2026 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622418;
	bh=fzWJk4saKyubotROdLYQ9hB6s0w4lhVT7AnQiO+Uv6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14gSW+LyPhCQtXuA4MRxP9ErSPjUujJYU5kTx7UsQBigswR03ynDDFWU9st4DmyJp
	 lJTPnKryoSB84HjwwLILpt9N3zPWLLF8IZPzgLqsBHgF6nXoaZcwBI4L37HRUv3bkr
	 oAB4ldSxDS2+xNAf0+EZ3zJRiGvCFJrnFTbaMoHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 530/990] mfd: cs42l43: Move cancel_work_sync() into remove
Date: Wed, 25 Nov 2026 15:31:37 +0100
Message-ID: <20261125143834.507338319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 86bcfdc6f1e1f8943fbe12256b3c89a66ebbad03 ]

The cs42l43 driver kicks off a work item waiting for the device
to appear on the SoundWire bus, once the device appears the
MFD children are added and the clean up is then done through
devres. As the work is synchronised in from the devres clean
up this could lead to new devres items being added after the
clean up has started, if the driver is removed before the work
has fully completed. The work should be synchronised before any
devres clean up is started.

Fixes: 0f35dc4bd50d ("mfd: cs42l43: Use devres for remove as well")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260904131243.755201-1-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
[ sashal: changed cs42l43_sdw_remove() to return int with return 0, since this tree's sdw_driver remove callback is not void. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cs42l43-i2c.c |  8 ++++++++
 drivers/mfd/cs42l43-sdw.c | 10 ++++++++++
 drivers/mfd/cs42l43.c     | 12 ++++++++----
 drivers/mfd/cs42l43.h     |  1 +
 4 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/cs42l43-i2c.c b/drivers/mfd/cs42l43-i2c.c
index a2ab001a600ae..f0ad4002652dc 100644
--- a/drivers/mfd/cs42l43-i2c.c
+++ b/drivers/mfd/cs42l43-i2c.c
@@ -56,6 +56,13 @@ static int cs42l43_i2c_probe(struct i2c_client *i2c)
 	return cs42l43_dev_probe(cs42l43);
 }
 
+static void cs42l43_i2c_remove(struct i2c_client *i2c)
+{
+	struct cs42l43 *cs42l43 = dev_get_drvdata(&i2c->dev);
+
+	cs42l43_dev_remove(cs42l43);
+}
+
 #if IS_ENABLED(CONFIG_OF)
 static const struct of_device_id cs42l43_of_match[] = {
 	{ .compatible = "cirrus,cs42l43", },
@@ -81,6 +88,7 @@ static struct i2c_driver cs42l43_i2c_driver = {
 	},
 
 	.probe		= cs42l43_i2c_probe,
+	.remove		= cs42l43_i2c_remove,
 };
 module_i2c_driver(cs42l43_i2c_driver);
 
diff --git a/drivers/mfd/cs42l43-sdw.c b/drivers/mfd/cs42l43-sdw.c
index 023f7e1a30f8c..3938d48039c48 100644
--- a/drivers/mfd/cs42l43-sdw.c
+++ b/drivers/mfd/cs42l43-sdw.c
@@ -187,6 +187,15 @@ static int cs42l43_sdw_probe(struct sdw_slave *sdw, const struct sdw_device_id *
 	return cs42l43_dev_probe(cs42l43);
 }
 
+static int cs42l43_sdw_remove(struct sdw_slave *sdw)
+{
+	struct cs42l43 *cs42l43 = dev_get_drvdata(&sdw->dev);
+
+	cs42l43_dev_remove(cs42l43);
+
+	return 0;
+}
+
 static const struct sdw_device_id cs42l43_sdw_id[] = {
 	SDW_SLAVE_ENTRY(0x01FA, 0x4243, 0),
 	{}
@@ -200,6 +209,7 @@ static struct sdw_driver cs42l43_sdw_driver = {
 	},
 
 	.probe		= cs42l43_sdw_probe,
+	.remove		= cs42l43_sdw_remove,
 	.id_table	= cs42l43_sdw_id,
 	.ops		= &cs42l43_sdw_ops,
 };
diff --git a/drivers/mfd/cs42l43.c b/drivers/mfd/cs42l43.c
index 13d446755fe20..e875154e8d813 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -1037,15 +1037,19 @@ static int cs42l43_power_down(struct cs42l43 *cs42l43)
 	return 0;
 }
 
-static void cs42l43_dev_remove(void *data)
+static void cs42l43_dev_power_down(void *data)
 {
 	struct cs42l43 *cs42l43 = data;
 
-	cancel_work_sync(&cs42l43->boot_work);
-
 	cs42l43_power_down(cs42l43);
 }
 
+void cs42l43_dev_remove(struct cs42l43 *cs42l43)
+{
+	flush_work(&cs42l43->boot_work);
+}
+EXPORT_SYMBOL_NS_GPL(cs42l43_dev_remove, "MFD_CS42L43");
+
 int cs42l43_dev_probe(struct cs42l43 *cs42l43)
 {
 	int i, ret;
@@ -1092,7 +1096,7 @@ int cs42l43_dev_probe(struct cs42l43 *cs42l43)
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(cs42l43->dev, cs42l43_dev_remove, cs42l43);
+	ret = devm_add_action_or_reset(cs42l43->dev, cs42l43_dev_power_down, cs42l43);
 	if (ret)
 		return ret;
 
diff --git a/drivers/mfd/cs42l43.h b/drivers/mfd/cs42l43.h
index f3da783930f53..8d1b1b0f5a473 100644
--- a/drivers/mfd/cs42l43.h
+++ b/drivers/mfd/cs42l43.h
@@ -25,5 +25,6 @@ bool cs42l43_precious_register(struct device *dev, unsigned int reg);
 bool cs42l43_volatile_register(struct device *dev, unsigned int reg);
 
 int cs42l43_dev_probe(struct cs42l43 *cs42l43);
+void cs42l43_dev_remove(struct cs42l43 *cs42l43);
 
 #endif /* CS42L43_CORE_INT_H */
-- 
2.53.0



