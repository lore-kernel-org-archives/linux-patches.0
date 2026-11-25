Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620122;
	b=EbgmM0rq6lEhdaI4Gbk4ZowGx+lpSf4x5v5HUckbidw+21og0qlImFNbdt/p9TF1nGaJ
	 Io0iE67M2IalhL3xn2ZRSAbaJlC+VRufeZALtPzLdqiMoTmiRm/O23GldieFfNcekIVfB
	 sdw8L+5ZDRHqH+m6lBSyv5x6XJa2OTLhVRtYnbn0M4Hy5kPWtg7Y1mR/4iRYDdoTqlpZa
	 mh7YOcmh0lbviQ+F5cmHa3suNJONE0bpcARtwn1zZPzd3uI6gM9XjJe4bHoAmqSDra/V7
	 aJm3qbHidbHzwk0LTkAZ3yypQTO9ZIwmXFJ1Hu6fq8TJpmZ4hSL/NeGgWujFTjlyDnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b+FfTsS0GclwNbEe+j7a9XnO9U+OvqPNYnc8oPPExg0=;
	b=dXYYwGIwrGInWA+ctt3cLzPHB2vIq/OgykIQFip4owkeHb2PWaPbBIjX/vCn44iOVMv3
	 OBT22wJuKofnJxfAEY9Tlquetqs9pUI7ORCMTI7O0thFIwyTs8RFolU8N/jTlay4YZfLF
	 JYJhbgVGUW9WAz+09sG0Smp9FnR+OkaXWymJaawgexSXGyDyrqR1kuB6vOnrwLNeMFOmD
	 qr5sfIwg68ZWfy90QnMbuWn+wCSszzCF6A7O+i95SLYpNw3Y2nvLO84M6AMKf+1WPILZJ
	 1LajCndA51h4PZG+MI90LRbuysq375roypxqsIAdbedVMcQcLmcdsNgHPioRmwICpxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fTtLHU7A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EC5606A326;
	Wed, 25 Nov 2026 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fTtLHU7A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149D91F000C6;
	Wed, 25 Nov 2026 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620122;
	bh=b+FfTsS0GclwNbEe+j7a9XnO9U+OvqPNYnc8oPPExg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTtLHU7AMYIJS2f3XBOSy22HZT30zxzkVHLJH2tqfBqgoF/2gcYDj/pa2mLKjupic
	 kN9edW8GReuuNpssjE773bizkhQy9mtt2R2gQQjyAKjzPBPoz1D6H6Eszt2VyTCH2b
	 pq51kwJTw3hjjNFGg5NH7tTZLD6l1R9xAHUVjfP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0816/1005] gpio: shared: fix a race in shared desc release path
Date: Wed, 25 Nov 2026 15:35:54 +0100
Message-ID: <20261125143840.842991477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 53043b9e83cc7f4e30e70161b67ae93c4c9fdb87 upstream.

gpiod_shared_put() races with concurrent calls to
devm_gpiod_shared_get() like so:

CPU 0 (unbind / probe failure)      CPU 1 (concurrent proxy probe)
==============================      ==============================
gpiod_shared_put()
  kref_put(&entry->ref, ...)
    refcount_dec_and_test() // -> 0
                                    devm_gpiod_shared_get()
                                      mutex_lock(&entry->lock);
                                      if (entry->shared_desc) {
                                        kref_get(&entry->ref); // on 0!
                                        shared_desc = entry->shared_desc;
                                      }
                                      mutex_unlock(&entry->lock);
    gpio_shared_release()
      mutex_lock(&entry->lock);
      kfree(shared_desc);
      entry->shared_desc = NULL;
      mutex_unlock(&entry->lock);
                                      // uses freed shared_desc

Because gpiod_shared_put() decrements entry->ref without holding
entry->lock and gpio_shared_release() only acquires entry->lock after the
reference count has already reached zero, a concurrent call to
devm_gpiod_shared_get() can acquire entry->lock in the intermediate window
and observe a non-NULL entry->shared_desc. This can result in a
use-after-free and a double-free when the second consumer releases its
reference.

Use kref_put_mutex() to ensure the entry lock is taken without a window
in which a concurrent user can see a non-NULL entry->shared_desc while
it's being released.

Cc: stable@vger.kernel.org
Closes: https://sashiko.dev/#/bug/linux-30e071e4-4e4a-4b63-bd83-df1147055d35
Fixes: a060b8c511ab ("gpiolib: implement low-level, shared GPIO support")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261110-gpio-shared-refcnt-race-v2-1-8a0b76e01714@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-shared.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib-shared.c b/drivers/gpio/gpiolib-shared.c
index 8c9ac9d93304..edb04a5bb987 100644
--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -635,20 +635,20 @@ static void gpio_shared_release(struct kref *kref)
 		container_of(kref, struct gpio_shared_entry, ref);
 	struct gpio_shared_desc *shared_desc;
 
-	guard(mutex)(&entry->lock);
-
 	shared_desc = entry->shared_desc;
 	gpio_device_put(shared_desc->desc->gdev);
 	mutex_destroy(&shared_desc->mutex);
 	kfree(shared_desc);
 	entry->shared_desc = NULL;
+
+	mutex_unlock(&entry->lock);
 }
 
 static void gpiod_shared_put(void *data)
 {
 	struct gpio_shared_entry *entry = data;
 
-	kref_put(&entry->ref, gpio_shared_release);
+	kref_put_mutex(&entry->ref, gpio_shared_release, &entry->lock);
 }
 
 static struct gpio_shared_desc *
-- 
2.56.1



