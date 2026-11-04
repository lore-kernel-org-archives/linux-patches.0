Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831049;
	b=I8vnu9XdWKXKDiAtetv+OlBQ0et8a0b8/n2HD4czN7olGBgL0hohPOdTpKORsJNhHx//
	 bhM7+rSozCjLm3NM0zErrROfa8zWvipTKNXsN6P798ZEqlHuR9s4mKITNcs4Le9cNCMr6
	 Pga7FHKsUMs8+8/e+rfVtkzWulnEvsCimHfkNUaL68qgCKK4ZfiswTUXB3KE+az2rhjsV
	 8MFSZ5F6zxDTVhEQf4l64pbZ9UN6eED1j0eRqMAK9PLQiGNX2j1Rfnd3t0Mf2IgDcQ1oo
	 kcZUIh19wL1WkdqbeprGWjX492NSMu9eq+XsJfUk3wRKFZGTp3P+Y2BYBvLjjkqtuwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A4HThpdcyhTpQ5CyXyD9tgx9dAWqS1c3ogyoa2ZP2tU=;
	b=F1a/8E6WmKjuIc69pvHj8CzsXpNGl7w2zAoz7KcvwJ19JJoEAkkfQ/DS7iTldBARJp/Y
	 FRXCrbeoERiDvJnaFIUtcPvERX3VK7MRQ/WvzZUuQl3vcso65eJNK14AJx7IvN5SjLZBf
	 qoPnimzQ5xzPprBSL4YCj/REnOCFvaiKCfbR/lgN2sG0ys8o/qYPOgl6JogGUrQsxFQb3
	 1rui3yDlFpO+igURxTxxggcd89jg+Koh4JtGtK5HwCh/sZH0T4gyLV8WjFPUNK/HI6reT
	 VfWRzJs/GVg/I7KthwqTJ9gNyUglUlabFHWKuCoxFVzAEYF21+d/Cf5Mp60TtZiyy0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddyX+1PJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0675606A843;
	Wed,  4 Nov 2026 22:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddyX+1PJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5741F0093A;
	Wed,  4 Nov 2026 22:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831048;
	bh=A4HThpdcyhTpQ5CyXyD9tgx9dAWqS1c3ogyoa2ZP2tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddyX+1PJ9DpJDGLlOdXJbN0r/R/GuNOjM67WlhQ+LWfIN5Nv/zsveSRIZ1SbUSZFa
	 /r91526ooAkn4xhv7VS7YkZ2NreOTESwFfUihmxQWxxzF8cvGiXkNIWXaC6BiMZEfn
	 X61zILVlmYty0CtDnZl/Kbsfiwx5k33f21ZRcrME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0480/1005] HID: roccat: fix locking in roccat_connect() and roccat_disconnect()
Date: Wed,  4 Nov 2026 16:03:33 -0500
Message-ID: <20261104211057.436984674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



