Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625927;
	b=YM9aROlQ/VZ/rK6n2aV6zf7tSHiWWnAd7TlRMZIupcLUlhHX/bAkD6hS6VXiCZIaAllA
	 15OHGv2+EaQ22j2CWahyYXfM10B/nbF/3YB+cx1RdRPpSIwlvU1ox1i8jLFQSIPL+NPr+
	 378W09CDxF3B6juZoXYDTb9cCh4k0qmXJzgOgvRkmb4FilIW4cx4RoY4DlCBiePftosIb
	 xCBoeSQKTgxdoH6L/4Zq1sGAZLNw2XMUDnqqA1XAOd5N/Id2CXHgU/ya3I6aX5g4Mc3ba
	 wyBR3zFo6eytOOyMg8fCxZE9nDvRKvbH/i31ecMCBQvvEOsiYUZiXGJFop03Wtp8Dkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/H+S5jAIdVg/mO/7Srru35uY6cixX/rb8/rY0mtcFvU=;
	b=J+mJCc1dRNd5OgoTGRAegAbuA6P6v0ELiJcr62OyuGm5TN6G52bZQqxiPPrcpWmKV636
	 8/2mjX9tWBcxlnQcD48oYLLI1GH6t3aMBFofbBHZWPi4+hh/Ve4LUFNGzB2/U1rWAM+Ka
	 NwtHwLVJ0SinZOO30CQA6++ZlUAokUBVixW7deMJu17+qH3joSP1oiPLRBhrBPQG9BBDK
	 xWrOySfpOEK7oX96KpXwWwYEY2f4nhsZZ8DevQ0QPHsJmr9lEpGr1GXBWPSICgO99USRV
	 ytThRxLLSMv2hBGojH7RQe03mDk61b99sCw0ggqENs2lCm9d/zC7vsDk++ryPl2+Whw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPbJbNvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934A1606A31E;
	Wed, 25 Nov 2026 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPbJbNvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FF31F000C4;
	Wed, 25 Nov 2026 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625926;
	bh=/H+S5jAIdVg/mO/7Srru35uY6cixX/rb8/rY0mtcFvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPbJbNvqHqOVCfKxbL42/s+0RHKVPu2fVEh9AGiz5q6zLq7h90D9bRufU2+pmBq7S
	 oYf751HabDOeYKTsihPCr010TPg+qxjm9Nu3Ao21NewFQnLgt/mWvKtHpFbhkkZodZ
	 xs6hRXEhSamXbBXqnmGTWMRoMCSnTGJN0xMva1fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 675/816] gpio: virtuser: fix interrupt leak and UAF
Date: Wed, 25 Nov 2026 15:37:03 +0100
Message-ID: <20261125143904.803973909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -57,9 +57,9 @@ struct gpio_virtuser_line_array_data {
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
 
@@ -613,7 +613,7 @@ static ssize_t gpio_virtuser_consumer_re
 
 	memset(buf, 0x0, sizeof(buf));
 
-	scoped_guard(mutex, &data->consumer_lock)
+	scoped_guard(mutex, &data->lock)
 		ret = snprintf(buf, sizeof(buf), "%s\n", data->consumer);
 
 	return simple_read_from_buffer(user_buf, size, ppos, buf, ret);
@@ -641,7 +641,7 @@ static ssize_t gpio_virtuser_consumer_wr
 	if (ret)
 		return ret;
 
-	scoped_guard(mutex, &data->consumer_lock)
+	scoped_guard(mutex, &data->lock)
 		strscpy(data->consumer, buf, sizeof(data->consumer));
 
 	return count;
@@ -681,7 +681,12 @@ static int gpio_virtuser_interrupts_set(
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
@@ -695,11 +700,13 @@ static int gpio_virtuser_interrupts_set(
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
@@ -799,6 +806,14 @@ static int gpio_virtuser_dbgfs_init_line
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
@@ -815,14 +830,18 @@ static int gpio_virtuser_dbgfs_init_line
 
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
 


