Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4848C32AABE;
	Sat, 28 Feb 2026 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301271; cv=none; b=Jvo6D0LHpIIzmeKPkYTpNpF9mmSQSFQjzVdJgUQG285tIl+WroKpw2K5ezmarW2a8BQGPdKnhR5wqwymAKTsVqdG9K70ZnjEx7LVNS43EC09imN5rKXVDolrK+xcyiqKjJc21EIRXE9kqRha5z6QlBpz7zQ7kYZ7MdbCuNR2R5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301271; c=relaxed/simple;
	bh=g/ldiWZ7ZtRtUsTGWptXHCGhnyIJmR/pakE7Kon9wQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcsCr4/hQRxHauuPLhESewZHtou9FMyJiQF8yITsdQph+2NNOJ7zFRikw5KN70Gouy6T+RbUSj8SrX3Qyr3ZIGYGsp4Km4ksFieGJKeXzD12eyfkrYeMbJMRxTj01XgsAXrHmghFuA9yDS8/kb3+zFHwhyolhLw8/fKKaPieMRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAn1VxT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAn1VxT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9398EC19423;
	Sat, 28 Feb 2026 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301271;
	bh=g/ldiWZ7ZtRtUsTGWptXHCGhnyIJmR/pakE7Kon9wQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAn1VxT+aZgwVal3kVvDUVjVePlmU0eh8hoO8jb+MWxTu4yWdxDQSZPC/GcMn5ZXR
	 W+1HKJUZ07GQwOJV/5iJXGunfLlnrGlcpeOwi0/2J31qJkzMXa8XqOCGCK16RAp+QF
	 Y//W8wD9tfLlTrrGXL370Zfqbu3Pk/gRIaaj0mSfLQRm6st75tNuNvZboQ6NpA4Be+
	 Li2NFi3DzV97J9Z3+HHacEJKKw3p4bkT5Mo0pAQkKtss9thKXf2NnJLp+C1qL29WAF
	 0M5dEeKGFf/k7GMNAjjXyM2nJVmoV2+awnJMxk94n3mPij9mZdk8u4dF2Ncp/cF0u0
	 TFxgINLeiXW4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gui-Dong Han <hanguidong02@gmail.com>,
	stable@vger.kernel.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 455/752] rpmsg: core: fix race in driver_override_show() and use core helper
Date: Sat, 28 Feb 2026 12:42:46 -0500
Message-ID: <20260228174750.1542406-455-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 42023d4b6d2661a40ee2dcf7e1a3528a35c638ca ]

The driver_override_show function reads the driver_override string
without holding the device_lock. However, the store function modifies
and frees the string while holding the device_lock. This creates a race
condition where the string can be freed by the store function while
being read by the show function, leading to a use-after-free.

To fix this, replace the rpmsg_string_attr macro with explicit show and
store functions. The new driver_override_store uses the standard
driver_set_override helper. Since the introduction of
driver_set_override, the comments in include/linux/rpmsg.h have stated
that this helper must be used to set or clear driver_override, but the
implementation was not updated until now.

Because driver_set_override modifies and frees the string while holding
the device_lock, the new driver_override_show now correctly holds the
device_lock during the read operation to prevent the race.

Additionally, since rpmsg_string_attr has only ever been used for
driver_override, removing the macro simplifies the code.

Fixes: 39e47767ec9b ("rpmsg: Add driver_override device attribute for rpmsg_device")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://lore.kernel.org/r/20251202174948.12693-1-hanguidong02@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/rpmsg_core.c | 66 ++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index 5d661681a9b6c..96964745065b1 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -352,50 +352,38 @@ field##_show(struct device *dev,					\
 }									\
 static DEVICE_ATTR_RO(field);
 
-#define rpmsg_string_attr(field, member)				\
-static ssize_t								\
-field##_store(struct device *dev, struct device_attribute *attr,	\
-	      const char *buf, size_t sz)				\
-{									\
-	struct rpmsg_device *rpdev = to_rpmsg_device(dev);		\
-	const char *old;						\
-	char *new;							\
-									\
-	new = kstrndup(buf, sz, GFP_KERNEL);				\
-	if (!new)							\
-		return -ENOMEM;						\
-	new[strcspn(new, "\n")] = '\0';					\
-									\
-	device_lock(dev);						\
-	old = rpdev->member;						\
-	if (strlen(new)) {						\
-		rpdev->member = new;					\
-	} else {							\
-		kfree(new);						\
-		rpdev->member = NULL;					\
-	}								\
-	device_unlock(dev);						\
-									\
-	kfree(old);							\
-									\
-	return sz;							\
-}									\
-static ssize_t								\
-field##_show(struct device *dev,					\
-	     struct device_attribute *attr, char *buf)			\
-{									\
-	struct rpmsg_device *rpdev = to_rpmsg_device(dev);		\
-									\
-	return sprintf(buf, "%s\n", rpdev->member);			\
-}									\
-static DEVICE_ATTR_RW(field)
-
 /* for more info, see Documentation/ABI/testing/sysfs-bus-rpmsg */
 rpmsg_show_attr(name, id.name, "%s\n");
 rpmsg_show_attr(src, src, "0x%x\n");
 rpmsg_show_attr(dst, dst, "0x%x\n");
 rpmsg_show_attr(announce, announce ? "true" : "false", "%s\n");
-rpmsg_string_attr(driver_override, driver_override);
+
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
+	int ret;
+
+	ret = driver_set_override(dev, &rpdev->driver_override, buf, count);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t driver_override_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
+	ssize_t len;
+
+	device_lock(dev);
+	len = sysfs_emit(buf, "%s\n", rpdev->driver_override);
+	device_unlock(dev);
+	return len;
+}
+static DEVICE_ATTR_RW(driver_override);
 
 static ssize_t modalias_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
-- 
2.51.0

