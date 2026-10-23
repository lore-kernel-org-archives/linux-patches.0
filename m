Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774829;
	b=TpVVrAiaAAJMxwMBWorZmPA7Zu4yZMYUu+YlOmpNeyVyczggxuTaCQs8OzgKWeQ/+g+x
	 k9w9YdO4UzzUUFfCw54GG82XqZRuxHwEYSMCu3/cp224+YAoaBPbPG/gLptk/5/XI+m9J
	 SYlwNI78wPzaKYw0Mpoguu+e+pXfCGm/MkwFT2h+UKFh1iJBvJAdPzQvsaM9fgEPHmyy0
	 Sy6xZbkzo91DxyeDaqMAhOC3XGgF+8ZIAqo3bp0t3XUdddjEYnozm6vq5lMRX9c/Cl2U7
	 wyq7+6VQmRSHp9kzPInT0+zRvynMIYX9BsM4XXDvQZ9XzSoVaJU1fAoXchBC1EStBEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLVXI3hgkbFu8zL7OLLPaa1PQG74JNynQWs2lFl8KB0=;
	b=n+HJfR7edJiXpyt9TA0haMrKaq4oysWpqljonn6ATzaUbMQJhx5ii2uyMxjphxCFe545
	 W3qGnCuabqJSJHxOdDohrWhLNE9vyfurlmR805i8QHJGVl/Od2nDkmhZBPG8IZrjmZXXg
	 zK+7ZZxjsL2LE3KtqqNCGdpIM15uNmORxq4ARa6qLofEBN8ZWG+/RXkfLspihhblBYgYl
	 CaEK1sglUvv2Tkvr+PI63SE0D53uSgDYWrjLTt+C0jUB6JoNjqAze9WrleflhXzqtE6zX
	 9DLKAJvy8n9iH6y2L+S4Bpvd+YRiXjqrwyqPK7cMuejLHzAaQktv8vvd6N3wDdht0vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YucFQFuE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559E606A321;
	Fri, 23 Oct 2026 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YucFQFuE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231301F01828;
	Fri, 23 Oct 2026 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774828;
	bh=uLVXI3hgkbFu8zL7OLLPaa1PQG74JNynQWs2lFl8KB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YucFQFuEbphZu4zS4OKIP91dNbb5oCyyP2zccSyA92L/gY7vlSfI9CpSzYOU3dnSR
	 8LZK/4AzYiQkjyKYBPs7wFTYSbjbjzEP9BvBkcUhTo2iwV9fAkB6Z5xFJLveAQ5jRd
	 sYSVKTHpTfogXcA/xKiLk/LBxd2BJ52Ddo7GksFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 134/242] gpio: shared: fix use-after-free bug when adding shared proxies
Date: Fri, 23 Oct 2026 18:39:36 +0200
Message-ID: <20261023163716.947719304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit bd22f7e63509fa758cf500d9af3e88a3d3df96be upstream.

The GPIO lookup table can stay alive for longer than the kobject whose
name string's address we're assigning to lookup->dev_id. Fix a potential
UAF by duplicating the string.

Cc: stable@vger.kernel.org
Fixes: a060b8c511ab ("gpiolib: implement low-level, shared GPIO support")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261014-gpio-shared-fwnode-lookup-v4-1-2253ad645fd6@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-shared.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -450,7 +450,6 @@ int gpio_shared_add_proxy_lookup(struct
 				 const char *con_id, unsigned long lflags)
 {
 	const char *dev_id = dev_name(consumer);
-	struct gpiod_lookup_table *lookup;
 	struct gpio_shared_entry *entry;
 	struct gpio_shared_ref *ref;
 
@@ -480,18 +479,22 @@ int gpio_shared_add_proxy_lookup(struct
 			if (!key)
 				return -ENOMEM;
 
-			lookup = kzalloc_flex(*lookup, table, 2);
+			struct gpiod_lookup_table *lookup __free(kfree) =
+				kzalloc_flex(*lookup, table, 2);
 			if (!lookup)
 				return -ENOMEM;
 
 			pr_debug("Adding machine lookup entry for a shared GPIO for consumer %s, with key '%s' and con_id '%s'\n",
 				 dev_id, key, ref->con_id ?: "none");
 
-			lookup->dev_id = dev_id;
+			lookup->dev_id = kstrdup(dev_id, GFP_KERNEL);
+			if (!lookup->dev_id)
+				return -ENOMEM;
+
 			lookup->table[0] = GPIO_LOOKUP(no_free_ptr(key), 0,
 						       ref->con_id, lflags);
 
-			ref->lookup = lookup;
+			ref->lookup = no_free_ptr(lookup);
 			gpiod_add_lookup_table(ref->lookup);
 
 			return 0;
@@ -611,6 +614,7 @@ void gpio_device_teardown_shared(struct
 			if (ref->lookup) {
 				gpiod_remove_lookup_table(ref->lookup);
 				kfree(ref->lookup->table[0].key);
+				kfree(ref->lookup->dev_id);
 				kfree(ref->lookup);
 				ref->lookup = NULL;
 			}


