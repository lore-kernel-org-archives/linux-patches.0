Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D399185935;
	Tue, 21 Jan 2025 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482382; cv=none; b=HcS5f2+L25GxGqkKGXablf3epsanpj12O4oUhfTov9wVp5ajhO7wxWYPerQCNnbnx0xolrK5xZKbJlpjRWpxAZV31VeVkT9n/tsbJMYd49M0jOSnaGMlrPknVDJJOLHC4bJH0+Eq25pe7YXtXh7s9e+LC8qd2Kcu6SW7fo4y+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482382; c=relaxed/simple;
	bh=ymLFT1EDL29LEZm2yVvEnLs8/loDn75iPFNA+yy1pWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abmfpF2yRek5/g2CdPPnB/dC0WxwT+a7szMvCNe+YvaHdpN5xFwXfcOJFeVAbS56nC0c3hpTLXHbCBgiubXUNEy0/YR6KCfkPLubG7MTHuE/JZGJgQQZq0W4TnPij8TqRyZz65e8mcgTFNYwKgOPR1C+jcCeTz5JW75XiDQuYyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFVdRnGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFVdRnGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99B1C4CEDF;
	Tue, 21 Jan 2025 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482382;
	bh=ymLFT1EDL29LEZm2yVvEnLs8/loDn75iPFNA+yy1pWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFVdRnGvulmWOUue/2zL+P5Ma3kMcyKEiOopemhUDFDxZco7QOHwPVlBK+9YnrQI4
	 aX88f3uH1nvzLY/1KCiLLnDwg02DGLkYbTyXmi7uLV/D7YF6TngyxdsTA6mmzE312E
	 be4W1BNJHiybV1Of2YtWYRY8D9MJBI5advGvz0Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/122] gpio: virtuser: lock up configfs that an instantiated device depends on
Date: Tue, 21 Jan 2025 18:51:45 +0100
Message-ID: <20250121174535.186561523@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

[ Upstream commit c7c434c1dba955005f5161dae73f09c0a922cfa7 ]

Once a virtuser device is instantiated and actively used, allowing rmdir
for its configfs serves no purpose and can be confusing. Userspace
interacts with the virtual consumer at arbitrary times, meaning it
depends on its existence.

Make the subsystem itself depend on the configfs entry for a virtuser
device while it is in active use.

Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Link: https://lore.kernel.org/r/20250103141829.430662-4-koichiro.den@canonical.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 47 ++++++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index d6244f0d3bc75..e89f299f21400 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -1546,6 +1546,30 @@ gpio_virtuser_device_deactivate(struct gpio_virtuser_device *dev)
 	dev->pdev = NULL;
 }
 
+static void
+gpio_virtuser_device_lockup_configfs(struct gpio_virtuser_device *dev, bool lock)
+{
+	struct configfs_subsystem *subsys = dev->group.cg_subsys;
+	struct gpio_virtuser_lookup_entry *entry;
+	struct gpio_virtuser_lookup *lookup;
+
+	/*
+	 * The device only needs to depend on leaf lookup entries. This is
+	 * sufficient to lock up all the configfs entries that the
+	 * instantiated, alive device depends on.
+	 */
+	list_for_each_entry(lookup, &dev->lookup_list, siblings) {
+		list_for_each_entry(entry, &lookup->entry_list, siblings) {
+			if (lock)
+				WARN_ON(configfs_depend_item_unlocked(
+						subsys, &entry->group.cg_item));
+			else
+				configfs_undepend_item_unlocked(
+						&entry->group.cg_item);
+		}
+	}
+}
+
 static ssize_t
 gpio_virtuser_device_config_live_store(struct config_item *item,
 				       const char *page, size_t count)
@@ -1558,15 +1582,24 @@ gpio_virtuser_device_config_live_store(struct config_item *item,
 	if (ret)
 		return ret;
 
-	guard(mutex)(&dev->lock);
+	if (live)
+		gpio_virtuser_device_lockup_configfs(dev, true);
 
-	if (live == gpio_virtuser_device_is_live(dev))
-		return -EPERM;
+	scoped_guard(mutex, &dev->lock) {
+		if (live == gpio_virtuser_device_is_live(dev))
+			ret = -EPERM;
+		else if (live)
+			ret = gpio_virtuser_device_activate(dev);
+		else
+			gpio_virtuser_device_deactivate(dev);
+	}
 
-	if (live)
-		ret = gpio_virtuser_device_activate(dev);
-	else
-		gpio_virtuser_device_deactivate(dev);
+	/*
+	 * Undepend is required only if device disablement (live == 0)
+	 * succeeds or if device enablement (live == 1) fails.
+	 */
+	if (live == !!ret)
+		gpio_virtuser_device_lockup_configfs(dev, false);
 
 	return ret ?: count;
 }
-- 
2.39.5



