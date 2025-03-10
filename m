Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7239230BED;
	Mon, 10 Mar 2025 17:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628036; cv=none; b=qZIqlH0sKb8/y3fscLHt/HE8DzfFD8hYZOg8S0XaMZKsR1k5FUHY/E8UQCLj0sq0Hi1BnGc7r19e/gjlDznbr2nItrvcFRx8JZqBj5i+mZd7GGCC1U+GlePSSsg0nb1SKY5GAdOtziZJyp/kMqSI7U6tTL5O0yave2vdKI1DAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628036; c=relaxed/simple;
	bh=SFdCO42f1hsnV7YlboKbHcwQc74cIUTDstwPjus94BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/GDxI/bf7zoVcTDzNpmclB30tM3Qu+/FDzF/yxMzkwPAkZgx2TFQOarSQrakc7QecjZ5a8IkkuGuhurBL7B9yibrWjHbUw/I4VGpC44WkWPjLjFGcgNN7JmbRacgDijsoWSqAgOQDuvXYhjTFXow1JQqmbL5IM6Sqht2ZV0GTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7yOc+qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7yOc+qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BECC4CEE5;
	Mon, 10 Mar 2025 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628036;
	bh=SFdCO42f1hsnV7YlboKbHcwQc74cIUTDstwPjus94BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7yOc+qhYM0F84irFgGLCZfD4WNLp3RcBHOfNU8iptU2NfiB+8hxOsTxi53QbEIXF
	 UvLVtPT74ryhLHhAvH1mBDsJ0eCBPAmjro7S0ajYYvzly7TdfFMS0yidKkPy3FdNQK
	 t01VBCSwnN4qGf+vAXVhs0bzceftUYfgLrSPOOmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 034/145] gpio: aggregator: protect driver attr handlers against module unload
Date: Mon, 10 Mar 2025 18:05:28 +0100
Message-ID: <20250310170436.109602369@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

commit 12f65d1203507f7db3ba59930fe29a3b8eee9945 upstream.

Both new_device_store and delete_device_store touch module global
resources (e.g. gpio_aggregator_lock). To prevent race conditions with
module unload, a reference needs to be held.

Add try_module_get() in these handlers.

For new_device_store, this eliminates what appears to be the most dangerous
scenario: if an id is allocated from gpio_aggregator_idr but
platform_device_register has not yet been called or completed, a concurrent
module unload could fail to unregister/delete the device, leaving behind a
dangling platform device/GPIO forwarder. This can result in various issues.
The following simple reproducer demonstrates these problems:

  #!/bin/bash
  while :; do
    # note: whether 'gpiochip0 0' exists or not does not matter.
    echo 'gpiochip0 0' > /sys/bus/platform/drivers/gpio-aggregator/new_device
  done &
  while :; do
    modprobe gpio-aggregator
    modprobe -r gpio-aggregator
  done &
  wait

  Starting with the following warning, several kinds of warnings will appear
  and the system may become unstable:

  ------------[ cut here ]------------
  list_del corruption, ffff888103e2e980->next is LIST_POISON1 (dead000000000100)
  WARNING: CPU: 1 PID: 1327 at lib/list_debug.c:56 __list_del_entry_valid_or_report+0xa3/0x120
  [...]
  RIP: 0010:__list_del_entry_valid_or_report+0xa3/0x120
  [...]
  Call Trace:
   <TASK>
   ? __list_del_entry_valid_or_report+0xa3/0x120
   ? __warn.cold+0x93/0xf2
   ? __list_del_entry_valid_or_report+0xa3/0x120
   ? report_bug+0xe6/0x170
   ? __irq_work_queue_local+0x39/0xe0
   ? handle_bug+0x58/0x90
   ? exc_invalid_op+0x13/0x60
   ? asm_exc_invalid_op+0x16/0x20
   ? __list_del_entry_valid_or_report+0xa3/0x120
   gpiod_remove_lookup_table+0x22/0x60
   new_device_store+0x315/0x350 [gpio_aggregator]
   kernfs_fop_write_iter+0x137/0x1f0
   vfs_write+0x262/0x430
   ksys_write+0x60/0xd0
   do_syscall_64+0x6c/0x180
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   [...]
   </TASK>
  ---[ end trace 0000000000000000 ]---

Fixes: 828546e24280 ("gpio: Add GPIO Aggregator")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Link: https://lore.kernel.org/r/20250224143134.3024598-2-koichiro.den@canonical.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-aggregator.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -121,10 +121,15 @@ static ssize_t new_device_store(struct d
 	struct platform_device *pdev;
 	int res, id;
 
+	if (!try_module_get(THIS_MODULE))
+		return -ENOENT;
+
 	/* kernfs guarantees string termination, so count + 1 is safe */
 	aggr = kzalloc(sizeof(*aggr) + count + 1, GFP_KERNEL);
-	if (!aggr)
-		return -ENOMEM;
+	if (!aggr) {
+		res = -ENOMEM;
+		goto put_module;
+	}
 
 	memcpy(aggr->args, buf, count + 1);
 
@@ -163,6 +168,7 @@ static ssize_t new_device_store(struct d
 	}
 
 	aggr->pdev = pdev;
+	module_put(THIS_MODULE);
 	return count;
 
 remove_table:
@@ -177,6 +183,8 @@ free_table:
 	kfree(aggr->lookups);
 free_ga:
 	kfree(aggr);
+put_module:
+	module_put(THIS_MODULE);
 	return res;
 }
 
@@ -205,13 +213,19 @@ static ssize_t delete_device_store(struc
 	if (error)
 		return error;
 
+	if (!try_module_get(THIS_MODULE))
+		return -ENOENT;
+
 	mutex_lock(&gpio_aggregator_lock);
 	aggr = idr_remove(&gpio_aggregator_idr, id);
 	mutex_unlock(&gpio_aggregator_lock);
-	if (!aggr)
+	if (!aggr) {
+		module_put(THIS_MODULE);
 		return -ENOENT;
+	}
 
 	gpio_aggregator_free(aggr);
+	module_put(THIS_MODULE);
 	return count;
 }
 static DRIVER_ATTR_WO(delete_device);


