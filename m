Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D38153D0A0;
	Thu, 17 Sep 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659214; cv=none; b=uo9HPR120k4OgTM9o7lPFp2m1r6zmyGZf4XhEgM2ez3Rm0Vlpu05cKN9XPwBdMordrm36kstxRGT1GjcQZ+b3WNUgFgLZ2aqN433epxUNr2vbbHRbqNkbdqzbRNQ9F9q5TiA3TIsUl0M0mFK9wSXauyASwF1OZl5spjjTLI8oG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659214; c=relaxed/simple;
	bh=ofqvKcuZB5X3UmTGuTKdPdPkyaxlenjzEStMt1vxOzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScRmQVqVEaPpF1Qmr+zjHnko5pcY07/ZNcALDo0t2gwhYccS1og8ZrtL1o7J58HxQEvLIuI0czsoJzaUWz3mbNaF33rl99LS6aT6imfAwY9DfSZRTliaI2qUxAzbNmYozZUSbGAB3hsX245LopcCHCQGejzPwTk8VDzaqcZzeKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoxUu+8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoxUu+8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA1C1F0089C;
	Thu, 17 Sep 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659200;
	bh=ORlCHbHf/KjKOzqr62z+8kv0Zt+8+mG1k5gccjsxoSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoxUu+8teKM0vRYw5cyqcc2uqqUPlX3lqOxycLe63cco2PFtgYdmZiG3YgvCgHDxh
	 w7zykc5kyUCRmAfFpjIrgn896DL+ZqJ5R0nLm+P7fK7MwSpB2GErCrlYLltfifqSol
	 5xt391VcvT3/txdsX4ScJtIwUyRdjs3B8+7N3ZhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 178/733] platform/x86: x86-android-tablets: hold device reference for secondary fwnode teardown
Date: Thu, 17 Sep 2026 16:08:06 +0100
Message-ID: <20260917151355.550855966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 144113b0a70fa18033a747ee5db6803308f7688c ]

In gpio_secondary_fwnode_init(), acpi_bus_find_device_by_name() returns a
device reference, but the local dev variable is declared with
__free(put_device), dropping the reference at the end of each iteration.
Meanwhile, devm_add_action_or_reset() saves the dev pointer for
gpio_secondary_unset() without incrementing its reference count, which
could lead to a use-after-free during driver teardown if the device is
released in the interim.

Acquire an explicit device reference with get_device() when registering
the devres action, and drop it with put_device() inside
gpio_secondary_unset().

Fixes: 1448c2d2ca5c ("platform/x86: x86-android-tablets: enable fwnode matching of GPIO chips")
Assisted-by: LLM
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Hans de Goede <johannes.goede@oss.qualcomm.com> # Yoga tab 2 1380, yt3
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260830-x86-android-lenovo-swnode-v1-2-066a91acb4ba@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index 5db794d65eb5f..722c0ae4ecd12 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -367,6 +367,7 @@ static void gpio_secondary_unset(void *data)
 	struct device *dev = data;
 
 	set_secondary_fwnode(dev, NULL);
+	put_device(dev);
 }
 
 static void gpio_secondary_unregister_node_group(void *data)
@@ -409,7 +410,7 @@ static int gpio_secondary_fwnode_init(struct device *parent)
 
 		set_secondary_fwnode(dev, fwnode);
 
-		ret = devm_add_action_or_reset(parent, gpio_secondary_unset, dev);
+		ret = devm_add_action_or_reset(parent, gpio_secondary_unset, get_device(dev));
 		if (ret)
 			return ret;
 	}
-- 
2.53.0



