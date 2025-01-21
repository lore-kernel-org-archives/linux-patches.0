Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435AB1F238E;
	Tue, 21 Jan 2025 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482385; cv=none; b=MsG31FCdiorqCtWvrbfuiTLJMS57TeMkSc/8lTbFWVamhMLRhNPCLYy5FEzf149XqaC/HXqbfe5IxH6cRY2OjBI0ZbKO+yyQ9M3nD/CeK7Y3nnRyPoSalXTudloD/83kZTrGa94V8JAMndily8LakDe3xfOmETnvE11U4w2YjSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482385; c=relaxed/simple;
	bh=d8WkeqpKl1KcEYmGwL1tzrPc6LuSjrQ8D8AsAWCYNQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBs7oS4xDzYaI9Td70uiKRrMVntIZnhtklLH9dgkgbXmk1z/yiNXwNh5VHwXfUlW5Nl7HtE9D7xAMxISmwVIu9zlhPzPw+jLv9OA07bJE3v5VYsxHusajpJkVCptaohyAoKDELw39+RjFIHoKMdPUxb6SBwsf+hhn6G9U+nP2EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERQ51317; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERQ51317"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC895C4CEDF;
	Tue, 21 Jan 2025 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482385;
	bh=d8WkeqpKl1KcEYmGwL1tzrPc6LuSjrQ8D8AsAWCYNQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERQ51317qXC+eVHOwoGk6FJeT1C7WXwtvrBeJx4e1qnV1mEVZVnLhiPaMq8wqAJiQ
	 MU3YA/ZtU+6kpCWsLGgYF9NB0+Dohuc4wbOWhYeMHpg+Y8E33o7lirg9fRkqkqe9A5
	 Cczu9KPxAPgsQ+/K427NHOXVSGouCqwtdhBfQ5eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/122] gpio: sim: lock up configfs that an instantiated device depends on
Date: Tue, 21 Jan 2025 18:51:46 +0100
Message-ID: <20250121174535.226280096@linuxfoundation.org>
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

[ Upstream commit 8bd76b3d3f3af7ac2898b6a27ad90c444fec418f ]

Once a sim device is instantiated and actively used, allowing rmdir for
its configfs serves no purpose and can be confusing. Effectively,
arbitrary users start depending on its existence.

Make the subsystem itself depend on the configfs entry for a sim device
while it is in active use.

Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Link: https://lore.kernel.org/r/20250103141829.430662-5-koichiro.den@canonical.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sim.c | 48 +++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index dcca1d7f173e5..deedacdeb2395 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -1030,6 +1030,30 @@ static void gpio_sim_device_deactivate(struct gpio_sim_device *dev)
 	dev->pdev = NULL;
 }
 
+static void
+gpio_sim_device_lockup_configfs(struct gpio_sim_device *dev, bool lock)
+{
+	struct configfs_subsystem *subsys = dev->group.cg_subsys;
+	struct gpio_sim_bank *bank;
+	struct gpio_sim_line *line;
+
+	/*
+	 * The device only needs to depend on leaf line entries. This is
+	 * sufficient to lock up all the configfs entries that the
+	 * instantiated, alive device depends on.
+	 */
+	list_for_each_entry(bank, &dev->bank_list, siblings) {
+		list_for_each_entry(line, &bank->line_list, siblings) {
+			if (lock)
+				WARN_ON(configfs_depend_item_unlocked(
+						subsys, &line->group.cg_item));
+			else
+				configfs_undepend_item_unlocked(
+						&line->group.cg_item);
+		}
+	}
+}
+
 static ssize_t
 gpio_sim_device_config_live_store(struct config_item *item,
 				  const char *page, size_t count)
@@ -1042,14 +1066,24 @@ gpio_sim_device_config_live_store(struct config_item *item,
 	if (ret)
 		return ret;
 
-	guard(mutex)(&dev->lock);
+	if (live)
+		gpio_sim_device_lockup_configfs(dev, true);
 
-	if (live == gpio_sim_device_is_live(dev))
-		ret = -EPERM;
-	else if (live)
-		ret = gpio_sim_device_activate(dev);
-	else
-		gpio_sim_device_deactivate(dev);
+	scoped_guard(mutex, &dev->lock) {
+		if (live == gpio_sim_device_is_live(dev))
+			ret = -EPERM;
+		else if (live)
+			ret = gpio_sim_device_activate(dev);
+		else
+			gpio_sim_device_deactivate(dev);
+	}
+
+	/*
+	 * Undepend is required only if device disablement (live == 0)
+	 * succeeds or if device enablement (live == 1) fails.
+	 */
+	if (live == !!ret)
+		gpio_sim_device_lockup_configfs(dev, false);
 
 	return ret ?: count;
 }
-- 
2.39.5



