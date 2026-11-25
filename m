Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623353;
	b=SZmoiyFdCPv/lzFbVsMKkulHMX41NAfJqnqgpGbUJrBUp1QKb72sqNny3eOKqyN4xlY8
	 RSizjmrWVk1SFkUBuWiOIMbzpwOIupLZZPdmWfRhzlaFUg2NqkNmABlqi3kFcs1yvNJCx
	 tN1qP8YgYWw0Wsw5sPJmBBmVDQc4ACFopX5nBk0uhUJ4jejulvf8zrRMQEjTq6Je5Hw1g
	 DZ2I9PHd5Wt517HzrITlNqZn6mqzkq77LIA/fNfjQSgAQnyy4XjuMzz4evtdc+zGv4Su+
	 vam7qYCYBfmQ+KE0Sv3rRpAEDOHragjm/AUEW96Tdxg1s4skrHEiaNV0jLsiNmi4GvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NTOFYQ9MH5mRfZQVkY4OpcX66apWLVE9FT6R9TYL0fU=;
	b=XrTxUJuFYqmFoV6m4Q8U975qmUj4IJx92Mnx2h+1IGfsjWfep0yHMB9Zea3nubdN8Ycc
	 04yjaudefB9SmX3vnn+it/IvQ0zUKM67wCk9lm6daEuoDqrt3BAxZg3kPQPOj0nyxZ96O
	 yXcOEDSGD7q3k5ySLehtg2BdDdLA4fKOwwdXt4mVzD9Ul4umVMuGJNW9qfivm9L3n5/Zs
	 dtiI8fwlHc22xyER7yAWuBtxPo8b1o3dbmzwNhkazvrMYoAPQujHWAO6dr4esxvj4HelJ
	 BZX7AvFun4/ztnzFJnPFTWvhHcN72x7vVhKmAxEYBcyHcN20EFBWgZhRkDsCoXRfX6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/LxBt1Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB8B606A326;
	Wed, 25 Nov 2026 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/LxBt1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF60E1F000C0;
	Wed, 25 Nov 2026 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623353;
	bh=NTOFYQ9MH5mRfZQVkY4OpcX66apWLVE9FT6R9TYL0fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/LxBt1QN4UyhaS/4x82jJMIP8C+OUpZSqIyZztBzSo+27KezLxYbDQ52pf/zirJL
	 ZIiP4xsCbk8xXVvym05GTAB9yd4qItlTToPHA/pXyVeWDZl3SHNztyoiev2tnNtMss
	 Sd2yoj5De9yJ4oVpnWsoHn+yP5DUMnbDf8wCN8p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 829/990] gpio: virtuser: fix interrupt leak and UAF
Date: Wed, 25 Nov 2026 15:36:36 +0100
Message-ID: <20261125143841.453368517@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 24cafd9580627f9f066296f4a6ce1b282a3f425d upstream.

When configuring interrupt handlers for GPIOs requested by virtual
users, we never verify if an interrupt has been previously requested and
just leak it if it was.

We also never free the interrupts at device unbind. This is both a leak
and a potential UAF bug.

We use atomic_t for the irq field for now reason, it can't be modifying
or read from atomic context. Let's repurpose the existing consumer_lock
mutex and serialize access to the irq field. Let's add sanitization of
input and schedule a tear-down action.

Cc: stable@vger.kernel.org
Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Closes: https://sashiko.dev/#/bug/linux-d8935133-0e80-487a-9e00-e748056f595e
Link: https://patch.msgid.link/20261106-gpio-virtuser-irq-uaf-leak-v1-1-ce9772d8ad0d@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-virtuser.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -58,9 +58,9 @@ struct gpio_virtuser_line_array_data {
 struct gpio_virtuser_line_data {
 	struct gpio_virtuser_attr_data ad;
 	char consumer[GPIO_VIRTUSER_NAME_BUF_LEN];
-	struct mutex consumer_lock;
+	struct mutex lock;
 	unsigned int debounce;
-	atomic_t irq;
+	int irq;
 	atomic_t irq_count;
 };
 
@@ -612,7 +612,7 @@ static ssize_t gpio_virtuser_consumer_re
 
 	memset(buf, 0x0, sizeof(buf));
 
-	scoped_guard(mutex, &data->consumer_lock)
+	scoped_guard(mutex, &data->lock)
 		ret = snprintf(buf, sizeof(buf), "%s\n", data->consumer);
 
 	return simple_read_from_buffer(user_buf, size, ppos, buf, ret);
@@ -640,7 +640,7 @@ static ssize_t gpio_virtuser_consumer_wr
 	if (ret)
 		return ret;
 
-	scoped_guard(mutex, &data->consumer_lock)
+	scoped_guard(mutex, &data->lock)
 		strscpy(data->consumer, buf, sizeof(data->consumer));
 
 	return count;
@@ -680,7 +680,12 @@ static int gpio_virtuser_interrupts_set(
 	if (val > 1)
 		return -EINVAL;
 
+	guard(mutex)(&ld->lock);
+
 	if (val) {
+		if (ld->irq >= 0)
+			return -EBUSY;
+
 		irq = gpiod_to_irq(ld->ad.desc);
 		if (irq < 0)
 			return irq;
@@ -694,11 +699,13 @@ static int gpio_virtuser_interrupts_set(
 		if (ret)
 			return ret;
 
-		atomic_set(&ld->irq, irq);
+		ld->irq = irq;
 	} else {
-		irq = atomic_xchg(&ld->irq, 0);
-		if (irq)
-			free_irq(irq, ld);
+		if (ld->irq < 0)
+			return -EBUSY;
+
+		free_irq(ld->irq, ld);
+		ld->irq = -1;
 	}
 
 	return 0;
@@ -798,6 +805,14 @@ static int gpio_virtuser_dbgfs_init_line
 			data->ad.dbgfs_dir, data);
 }
 
+static void gpio_virtuser_free_irq(void *data)
+{
+	struct gpio_virtuser_line_data *ld = data;
+
+	if (ld->irq >= 0)
+		free_irq(ld->irq, ld);
+}
+
 static int gpio_virtuser_dbgfs_init_line_attrs(struct device *dev,
 					       struct gpio_desc *desc,
 					       const char *id,
@@ -814,14 +829,18 @@ static int gpio_virtuser_dbgfs_init_line
 
 	data->ad.desc = desc;
 	strscpy(data->consumer, id);
-	atomic_set(&data->irq, 0);
+	data->irq = -1;
 	atomic_set(&data->irq_count, 0);
 
+	ret = devm_add_action_or_reset(dev, gpio_virtuser_free_irq, data);
+	if (ret)
+		return ret;
+
 	name = devm_kasprintf(dev, GFP_KERNEL, "gpiod:%s:%u", id, index);
 	if (!name)
 		return -ENOMEM;
 
-	ret = devm_mutex_init(dev, &data->consumer_lock);
+	ret = devm_mutex_init(dev, &data->lock);
 	if (ret)
 		return ret;
 


