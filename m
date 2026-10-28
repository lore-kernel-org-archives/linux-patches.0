Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209043;
	b=faNG5fHa4xe/p2WIHIaVkGFDP5C4Iffz1HAepk4z+xc9qrgWCKj/JkmvGlnBVkj5UmNj
	 0WczyE54+sw/frshkQ7jf6xmeF4lzCS1ks8mHCPXWKIdAzSNX0KZ0sqDq/mE0yRWxj/kJ
	 dyL/xZMlhaKseGeYfKPIh3wYa+Gsj/9aHuJJwQYOyXkDrx2B6jg7A9We4PGJMCRHp7x/J
	 B31kt90Bm18IQzVixSD5QQ5mM0fMSYw8PXatawgBlexyAUHoJOIThOkXwpmF6OaLGoOag
	 f5ph/NBe02lc22X/tb7vXPEDXozOA8RdUPBlrX7Btehg1Qq94ybKs2QPG9rj7EQrDIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NHeCcPB1RMb0ro++bkIdHp6M9hy8JKGRqQ7NVwgK32M=;
	b=zpJYLa0RIJJs9me+dMUcurDsX0sxWOFV1CrkX8hH4S2kaq7x9iUlkxkyrbr/JT3wyCT4
	 PcKiwyrUdHj0udqLhROkBTVHOXjKqxvB51p5V08g2T2Rgrf84/6WEe1mCjt/gJas08Ph+
	 Q92LVYbsNA+0N5X2IPQ6dgNb7UBkTuPub0yhBSDTMN11/itqefl7VSaFdmu+zN/c/z9Xr
	 MfzviA0fhteh2CwDCGTMFOBK7Iitf74t3OfiKco5xiuDSAslXw1nWF2NAMUTW4HbicB4P
	 qwnKSNFjq/8UFJIHYzSVbMiOKl5Uq6MJgz84Kje2y13uKqJDZb9onqiW4wENLlAtEPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJI1IipD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B476660A2613;
	Wed, 28 Oct 2026 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJI1IipD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CB91F031E7;
	Wed, 28 Oct 2026 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209042;
	bh=NHeCcPB1RMb0ro++bkIdHp6M9hy8JKGRqQ7NVwgK32M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJI1IipD4LtNjKUJKlBGTY2QClhUnqQcR9QL4dM+u6fPXj3qbvWmnSRpc5bpfw13K
	 BjgELOaYA59ak8eDDqTka6bmnJqbI+sUMF4akcFQP5J9upNfnaBsNUcld8E/B1a6kQ
	 yXRAVP4LB2Tlj1XRL4+Duc7ufhymq5+cBsKJRKcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/516] Input: s6sy761 - fix resume ordering and restore sensing
Date: Wed, 28 Oct 2026 17:57:21 +0100
Message-ID: <20261028170010.340482835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit a215720959c5450b3699e243904b39c3f8f68888 ]

System suspend powers the controller off and resume powers it back on,
but the resume path enables the interrupt before s6sy761_power_on()
checks the boot. The firmware raises its boot-complete event on the
interrupt line, the threaded handler consumes it, s6sy761_power_on()
then reads an empty event and resume fails with -ENODEV, skipping the
touch function setup:

s6sy761 2-0048: PM: dpm_run_callback(): s6sy761_resume [s6sy761] returns -19

Power the chip on first and only then unmask the interrupt. Once resume
completes the boot handshake the chip comes back with sensing off, as
at probe where input_open() turns it on, so the touchscreen stays dead
after resume. Send SENSE_ON again when the input device is open.

Tested on a Pixel 3 XL over several s2idle cycles: resume succeeds and
the touch function and sense status match the pre-suspend state.

Assisted-by: LLM
Cc: stable@vger.kernel.org
Fixes: 0145a7141e59 ("Input: add support for the Samsung S6SY761 touchscreen")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260926-s6sy761-suspend-v2-1-8f00a96ee6e8@ixit.cz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Replaced the guarded input_device_enabled() check with sdata->input->users under explicit mutex locking. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/s6sy761.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/s6sy761.c b/drivers/input/touchscreen/s6sy761.c
index 85a1f465c097e..459513b5da61b 100644
--- a/drivers/input/touchscreen/s6sy761.c
+++ b/drivers/input/touchscreen/s6sy761.c
@@ -510,10 +510,22 @@ static int __maybe_unused s6sy761_suspend(struct device *dev)
 static int __maybe_unused s6sy761_resume(struct device *dev)
 {
 	struct s6sy761_data *sdata = dev_get_drvdata(dev);
+	int err;
+
+	err = s6sy761_power_on(sdata);
+	if (err)
+		return err;
 
 	enable_irq(sdata->client->irq);
 
-	return s6sy761_power_on(sdata);
+	mutex_lock(&sdata->input->mutex);
+
+	if (sdata->input->users)
+		err = i2c_smbus_write_byte(sdata->client, S6SY761_SENSE_ON);
+
+	mutex_unlock(&sdata->input->mutex);
+
+	return err;
 }
 
 static const struct dev_pm_ops s6sy761_pm_ops = {
-- 
2.53.0



