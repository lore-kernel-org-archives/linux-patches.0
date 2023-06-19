Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D685BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3A9C433C8;
	Mon, 19 Jun 2023 10:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172100;
	bh=PwwsNaULNkh6X2ZrNOC4GconFN3+nu1WjyxpO2ZtWow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrJVIJbA0OYLtOQy8U88WB+Bmk/4EzRAGnyA9FyDOXzuHk4N2iH0Z/wmog0QQNgnv
	 QNUYONXvXTzXrIHpo4AV8KDQ6loZqz3Qa5nsolNlmpKLm5lTcj/yQlB3Yrvbx/eqhf
	 bct7ZnIoqw3ZyGWxXgcGMqnOD3A256BL1QyN9Dc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/89] lib: cleanup kstrto*() usage
Date: Mon, 19 Jun 2023 12:29:49 +0200
Message-ID: <20230619102138.345102019@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 506dfc9906e5cbf453bbcd5eb627689435583558 ]

Use proper conversion functions.  kstrto*() variants exist for all
standard types.

Link: https://lkml.kernel.org/r/20201122123410.GB92364@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4acfe3dfde68 ("test_firmware: prevent race conditions by a correct implementation of locking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_firmware.c |  9 +++------
 lib/test_kmod.c     | 26 ++++++++++----------------
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 581ee3fcdd5c2..3edbc17d92db5 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -371,18 +371,15 @@ static ssize_t test_dev_config_show_int(char *buf, int val)
 
 static int test_dev_config_update_u8(const char *buf, size_t size, u8 *cfg)
 {
+	u8 val;
 	int ret;
-	long new;
 
-	ret = kstrtol(buf, 10, &new);
+	ret = kstrtou8(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new > U8_MAX)
-		return -EINVAL;
-
 	mutex_lock(&test_fw_mutex);
-	*(u8 *)cfg = new;
+	*(u8 *)cfg = val;
 	mutex_unlock(&test_fw_mutex);
 
 	/* Always return full write size even if we didn't consume all */
diff --git a/lib/test_kmod.c b/lib/test_kmod.c
index c637f6b5053a9..c282728de3af0 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -877,20 +877,17 @@ static int test_dev_config_update_uint_sync(struct kmod_test_device *test_dev,
 					    int (*test_sync)(struct kmod_test_device *test_dev))
 {
 	int ret;
-	unsigned long new;
+	unsigned int val;
 	unsigned int old_val;
 
-	ret = kstrtoul(buf, 10, &new);
+	ret = kstrtouint(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new > UINT_MAX)
-		return -EINVAL;
-
 	mutex_lock(&test_dev->config_mutex);
 
 	old_val = *config;
-	*(unsigned int *)config = new;
+	*(unsigned int *)config = val;
 
 	ret = test_sync(test_dev);
 	if (ret) {
@@ -914,18 +911,18 @@ static int test_dev_config_update_uint_range(struct kmod_test_device *test_dev,
 					     unsigned int min,
 					     unsigned int max)
 {
+	unsigned int val;
 	int ret;
-	unsigned long new;
 
-	ret = kstrtoul(buf, 10, &new);
+	ret = kstrtouint(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new < min || new > max)
+	if (val < min || val > max)
 		return -EINVAL;
 
 	mutex_lock(&test_dev->config_mutex);
-	*config = new;
+	*config = val;
 	mutex_unlock(&test_dev->config_mutex);
 
 	/* Always return full write size even if we didn't consume all */
@@ -936,18 +933,15 @@ static int test_dev_config_update_int(struct kmod_test_device *test_dev,
 				      const char *buf, size_t size,
 				      int *config)
 {
+	int val;
 	int ret;
-	long new;
 
-	ret = kstrtol(buf, 10, &new);
+	ret = kstrtoint(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new < INT_MIN || new > INT_MAX)
-		return -EINVAL;
-
 	mutex_lock(&test_dev->config_mutex);
-	*config = new;
+	*config = val;
 	mutex_unlock(&test_dev->config_mutex);
 	/* Always return full write size even if we didn't consume all */
 	return size;
-- 
2.39.2



