Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9412222AC;
	Thu, 13 Feb 2025 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457472; cv=none; b=mvAE8WJ75nJ274RcQWeuko1hcmkv6oMlYXrzt+ooCimkuIIN3hLPkcva7oQ/F8cWzuZ2Pl0a5vqAFZSltoR9u/wiinN0jpJN68b4L6qZwFCQpJDALs/D8UFlyQVWGRiMN0I3piY0SI5GBxS4OPeYdywOYnalyRRaLaKP+vimV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457472; c=relaxed/simple;
	bh=XN/iInvz9uTMJApa2tlsrvcwkrgHnmqRIi98VQ4Cxwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdM87tOvw3+w51hAg7sCQ037B9KbA1S/FA0NFO7vz10UUulW2RD9iioFPqS4oybvFhDqq7b8Y5HFT3tRAxEs8gAYnkc0OQ2R19Eukv4mJQgEPKF+yvg/qUnKqbqCrjYn8Mh++XSdoNUKK1mUV5NvM80sgtUXSGNc+aeXK1eACRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgjQ7Q5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgjQ7Q5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B68DC4CED1;
	Thu, 13 Feb 2025 14:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457471;
	bh=XN/iInvz9uTMJApa2tlsrvcwkrgHnmqRIi98VQ4Cxwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgjQ7Q5Ar3riZkCQCsieG8WsFHwOF9Atn17ypB75Iw3+m3nnNUXvCiVs5QH33sqOK
	 qsXvk/hR4uqWxiYKdzTdcjKCtwd0j2uR2XdMIkk3hAybYAWzpolbaS0UPE0T1wwdQ9
	 IbmAzGd+noa12ivdxLhMWIjaKC+23A8q+GfR8DTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/422] gpio: sim: lock hog configfs items if present
Date: Thu, 13 Feb 2025 15:24:28 +0100
Message-ID: <20250213142441.143148466@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
index deedacdeb2395..f83a8b5a51d0d 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -1036,20 +1036,23 @@ gpio_sim_device_lockup_configfs(struct gpio_sim_device *dev, bool lock)
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



