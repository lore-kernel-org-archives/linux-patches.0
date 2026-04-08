Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14E72F39C2;
	Wed,  8 Apr 2026 18:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674634; cv=none; b=umAPiCLd/HRvw6xKWfTzjgsYmvjI0JBRI6qCEVOOrq7BWC3969c18bVxqoyovsLE6xxSqy+WSishN+rR/ACOozeBeGGQrmuqOy8i08isXikV+nADhiERUOBoCkfqv4/hEP2S6bzNO0x6BU1ZY0gD3jOjEewHfC8QLhc6IRIJ8QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674634; c=relaxed/simple;
	bh=dDgOZdF9kx1k1fSGJtV9DWZqRS8Gf3MH+OR6f4jGtkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlIsrKrApDiAVKrFLZZzAvlY5q5Y+aC7gofiKGValoVwYLOxePYJ+srcau7Uz2tDyyTMqxEKnLBW/zxXIm9Q68xbKRkRdBbWPhtsi9lFIAwMMOrO+y7FdL3kYSutxBV37HeU4PGIBd6Z9Op97wfjrDWL8qitiZHMxGrUmPM+U+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTGogTQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTGogTQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78207C19421;
	Wed,  8 Apr 2026 18:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674633;
	bh=dDgOZdF9kx1k1fSGJtV9DWZqRS8Gf3MH+OR6f4jGtkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTGogTQDEz9P5mL1K+O4xgkXeV3T51scJwNa3ffk5MTF5WIE+x9+MsSDx8TIZhypj
	 hBDjX0o1jxaoecKyHSjJ6bM9mRqVtg/MNaUNeNIBHPxToStHulew0Obz1qh32yuIVH
	 VKuHyETrgY9J9q1lw7ictoeniDrPdPSN49ysrMpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 140/311] gpio: shared: shorten the critical section in gpiochip_setup_shared()
Date: Wed,  8 Apr 2026 20:02:20 +0200
Message-ID: <20260408175944.643862213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 310a4a9cbb17037668ea440f6a3964d00705b400 ]

Commit 710abda58055 ("gpio: shared: call gpio_chip::of_xlate() if set")
introduced a critical section around the adjustmenet of entry->offset.
However this may cause a deadlock if we create the auxiliary shared
proxy devices with this lock taken. We only need to protect
entry->offset while it's read/written so shorten the critical section
and release the lock before creating the proxy device as the field in
question is no longer accessed at this point.

Fixes: 710abda58055 ("gpio: shared: call gpio_chip::of_xlate() if set")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260325-gpio-shared-deadlock-v1-1-e4e7a5319e95@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-shared.c | 56 +++++++++++++++++------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/gpio/gpiolib-shared.c b/drivers/gpio/gpiolib-shared.c
index 9c31736d29b77..692f568ffe7a4 100644
--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -538,48 +538,48 @@ int gpiochip_setup_shared(struct gpio_chip *gc)
 	 * exposing shared pins. Find them and create the proxy devices.
 	 */
 	list_for_each_entry(entry, &gpio_shared_list, list) {
-		guard(mutex)(&entry->lock);
-
 		if (!device_match_fwnode(&gdev->dev, entry->fwnode))
 			continue;
 
 		if (list_count_nodes(&entry->refs) <= 1)
 			continue;
 
+		scoped_guard(mutex, &entry->lock) {
 #if IS_ENABLED(CONFIG_OF)
-		if (is_of_node(entry->fwnode) && gc->of_xlate) {
-			/*
-			 * This is the earliest that we can tranlate the
-			 * devicetree offset to the chip offset.
-			 */
-			struct of_phandle_args gpiospec = { };
+			if (is_of_node(entry->fwnode) && gc->of_xlate) {
+				/*
+				 * This is the earliest that we can tranlate the
+				 * devicetree offset to the chip offset.
+				 */
+				struct of_phandle_args gpiospec = { };
 
-			gpiospec.np = to_of_node(entry->fwnode);
-			gpiospec.args_count = 2;
-			gpiospec.args[0] = entry->offset;
+				gpiospec.np = to_of_node(entry->fwnode);
+				gpiospec.args_count = 2;
+				gpiospec.args[0] = entry->offset;
 
-			ret = gc->of_xlate(gc, &gpiospec, NULL);
-			if (ret < 0)
-				return ret;
+				ret = gc->of_xlate(gc, &gpiospec, NULL);
+				if (ret < 0)
+					return ret;
 
-			entry->offset = ret;
-		}
+				entry->offset = ret;
+			}
 #endif /* CONFIG_OF */
 
-		desc = &gdev->descs[entry->offset];
+			desc = &gdev->descs[entry->offset];
 
-		__set_bit(GPIOD_FLAG_SHARED, &desc->flags);
-		/*
-		 * Shared GPIOs are not requested via the normal path. Make
-		 * them inaccessible to anyone even before we register the
-		 * chip.
-		 */
-		ret = gpiod_request_commit(desc, "shared");
-		if (ret)
-			return ret;
+			__set_bit(GPIOD_FLAG_SHARED, &desc->flags);
+			/*
+			 * Shared GPIOs are not requested via the normal path. Make
+			 * them inaccessible to anyone even before we register the
+			 * chip.
+			 */
+			ret = gpiod_request_commit(desc, "shared");
+			if (ret)
+				return ret;
 
-		pr_debug("GPIO %u owned by %s is shared by multiple consumers\n",
-			 entry->offset, gpio_device_get_label(gdev));
+			pr_debug("GPIO %u owned by %s is shared by multiple consumers\n",
+				 entry->offset, gpio_device_get_label(gdev));
+		}
 
 		list_for_each_entry(ref, &entry->refs, list) {
 			pr_debug("Setting up a shared GPIO entry for %s (con_id: '%s')\n",
-- 
2.53.0



