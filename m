Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE312D3A69;
	Sun,  7 Jun 2026 10:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828308; cv=none; b=ggkeIwPMsxMbok5jc3JAWunz7LR0C5nBcOeWBUSBJpTEubtclbYReeKpqmPBa6evxTuCdpbjRpZ/Xai6kbPhIoHXyYNHfZ5z8xoc9fniBg0zJxk431PmaFUCCUfL0I8jHLegLoprvQRCu0KwkPZ+zGcaHwgYZgoJUIQZly2hmgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828308; c=relaxed/simple;
	bh=YzwnZZwrN7XqSRVqo2UkytGC76NZSw6zfjY3NtTaMf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dK6SnlZb7Xk6cNPTUauWL7xst+Wvn7kUxNTPNjXgVjK7314RPHCXB48yfATicZcXdFuFQdQaoBd0T4c7ybuP6al19BthD0wpjuRcTT0Tvj3WSH6Y/xUzVg3gLoCJOjC3LyGPbce2AbZYoL3qvVE2bXebnk+R1Q+me396EEh1Jqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQMXk8c/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQMXk8c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98F31F00893;
	Sun,  7 Jun 2026 10:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828307;
	bh=92CVT4akYco+6UUajsKPPs83gHj6CvCdcoOZW45amqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQMXk8c/Rrhy/UyAQtikCiUX4Xn16K0ghw0K6nkqTExdDcjkvyHAbgNlmOmubDFdl
	 S6eWlp4PnWnWkhoVKroa5vPThV4M4KLUhSP8QhW1ixYpyixE//YMpX9x5Ks2CRi8JZ
	 cSnpBhsZ9OgqOc7yMGe0TqPT7vLb/5rbHmR8lyfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.0 171/332] gpio: shared: fix deadlock on shared proxys parent removal
Date: Sun,  7 Jun 2026 11:59:00 +0200
Message-ID: <20260607095734.340516710@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit a1b836607304f71051f9f9dcccf8b5097b86a1fb upstream.

Commit 710abda58055 ("gpio: shared: call gpio_chip::of_xlate() if set")
used the mutex embedded in struct gpio_shared_entry to protect the
offset field which now can be modified after assignment. The critical
section however is too wide and introduced a potential deadlock on the
removal of the shared GPIO proxy's parent.

Make the critical section shorter - only protect the offset when it's
being read.

While at it: mention the fact that the entry lock is now also used to
protect against concurrent access to the offset field in the structure's
documentation.

Cc: stable@vger.kernel.org
Fixes: 710abda58055 ("gpio: shared: call gpio_chip::of_xlate() if set")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260522-gpio-shared-deadlock-v1-1-76bca088f8c0@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-shared.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-shared.c b/drivers/gpio/gpiolib-shared.c
index e02d6b93a4ab..087b64c06c9f 100644
--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -53,7 +53,7 @@ struct gpio_shared_entry {
 	unsigned int offset;
 	/* Index in the property value array. */
 	size_t index;
-	/* Synchronizes the modification of shared_desc. */
+	/* Synchronizes the modification of shared_desc and offset. */
 	struct mutex lock;
 	struct gpio_shared_desc *shared_desc;
 	struct kref ref;
@@ -598,12 +598,11 @@ void gpio_device_teardown_shared(struct gpio_device *gdev)
 	struct gpio_shared_ref *ref;
 
 	list_for_each_entry(entry, &gpio_shared_list, list) {
-		guard(mutex)(&entry->lock);
-
 		if (!device_match_fwnode(&gdev->dev, entry->fwnode))
 			continue;
 
-		gpiod_free_commit(&gdev->descs[entry->offset]);
+		scoped_guard(mutex, &entry->lock)
+			gpiod_free_commit(&gdev->descs[entry->offset]);
 
 		list_for_each_entry(ref, &entry->refs, list) {
 			guard(mutex)(&ref->lock);
-- 
2.54.0



