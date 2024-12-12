Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB5D221D93;
	Thu, 12 Dec 2024 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022298; cv=none; b=jyvAYOjb9SALElY72Oo28E9FRQDL+QCJ1GFwmKy2tQg4sb2yOTJv7ei/jN/ZmXsE7zbeJ169uAvJ0qEHjdAtxpEadEFCBNoZKtXmujVY5fneJKjb+2xA0KLmxORzmeWPktX1Hu01z5fWai9Go1s5KbRlIbEAOVUqClasB+vt630=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022298; c=relaxed/simple;
	bh=q2ddmTfjcwRJvh4KTEyNEDBFEZvk7pGZAG6nVjwt4Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMNU4jX9C+T2gzCgedckoe3U/XhSxRLFXAJDmwTaBs7XtW8pas9EegTK1dbqCWeFxJzm5Vd1+tuJs1zJHwBY2fXbhKz6MLnszSiL4oqOt6HxqmVSq80jtMctgJ1HKJleTJZqu3ex+EIMfDAuQRcSC6Ky9t1mreiNjqK8KI7fQNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+1gfgvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+1gfgvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20705C4CECE;
	Thu, 12 Dec 2024 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022298;
	bh=q2ddmTfjcwRJvh4KTEyNEDBFEZvk7pGZAG6nVjwt4Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+1gfgvRgXZizPyaBz9wcC2jefZTs1nr/5ngT1iEuJJ2LDU1pTh6MsaP4cKleX5c0
	 TwMiucIeeWATrZppYN9ZCUwNuTvc9PNO85e5NEB+mb8KDdYxCStqtyr6aVUMwXo/me
	 vi3TxHgAy1Jv1ndJVb7ACuI5ZPi5QiAgBME3Bldg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/565] driver core: Introduce device_find_any_child() helper
Date: Thu, 12 Dec 2024 15:56:39 +0100
Message-ID: <20241212144319.554565743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 82b070beae1ef55b0049768c8dc91d87565bb191 ]

There are several places in the kernel where this kind of functionality is
being used. Provide a generic helper for such cases.

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220610120219.18988-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 27aabf27fd01 ("Bluetooth: fix use-after-free in device_for_each_child()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 20 ++++++++++++++++++++
 include/linux/device.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d995d768c362a..4fc62624a95e2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3829,6 +3829,26 @@ struct device *device_find_child_by_name(struct device *parent,
 }
 EXPORT_SYMBOL_GPL(device_find_child_by_name);
 
+static int match_any(struct device *dev, void *unused)
+{
+	return 1;
+}
+
+/**
+ * device_find_any_child - device iterator for locating a child device, if any.
+ * @parent: parent struct device
+ *
+ * This is similar to the device_find_child() function above, but it
+ * returns a reference to a child device, if any.
+ *
+ * NOTE: you will need to drop the reference with put_device() after use.
+ */
+struct device *device_find_any_child(struct device *parent)
+{
+	return device_find_child(parent, NULL, match_any);
+}
+EXPORT_SYMBOL_GPL(device_find_any_child);
+
 int __init devices_init(void)
 {
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
diff --git a/include/linux/device.h b/include/linux/device.h
index 3e04bd84f1264..440c9f1a3f350 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -830,6 +830,8 @@ struct device *device_find_child(struct device *dev, void *data,
 				 int (*match)(struct device *dev, void *data));
 struct device *device_find_child_by_name(struct device *parent,
 					 const char *name);
+struct device *device_find_any_child(struct device *parent);
+
 int device_rename(struct device *dev, const char *new_name);
 int device_move(struct device *dev, struct device *new_parent,
 		enum dpm_order dpm_order);
-- 
2.43.0



