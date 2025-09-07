Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BFE1CDFAC;
	Sun,  7 Sep 2025 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275802; cv=none; b=dA7DRt1uR+0GSfSQ7vsDrQGdNG0MEOiRaWfb8hjwopPKI9RPw81bs+HHpcDUpi9asgKedq8XebWGZ5F1vcqvIAb33tiR1jBI/d/Q0l+h10VVd2zZZe2yCmDLlub+229+KW4rfm5rKjZ7DEaWwMMEmHAX+b6KoZWybSFRaIV1mvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275802; c=relaxed/simple;
	bh=vqhGcQEmxIi3YyvMhbmkY40Yv6Dh5iN4ph/8DZyetSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohjOvQUMOhR5I44bKAxdPEj43/4yFlEcZpTFSEfAYlf6hzs8ur2ETG4XQcizVyQ3miQEF6CwsYGGv5NYediG67Mnfn8TXoccmIyNwejP/XFBPWFYYx9Ng5mgst5svtgAylsdTDALXVWipG7TKhub9JUizG1iTvs1O+8RoItmqCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s34oDegd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s34oDegd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFF1C4CEF0;
	Sun,  7 Sep 2025 20:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275802;
	bh=vqhGcQEmxIi3YyvMhbmkY40Yv6Dh5iN4ph/8DZyetSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s34oDegdPWh6eGEbqUcWBLVwVewS+WV8PDeI8MlzPYDXBm0DofwC/DaJk6xStv4pA
	 FG3mB3OI16IXNOmYxnJN9IJuygqzMLloeS3J6gszOj/TSlewpoDK5sanmWtE5N7/k7
	 jKYi8gY59UHiRPRvsx0Uqt83B+xYfa12rJwMt54k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/45] net: atm: fix memory leak in atm_register_sysfs when device_register fail
Date: Sun,  7 Sep 2025 21:58:02 +0200
Message-ID: <20250907195601.432697736@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 0a228624bcc00af41f281a2a84c928595a74c17d ]

When device_register() return error in atm_register_sysfs(), which can be
triggered by kzalloc fail in device_private_init() or other reasons,
kmemleak reports the following memory leaks:

unreferenced object 0xffff88810182fb80 (size 8):
  comm "insmod", pid 504, jiffies 4294852464
  hex dump (first 8 bytes):
    61 64 75 6d 6d 79 30 00                          adummy0.
  backtrace (crc 14dfadaf):
    __kmalloc_node_track_caller_noprof+0x335/0x450
    kvasprintf+0xb3/0x130
    kobject_set_name_vargs+0x45/0x120
    dev_set_name+0xa9/0xe0
    atm_register_sysfs+0xf3/0x220
    atm_dev_register+0x40b/0x780
    0xffffffffa000b089
    do_one_initcall+0x89/0x300
    do_init_module+0x27b/0x7d0
    load_module+0x54cd/0x5ff0
    init_module_from_file+0xe4/0x150
    idempotent_init_module+0x32c/0x610
    __x64_sys_finit_module+0xbd/0x120
    do_syscall_64+0xa8/0x270
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

When device_create_file() return error in atm_register_sysfs(), the same
issue also can be triggered.

Function put_device() should be called to release kobj->name memory and
other device resource, instead of kfree().

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250901063537.1472221-1-wangliang74@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/resources.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/atm/resources.c b/net/atm/resources.c
index e244c2576d1e0..a00799254e2d6 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -114,7 +114,9 @@ struct atm_dev *atm_dev_register(const char *type, struct device *parent,
 
 	if (atm_proc_dev_register(dev) < 0) {
 		pr_err("atm_proc_dev_register failed for dev %s\n", type);
-		goto out_fail;
+		mutex_unlock(&atm_dev_mutex);
+		kfree(dev);
+		return NULL;
 	}
 
 	if (atm_register_sysfs(dev, parent) < 0) {
@@ -130,7 +132,7 @@ struct atm_dev *atm_dev_register(const char *type, struct device *parent,
 	return dev;
 
 out_fail:
-	kfree(dev);
+	put_device(&dev->class_dev);
 	dev = NULL;
 	goto out;
 }
-- 
2.50.1



