Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20C2EAE1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUCRprTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9341BC433C7;
	Wed, 15 Nov 2023 19:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077246;
	bh=nfxFBvV+VAhr9TwZb9eCBZfkyUsZ2R2EcQcvOSKhob8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUCRprTgAshA9reBw1DxNNqyGr35Ml/1EWcLHkri7lNz1JHUBl+b80rTCqaEB+ADZ
	 3H8vk2/R17amf0Na9qzwgDlWZQG9hMKtnVPqzxXw6RwbHqkFXZcbAP7q+6ApyKV2Z1
	 1nLjh3nLiPF0vDP4T7V3tFEH7dek0z0rtoiuWUJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/603] gpio: sim: initialize a managed pointer when declaring it
Date: Wed, 15 Nov 2023 14:11:51 -0500
Message-ID: <20231115191624.683273514@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 9f93f18305f5777820491e6ab9b34422c160371b ]

Variables managed with __free() should typically be initialized where
they are declared so that the __free() callback is paired with its
counterpart resource allocator. Fix the second instance of using
__free() in gpio-sim to follow this pattern.

Fixes: 3faf89f27aab ("gpio: sim: simplify code with cleanup helpers")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index 44bf1709a6488..a8e5ac95cf170 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -1438,10 +1438,10 @@ static const struct config_item_type gpio_sim_device_config_group_type = {
 static struct config_group *
 gpio_sim_config_make_device_group(struct config_group *group, const char *name)
 {
-	struct gpio_sim_device *dev __free(kfree) = NULL;
 	int id;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	struct gpio_sim_device *dev __free(kfree) = kzalloc(sizeof(*dev),
+							    GFP_KERNEL);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.42.0



