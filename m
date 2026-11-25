Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620131;
	b=B6G+D2sulH/p6ZnNPNhGZD8lc+v0VoyiZm3fOp+gLvIbRU1l1jPseO/vo49EMZmiZreL
	 GeRzO3d+BGzsmSyHGD+bLb627vN1BsmMnefEodPo8cdfr8IvSoBzNx27ayofzQ3FLBuno
	 yiFysOSXY08dkChayuoP8LlIxmsiFD4LqKCnfOJKAP36EXgO4IrKjwYvO7D7gvRiBidrZ
	 BLz3PuKxTBNdylJLOSIi3Z489Qxd+J0zHXAErKZrEGfe4Zshx6SbCCyxfHDQt8xotPE82
	 si4oyR3z081OAvw32qDM9BI8nq/5SCsOCu8RyeuJ6V1CwF9UTSHqn/lgWXFt0JSmm4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKdXz1UACDWP4ZRSDZh6UnjZYIgOAZcgHizCAg0Z6H8=;
	b=EX/Y65mbg6EAo6vi1HyvHJ/fnuQUTb0ehKyPJ+QR/Pxeh8Xfe5rQVBkcRb/BHXRFhjuC
	 8cJ6a9rr1FVMLrYvBquBoiaUX02DinNDBwicwrdpUWS9TYGosOqe2hhWQ39U134Kr1Qs4
	 in/Xrgnf/W84r/YOD+V+cZfoigknQTEI6GxVA7rJjoc7eZwJImiSJAwLJbVBXs7ouVu7j
	 jCVJhlfe5h08YBv3zQ4pwo8g6LEkSwmyPsfOoDisevD3zmILtdiVFYICNptb3jE58TLO4
	 pGN4rn9c+Fkhwi25sgve9kaZCuAOARqW33tRI2NkEH5VdNAkpY7TsMamAzJCRMktM5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibWpxCxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95CF606A321;
	Wed, 25 Nov 2026 15:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibWpxCxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F5A1F000C4;
	Wed, 25 Nov 2026 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620131;
	bh=jKdXz1UACDWP4ZRSDZh6UnjZYIgOAZcgHizCAg0Z6H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibWpxCxYPTon+crDkvzgSjPPAEvgSLGWolhMHTrxabALvLbXmoGfsqrQkLPa9mm4S
	 R9BGSibvVJ2KvzKI6erbcCzdv1tPIpykl5+cl/3t5qPeEZV2IlCLIUzOR6jAWpJfE/
	 cnfJKqYA9R8w6oQSDLeqBEYYvhXci5n91gt/Z9WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0818/1005] gpio: virtuser: fix interrupt leak and UAF
Date: Wed, 25 Nov 2026 15:35:56 +0100
Message-ID: <20261125143840.889274059@linuxfoundation.org>
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
@@ -55,9 +55,9 @@ struct gpio_virtuser_line_array_data {
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
 
@@ -607,7 +607,7 @@ static ssize_t gpio_virtuser_consumer_re
 
 	memset(buf, 0x0, sizeof(buf));
 
-	scoped_guard(mutex, &data->consumer_lock)
+	scoped_guard(mutex, &data->lock)
 		ret = snprintf(buf, sizeof(buf), "%s\n", data->consumer);
 
 	return simple_read_from_buffer(user_buf, size, ppos, buf, ret);
@@ -635,7 +635,7 @@ static ssize_t gpio_virtuser_consumer_wr
 	if (ret)
 		return ret;
 
-	scoped_guard(mutex, &data->consumer_lock)
+	scoped_guard(mutex, &data->lock)
 		strscpy(data->consumer, buf, sizeof(data->consumer));
 
 	return count;
@@ -675,7 +675,12 @@ static int gpio_virtuser_interrupts_set(
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
@@ -689,11 +694,13 @@ static int gpio_virtuser_interrupts_set(
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
@@ -793,6 +800,14 @@ static int gpio_virtuser_dbgfs_init_line
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
@@ -809,14 +824,18 @@ static int gpio_virtuser_dbgfs_init_line
 
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
 


