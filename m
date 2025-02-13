Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525561C07C3;
	Thu, 13 Feb 2025 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458978; cv=none; b=hRN3xartLee8OPz0HnwGZFLnXxtWl3azBlNCLn9nEeqZ99/RV7WceN5/IirbCLK5KlM2H2VWPLKGDAvB4qN61y0cJyN75a0j2VvFNqiuk60KDuHGkKeFYI6QpjYODd0RMIO9pK8WDrUtQFj7Ny47x27VfdGNkukfnr+43AqN5G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458978; c=relaxed/simple;
	bh=+0lnDLIr++ZFnHQn3/gB36P+lMm5q66cdeiPAnMyz3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5AyqgGQYe+jiW8XM5aQOlNLC6XK+jqDFGs/TTTUXIDQqu5PL7GnvuRWu0gxnSYiuifyXRDDGk3bcD/rP84LBGhh6SDnKeEPDrWiK8UgvvXfWtBEMWOQvj3GLzvIiXvxE3ZDXrmaw0w1RSIRjfnpnxdWzCu5JmADZ9y75BqfJW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjcapnI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjcapnI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49B9C4CED1;
	Thu, 13 Feb 2025 15:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458978;
	bh=+0lnDLIr++ZFnHQn3/gB36P+lMm5q66cdeiPAnMyz3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjcapnI22avp9S1/O9n9ryAbGIqcv9yFNgVPggTLFTtJCfZkpv6KWW7AJ8jykKCkr
	 m4OrLi94R09Cny6NVoImXH4kZXWp8za0Y0im63p+1cUr07RF6WOQ0OgmkcZBvfK8+E
	 pExgz/I4I7EZjIoXQwzatA1tuQPh/tOA4tz1toBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 131/443] gpio: sim: lock hog configfs items if present
Date: Thu, 13 Feb 2025 15:24:56 +0100
Message-ID: <20250213142445.662354053@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 015b7dae084fa95465ff89f6cbf15fe49906a370 ]

Depending on the user config, the leaf entry may be the hog directory,
not line. Check it and lock the correct item.

Fixes: 8bd76b3d3f3a ("gpio: sim: lock up configfs that an instantiated device depends on")
Tested-by: Koichiro Den <koichiro.den@canonical.com>
Link: https://lore.kernel.org/r/20250203110123.87701-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sim.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index 686ae3d11ba36..940165235db64 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -1033,20 +1033,23 @@ gpio_sim_device_lockup_configfs(struct gpio_sim_device *dev, bool lock)
 	struct configfs_subsystem *subsys = dev->group.cg_subsys;
 	struct gpio_sim_bank *bank;
 	struct gpio_sim_line *line;
+	struct config_item *item;
 
 	/*
-	 * The device only needs to depend on leaf line entries. This is
+	 * The device only needs to depend on leaf entries. This is
 	 * sufficient to lock up all the configfs entries that the
 	 * instantiated, alive device depends on.
 	 */
 	list_for_each_entry(bank, &dev->bank_list, siblings) {
 		list_for_each_entry(line, &bank->line_list, siblings) {
+			item = line->hog ? &line->hog->item
+					 : &line->group.cg_item;
+
 			if (lock)
-				WARN_ON(configfs_depend_item_unlocked(
-						subsys, &line->group.cg_item));
+				WARN_ON(configfs_depend_item_unlocked(subsys,
+								      item));
 			else
-				configfs_undepend_item_unlocked(
-						&line->group.cg_item);
+				configfs_undepend_item_unlocked(item);
 		}
 	}
 }
-- 
2.39.5



