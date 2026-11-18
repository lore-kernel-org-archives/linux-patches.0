Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034479;
	b=KDZWCXRUz+y8yzcQNKoSVmJD6Ls6szKKpWpyhz+iIg0IQJ9i2tsCqavSlW6ChVipnr+H
	 uLgadMCnvgPIXHzlUA6lvxauK4oQtQDIb3J407CYBy+J18xEa6dbm0g7NvLH0+P6O/Bgw
	 9B3p8DPmtYSYKQfHmUKNd3IRlXMYRmY28GfHZopjl+ZI5oT7JZe5mxMszmb4pPnJky73X
	 gfxi08ODA4A5ZeErzoVxK79yS6+AvAgMp9KlrUSfI4scrlO97+5M/sUq3bF7ewz5kNpcy
	 5BP0oaE2sx5nH8C7UOHf96ai8kuBHuDOPY05y3Z05JucrhflGeqlZFjpn/C7k+F+4hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dbte7P/4DF1MZUxI/TpAx5YcterUfycd6WCnvYLxA7M=;
	b=FB4woxcm8qGXZcEPXzVLOi7oqAl6Apa5l5UFGeE2UklbtP6OCpMrW1KNZV01YXG/69PG
	 2q1GlUgGIbQY44bKUhoQaZToPukobPiY3qblebcNYBNmUUpS2gjV7W2pExRPC/DfLq7d7
	 Y6KranLOVRunNaiBz/mZjxDY+xM6R04drYBmMksz0McCsYSGYxU2PlQmUM6rJpeQQ9lPl
	 J5TzVOnDFil0aaNYj1/bBDWnaUZtxfNMh2ePDWDnNCimU5T5VS/qUh0U4KZfh8vSPApY8
	 DmYowT7IFmvmxm1RYfdog6G18QSTWp67ahHsjsZ2EoSx7z88v1SWltLEKuHaIW8o6OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMXPmyNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0C4606A31C;
	Wed, 18 Nov 2026 20:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMXPmyNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C210B1F000C4;
	Wed, 18 Nov 2026 20:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034479;
	bh=dbte7P/4DF1MZUxI/TpAx5YcterUfycd6WCnvYLxA7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMXPmyNJrGS9R4LjcUrkIdHE7mYBHRF+otxaKVI5B8hFYqXGGZJsRpqiVWSUKbk+L
	 Oc8Hs+Paet+TndfWOfjcdGgAyyasmTqCFqrDztrwOaujrRTto5RX6+hJ4FejcS0uy2
	 umErrHd5chcRj93jLfh257vJj6gw6M/CQWGNhvfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0337/3318] HID: roccat: fix locking in roccat_connect() and roccat_disconnect()
Date: Wed, 18 Nov 2026 15:15:59 +0100
Message-ID: <20261118150326.075031108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



