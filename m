Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043649;
	b=bIMMzn5Avz/EIpUH9/8LPOQRK/yXoa8qoBJdrvB2oMIax6adgkQqBQZPhG84qEjaRB26
	 an4qdiD1XTEEdowmkmJ1uqdfFoK/VzShGoWQwulTJzeGQ9A15gp1Kd2Kc62jWe2iiNrwv
	 86D5e+mY4XO/60s42WHZ9PnXqcjmX9lEdQbYyquWcglFmoohU7GRaaTMPC3Yv0BtnNa0A
	 1lONxF7QRyYpJVE3VElxuHaxi2bPTO8OwcsJdWKC954yu0xP4ydmsiQE2CfdQVQ+ebfMH
	 I5ArBvO4uzj1pFVMPHhEw9Y5HzgWA3CYijuH28Sb5sRJaIU4XlOJVIIWPe0FLXoR/MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2pH0UqHt2sZ92rH2gdeHQpIukIRSzLdtzfkDsIkH9zU=;
	b=uVKXYAODtp1V/mxcfWCascxUfragNz5OiTBi4znbI51n2zO8W2HSejc0ZJ3UtZC3kyV7
	 2wzj1tU00NgSk3SQMlqob3nURlv3G+yc9sVKJN2lUVkz8UHFGwWKUKA1xb+6vWd0844SV
	 vS0yV16weZynCktDZTGGjS47IZpxiLTF17WoOQOeZNaHIOkO5KZxwbll+Ie1lhqMp0dB3
	 snlCpHX+c9g0NAv/XFShvET3TaAFP8lx3/F47fVyf2BArrTjB1D4UeDTDfHyQJuWexBf4
	 xG4gc3FsPK21j3fhE+dgf8/vyIvhW1uOQstezhjDQjeqc3ULgdugF5JfnCtKO+sB5AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyOTAl6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3565606A333;
	Wed, 18 Nov 2026 23:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyOTAl6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407A01F000C4;
	Wed, 18 Nov 2026 23:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043648;
	bh=2pH0UqHt2sZ92rH2gdeHQpIukIRSzLdtzfkDsIkH9zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyOTAl6qX5xK3ikKfRLvIGpA1tXtsFMTTkTsmR1hk495sdVTZxzesswq/PC+yvNEe
	 +UmtFEqk1uO8erKMB33x4NA9myJHSkEvlVh3AZeNa8wR6LJEDaO1w+oCfYR00du2X6
	 hp/ZeNeF+hOY5a8T7o+pmB8AMod0vCTI11bS0em0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0286/2857] HID: roccat: fix locking in roccat_connect() and roccat_disconnect()
Date: Wed, 18 Nov 2026 15:22:00 +0100
Message-ID: <20261118150211.718101877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d76994443eed0af297cb82bd038ae9d76327ef90 ]

Extend critical section in roccat_connect() to ensure that partially
initialized 'struct roccat_device' is never exposed in 'devices' list,
and do the same in roccat_disconnect() to avoid racy 'devices' access
against roccat_release().

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index a73cafa3869f7..b203ee39c9ea1 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -344,8 +344,6 @@ int roccat_connect(struct class *klass, struct hid_device *hid, int report_size)
 		return temp;
 	}
 
-	mutex_unlock(&devices_lock);
-
 	init_waitqueue_head(&device->wait);
 	INIT_LIST_HEAD(&device->readers);
 	mutex_init(&device->readers_lock);
@@ -356,6 +354,7 @@ int roccat_connect(struct class *klass, struct hid_device *hid, int report_size)
 	device->cbuf_end = 0;
 	device->report_size = report_size;
 
+	mutex_unlock(&devices_lock);
 	return minor;
 }
 EXPORT_SYMBOL_GPL(roccat_connect);
@@ -369,15 +368,12 @@ void roccat_disconnect(int minor)
 
 	mutex_lock(&devices_lock);
 	device = devices[minor];
-	mutex_unlock(&devices_lock);
 
 	device->exist = 0; /* TODO exist maybe not needed */
 
 	device_destroy(device->dev->class, MKDEV(roccat_major, minor));
 
-	mutex_lock(&devices_lock);
 	devices[minor] = NULL;
-	mutex_unlock(&devices_lock);
 
 	if (device->open) {
 		hid_hw_close(device->hid);
@@ -385,6 +381,8 @@ void roccat_disconnect(int minor)
 	} else {
 		roccat_free_device(device);
 	}
+
+	mutex_unlock(&devices_lock);
 }
 EXPORT_SYMBOL_GPL(roccat_disconnect);
 
-- 
2.53.0



