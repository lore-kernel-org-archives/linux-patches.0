Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704901;
	b=ls+VRTx7LAt+LWJ4xo36yBkL4kwxuw2ODeG0f3O5djzopaoO4sssreAYZGP6u31skg8U
	 xc7yiDMuaqtIAdgmMij8ZrsGPwsCkmz0PhgYfl6WYM1EBGGqCvpvyIJZ2ZTo4p+FYtapp
	 uYOPhbD32k/Z2E5eVHcwAvUVVRrkawY/9eCCvIzYdNDpNiH902/T9lvx0bxnF6RlwRvsS
	 UGwCRDXcrrQ/wBI4FNhJIFn1yY56t2Xm9peSJc12w03AALK2NinmO9WljtoSSKLYZ0U5S
	 LmdPgg4MkF6mU4LGmHB5EApHmrv9Aip3C3XYimuzn1w3WWg/N5dXWWh2fI0WvDDn+3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pzzAVGfiK4g5lqtE2jXdf4/F9/UY3g9slDvrRMXlJNY=;
	b=U+owl8l/DGqJOhFXGxs9skgvo/B9wNAuf61b6u+5guDRUZJichIB5MK/ByVJIANeqRqF
	 IK62+8nB12cqLJq+yjWANQViyBGDReAskuXgpL8Q9dy9WleENRRcoxoDcFhYyogarp1+E
	 mECXmN6Gr14jN02isehDi72cfdGyb307fYs34jDbX/cVk4Noy7vN2qQBmS87B/UwYAAU/
	 nFiDOz7D2c9h9jR0witjVZ+EDGdzIW50nVUIT32w9Npcyv523NyALN2mAFaebVm97Xi/N
	 WwJNzTEn1PFhlVEHQCejVeNQYrPIHVTeu7FdZP5bCyOiYiRNOvwFRmwDyDQ1NKdnqJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjIWzdHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09863606A31C;
	Thu, 26 Nov 2026 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjIWzdHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5901F000CF;
	Thu, 26 Nov 2026 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704900;
	bh=pzzAVGfiK4g5lqtE2jXdf4/F9/UY3g9slDvrRMXlJNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjIWzdHIUAq45tjHOWYQUtLc9VDhpX9BAIf5Di/bb6WFoGKjxsn1z8JSDokgd0N7u
	 1L5QMfeWMcls/SfaIenuCaxWBs+4fszVymRAgaMLRwrLLZNpYiEhxhEfVg+7wSeFRO
	 RHhfgBiaqWHPZdbx7sy4f5fUgkGKPDWYhoahs8pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gideon Heinz <gideonheinz02@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/319] Input: destroy force-feedback device on input unregistration
Date: Thu, 26 Nov 2026 15:36:23 +0100
Message-ID: <20261126144007.084309493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2ae35f090d029d2d8491b0a7f98a04c5c05d0a44 ]

When an input device is unregistered while userspace holds an open file
descriptor to its event node, input_dev_release() is deferred until the
last file descriptor is closed. Because input_ff_destroy() was only
called from input_dev_release(), force-feedback teardown (ff->destroy
and freeing ff->private) could run after the parent driver had already
unbound, freed its device state, or even been unloaded via rmmod,
causing use-after-free errors or page faults in unmapped module text.

Commit ef166ce08801 ("Input: stop force-feedback timer when
unregistering input devices") added a separate ff->stop callback for
ff-memless, but left ff->destroy invoked from input_dev_release().

Once __input_unregister_device() has disconnected all input handlers
(which flushes effects, closes the device, and marks evdev dead) and
deleted the device from sysfs, nothing accesses dev->ff anymore. Call
input_ff_destroy() directly in __input_unregister_device() so that
ff->destroy() always runs synchronously while the driver and its module
are still active, and remove the now-redundant ff->stop callback. Keep
input_ff_destroy() in input_dev_release() (where it is a no-op once
dev->ff is NULL) to handle input_free_device() on devices that were
never registered.

Fixes: 509ca1a93836 ("Input: implement new force feedback interface")
Reported-by: Gideon Heinz <gideonheinz02@gmail.com>
Closes: https://lore.kernel.org/r/CAPb1+K2BxnfQ7VUQ15td5f9pVhn-ARSM9EjfOU8WuW72o+cvPg@mail.gmail.com
Tested-by: Gideon Heinz <gideonheinz02@gmail.com>
Link: https://patch.msgid.link/2f722967b6db0692d4dd4164aff39b62@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Added the input_ff_destroy() call after device_del() in __input_unregister_device() only, since the older tree lacks the ff->stop code that upstream also removes. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/ff-core.c | 2 +-
 drivers/input/input.c   | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index a765e185c7a12..41609fd328b18 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -361,7 +361,7 @@ EXPORT_SYMBOL_GPL(input_ff_create);
  *
  * This function is only needed in error path as input core will
  * automatically free force feedback structures when device is
- * destroyed.
+ * unregistered or destroyed.
  */
 void input_ff_destroy(struct input_dev *dev)
 {
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 171f71bd4c2a2..18b642ef61456 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2291,6 +2291,8 @@ static void __input_unregister_device(struct input_dev *dev)
 	mutex_unlock(&input_mutex);
 
 	device_del(&dev->dev);
+
+	input_ff_destroy(dev);
 }
 
 static void devm_input_device_unregister(struct device *dev, void *res)
-- 
2.53.0



