Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061082;
	b=p/mObhlR/JzkIR1BrVyw+axWwwzusLiyFztFbBKLLUMkb6JZdJJAp+2+nbX9FOwlNqAZ
	 OLQ8ep6kjUzXuWfScX9m+p1LYPX4QMF44Y2XBTSIXI1IXAPa84wiiKH9O/zjulsNq41e8
	 +E6t+7Ebq3tDORYxlT1PWO5Yib8/7whIp4hSVHIZPdW51Ps2oc/yJTTguPOhCy34LqGXP
	 u8psTa4MqKBxHk10sap4aAIc+3QbXk9I+aaoAYeKSAFXLxwpC8CCWNwUiFLqNC/QcpXHw
	 3/nuPR0INqrq6DSAoVQK64bZScgPXzxWlzUfkzIfcUFIOGEAjC1bZZ9n5PLEsYZK2ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ut7ysjcqfF6pH1HORKObYej8iRRszCGiL55uWEy5TTo=;
	b=lnjYJzqtpZ+7CcprGBsNSm7t6mUfXhkm4mC1q6mMa2cAHTMgLpJKjkvHPf/sCRnK6zsv
	 mHzRT3xRspuxnnNyIrdvPax7wVX84nf39RWwv1fCAFlqFPe4ZNG0UJrP3Wvopmsz1gn4x
	 kVa+vDKcCbNynEZa0H96iXuDgo7a8L0cMPlsIhR1jYIQwhB/EsYXaT3lzesV7srQzCHi/
	 a4wdg2sMMjUu4VYQg5rMguPUUffpaYIYatGQEjHbKpzR2OC+QI4lDkZz55nTZxA3kYpdD
	 KPkqM7aWaBrJcmSM2AdIZU5xNs2lEXBEjOXlWEwxXOL9CPDZ2eeoNHgTNCO4lds4c0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0V4PV219;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57327606EEA0;
	Sat,  7 Nov 2026 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0V4PV219
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154D11F0089F;
	Sat,  7 Nov 2026 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061082;
	bh=Ut7ysjcqfF6pH1HORKObYej8iRRszCGiL55uWEy5TTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0V4PV219AxiLMV4J3ZKBetfc+POmsR81WlZfUdFZgraCwdoHvTnbPPk3JrR81QkCj
	 GsK5+zuSx3tZyRIBNsY4i9tweaad1Siqb49PW63ofXc2YM/o4Jk8gUIjZvvnbe4bgO
	 A7NWgbmOjeAh9mTDqZIxmUy9CPn3M5Dnv7zk0Os4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0405/1536] HID: roccat: fix locking in roccat_connect() and roccat_disconnect()
Date: Sat,  7 Nov 2026 08:40:21 -0500
Message-ID: <20261107135008.956746850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e54b6a8a92ef7..77042c7edf765 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -344,8 +344,6 @@ int roccat_connect(const struct class *klass, struct hid_device *hid, int report
 		return temp;
 	}
 
-	mutex_unlock(&devices_lock);
-
 	init_waitqueue_head(&device->wait);
 	INIT_LIST_HEAD(&device->readers);
 	mutex_init(&device->readers_lock);
@@ -356,6 +354,7 @@ int roccat_connect(const struct class *klass, struct hid_device *hid, int report
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



