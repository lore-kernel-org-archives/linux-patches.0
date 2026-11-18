Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057624;
	b=dHgyFxBLum2b6citGGpK8e62Qy8JqRNdkGmxIk3r+H7Uf7mtKJwJdml6SAGlgiMk8uP2
	 L0wd6gSceAR95P5P2+53u6EMkb+mg1T4mh0Z4x/Zih8fG5XBI6XPKs0L9VbhFz4z4XsU9
	 7CQ9SKkSgIkaM06r3iLoJ5b63Cdm7YMfppMIAT3bvO/HJrING++yrL56PCcdP+xvdJjSo
	 6n4/M/w954Is7kn3FsRv3Q22BcIAliXI8SINmgm+SzkuOhcJ3BXLcOltIPsGG/ufMhW+i
	 bMrY+/0hjbr/GO/0im17YJtZ/LyrShJwmGeqy63hYXLtLyVxXHWyIr9w/9r217fNpaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qR87HtB4U262dPUo2W0srRefcyrP25ebWeNfiic7Ob4=;
	b=Y0QU5DmAVg3imXyGOPySGvRR2EgQApOaNZDz8NbGU5WNLLfsKrs4G+3uxTl/nX6cDn6V
	 RwcvUjJR/iRaUW78CYPyni8+Fctn7FkcJhgCkfqE25zvsK65N3MO34DyUOlE3I84lSbAa
	 Fe/MVyQZg+MRrMGLUmha2sPbRaKN1Lqz7/LeE22Q1+/+fl87vtdU1ZhunVcAvJ7JX6NBU
	 YdG9XVhyLqBTdNe/jjaTMCn2cSQC4Mey1whw/gTNQyCl/iQtT/MCXwR4iAqYFCwx5UcRo
	 UniUJdDCJXReQwT+Uwqa0YIWJEbXyE0gWsfJsbs51Z0mFF2w7qGQvmJFcQsAoZKrvBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UppGKWm9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E4460A2601;
	Thu, 19 Nov 2026 03:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UppGKWm9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E161F000C4;
	Thu, 19 Nov 2026 03:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057624;
	bh=qR87HtB4U262dPUo2W0srRefcyrP25ebWeNfiic7Ob4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UppGKWm9wiMMpOlgeNkfbbiH6kQFjx4cTbUZIILvrag2YyHZjJn1ye7KqzTNZfZbh
	 WpjJMtzz2gCZuMUdGxpmt1tOnzun5Nwdk2JNg31KV+znygqw8SfU95HzpPnylG0Yg1
	 EmPaCAlZLII0erX/m1GkvgeAK40XxVRccuQ2wJwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0196/1848] HID: roccat: fix locking in roccat_connect() and roccat_disconnect()
Date: Wed, 18 Nov 2026 15:37:14 +0100
Message-ID: <20261118145919.988749293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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



