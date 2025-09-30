Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD7B20E334;
	Tue, 30 Sep 2025 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245876; cv=none; b=fHPiF79rhhCpGwWdC6Sp9TmJgUvImkzGEpr5jo6p5GuhUFd2LXKxpneLsP38TX9qS2w8g2Zxu1QiHH2Qmf40OTEOSvXgDFVDGU+FoM9G//sDdtvhFJ/4ntXP1DMxrByG1iBXBeDQ+wvsEiDqFNillEDWZxOccXwRFqA6pximWQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245876; c=relaxed/simple;
	bh=041/KGUWUvK9wqQk0jXmczkv7LHetDlAuKv5pPxAS8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lv9Wf5ur0qZLN3aYl4vpRQ2W4UoqikxFRV3oa+wCgNTKkyobvID5zzj7/4w4u4d9IKXUzA71fK9YdWAFawkmf9kj4qRwbJO8ERwzm904iEeZJRlf7bQdkslKFzeB5j/wemDFxpGQ5Q97ys64zqZFK2yRKSWgIBmq+KINnCaeFZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gXeLZNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gXeLZNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58503C4CEF0;
	Tue, 30 Sep 2025 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245876;
	bh=041/KGUWUvK9wqQk0jXmczkv7LHetDlAuKv5pPxAS8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gXeLZNR0zd0QDLbmihriwU8BTkqMjFOmiNVrT7a870f+FxPPN6suMPY32VSZAjp+
	 /jyVVYg4uGjYoQZIMdUAPfuL2Mua6CKMk9FhrmwDN1/9MczhI/fmmbkFAROkkPVIQI
	 FHNjTuHGMcA0Z4v+YPBwNalCeOTnOlge8r0Le/7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 76/91] gpiolib: Extend software-node support to support secondary software-nodes
Date: Tue, 30 Sep 2025 16:48:15 +0200
Message-ID: <20250930143824.337223287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit c6ccc4dde17676dfe617b9a37bd9ba19a8fc87ee ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4022,6 +4022,23 @@ static struct gpio_desc *gpiod_find_by_f
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
@@ -4034,7 +4051,7 @@ struct gpio_desc *gpiod_find_and_request
 	struct gpio_desc *desc;
 	int ret;
 
-	desc = gpiod_find_by_fwnode(fwnode, consumer, con_id, idx, &flags, &lookupflags);
+	desc = gpiod_fwnode_lookup(fwnode, consumer, con_id, idx, &flags, &lookupflags);
 	if (gpiod_not_found(desc) && platform_lookup_allowed) {
 		/*
 		 * Either we are not using DT or ACPI, or their lookup did not


