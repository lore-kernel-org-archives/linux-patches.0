Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051533;
	b=ylga28nXZqgQKnH9/z5IF7MFQfV93QCxTM4r0J70cb5tzrkA9tbr/9QehJJd8vNZ6mgf
	 BBQ7IC9sV5nLvDxthqUPS6zdsH/XbDC6hNkC8Hztp2ZqZcSXEeo7Evf0q9a79VsN+44gc
	 +/Hi6RMoMrvZUC8YB0pGiPyQ4uwg+JWMb/iNKxul1OpJnaxwn3r6E51cRjQe4uNa291QR
	 brS5C7zhSmWFAQJbGACVCdAnEgATkvfAshOkgAEveGM8Gv9nULQRCWXjRBli/O8RFnPSZ
	 YT9FEx0am4l6Q+jOzZuzqVWlJ9Aq1E4uA0fYfxZpSBOVbu7oo5PaR/9xvZitTO1MPcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kOGjGL5DEwLhFeMQ5Joyl3it6o6ypicB0mJlQVmwD9A=;
	b=qbEmR8drxUqQCnu1h8yTIoGcP7yDaPrhEq6rNBe5076jnuYfW79XjTDRw5drXCqUbPFm
	 WwRhnhaqoA6b/zsuQqZe/g/78YMnO0Jw+sdRZao/vQvwgJ7aldXtj3jc8qtbxYPCxHyzW
	 exBRAebSwJe81iIQ1di64sX5iYGvjSA8sjxX41v9DIGTPQXzTqzleC3F4epxaY1cbnOUv
	 pcxCigOvpNV+cuUXfT816DnDkum1Dgn6YNGwoXCPMs6deydV5SgzL0K3kLprtswTYQfsV
	 2sHP4zpHuc9NHBWDY9R7JtqPh5NyFQUAPd0/woqglWltl57ii+29zLticbnbla7/kDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z69pkNLj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E170606A31C;
	Thu, 19 Nov 2026 01:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z69pkNLj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D880C1F000C4;
	Thu, 19 Nov 2026 01:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051533;
	bh=kOGjGL5DEwLhFeMQ5Joyl3it6o6ypicB0mJlQVmwD9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z69pkNLjW7Xq5hPKLbTnX+DIdR0KKdCZP7Xuh7QTFg/VAhTCGAtTyK3Du1I4INfqt
	 g046yJa+bnn5vw9OKTOJWivOji0EF8EMhN/AZ5w+Hs8OCzLtlPlS7U7nqJRNm5rg26
	 NGO8WhuKdbZjzf0ZUidc7/CvEoMdQJBRhsdXMTL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0241/2214] HID: roccat: fix locking in roccat_connect() and roccat_disconnect()
Date: Wed, 18 Nov 2026 15:31:57 +0100
Message-ID: <20261118150019.820837194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



