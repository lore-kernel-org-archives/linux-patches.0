Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043C0266B65;
	Tue, 30 Sep 2025 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244899; cv=none; b=fdXthUMJF0i2sG5QJUKtaSaGfEC21mEFFCIELwV+GpubY40JcwA/LasRYGZcxbYgd9zrymtI3YGwduWZfwXEIFKN9mdpntvZp4J3Nkyh4WTKp/T7YqQJwX6bnKjsEnh8n4/47T/2Sdlvg+f/SimV7IbnGWBC8VRJeqiOCIU7SpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244899; c=relaxed/simple;
	bh=V8Z2Z+8xO7St+6Fcce/kt2ZStGuFoNVK8WGEgKJNuII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eh5MfOSc+iaoHeWTb5ADYBF42OrI38WEINMyT9FJV5KHbzFsetlidRAMB45wVjq5Mk2CytagFmntpmfchDoMbw37VEaqsD1Bb4QjA7YWhSxb1MbOdosJD/KwmTji9AuWnpomA1RCqSQnTubk8qpxse+N/CDEWg/OYOjSGEA7vws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpJnqntn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpJnqntn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD4BC4CEF0;
	Tue, 30 Sep 2025 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244898;
	bh=V8Z2Z+8xO7St+6Fcce/kt2ZStGuFoNVK8WGEgKJNuII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpJnqntn1bi+WAqPRg9NI3zvcF+2cUQQm07ny3IoQGoBjw+o2QQgUCUtpsQaV13S4
	 LAr7DYxFPjLnktGdlUzzT/a+JD8d7w8XZ4vszcZ2jJl0EHN4i1ZlWzwqNwEpj6kYGe
	 j4261tn1NPY8h9NTGSEOlxxBj9PeRuHZPg5KLraY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.16 127/143] gpiolib: Extend software-node support to support secondary software-nodes
Date: Tue, 30 Sep 2025 16:47:31 +0200
Message-ID: <20250930143836.293795849@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

commit c6ccc4dde17676dfe617b9a37bd9ba19a8fc87ee upstream.

When a software-node gets added to a device which already has another
fwnode as primary node it will become the secondary fwnode for that
device.

Currently if a software-node with GPIO properties ends up as the secondary
fwnode then gpiod_find_by_fwnode() will fail to find the GPIOs.

Add a new gpiod_fwnode_lookup() helper which falls back to calling
gpiod_find_by_fwnode() with the secondary fwnode if the GPIO was not
found in the primary fwnode.

Fixes: e7f9ff5dc90c ("gpiolib: add support for software nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20250920200955.20403-1-hansg@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4605,6 +4605,23 @@ static struct gpio_desc *gpiod_find_by_f
 	return desc;
 }
 
+static struct gpio_desc *gpiod_fwnode_lookup(struct fwnode_handle *fwnode,
+					     struct device *consumer,
+					     const char *con_id,
+					     unsigned int idx,
+					     enum gpiod_flags *flags,
+					     unsigned long *lookupflags)
+{
+	struct gpio_desc *desc;
+
+	desc = gpiod_find_by_fwnode(fwnode, consumer, con_id, idx, flags, lookupflags);
+	if (gpiod_not_found(desc) && !IS_ERR_OR_NULL(fwnode))
+		desc = gpiod_find_by_fwnode(fwnode->secondary, consumer, con_id,
+					    idx, flags, lookupflags);
+
+	return desc;
+}
+
 struct gpio_desc *gpiod_find_and_request(struct device *consumer,
 					 struct fwnode_handle *fwnode,
 					 const char *con_id,
@@ -4623,8 +4640,8 @@ struct gpio_desc *gpiod_find_and_request
 	int ret = 0;
 
 	scoped_guard(srcu, &gpio_devices_srcu) {
-		desc = gpiod_find_by_fwnode(fwnode, consumer, con_id, idx,
-					    &flags, &lookupflags);
+		desc = gpiod_fwnode_lookup(fwnode, consumer, con_id, idx,
+					   &flags, &lookupflags);
 		if (gpiod_not_found(desc) && platform_lookup_allowed) {
 			/*
 			 * Either we are not using DT or ACPI, or their lookup


