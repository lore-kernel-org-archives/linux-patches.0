Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246551D88D0;
	Sun,  7 Sep 2025 20:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276222; cv=none; b=ifHDGRCRhsqhuoDzQrktRku6MYZyMBqjiAOlrpPx4Nr9oaGQVEiuS4qnQOQBjk7mWGleqSCc+z+6RgXV5Pol8FCiz5nIvFn+Fr0dn7Qq2G8qdlLS5AM5UBHDSIOwTi/01p7u0t4wQPwj/uwxicuM6zU6Ck2JA++Up2b4hjmuBcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276222; c=relaxed/simple;
	bh=1x6pbrbZybFi9HTBfxA4Cdgu3EwuC/T4BvEJmQIDTr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpyJPZG0v8aJsW1ckUVvKNsjq7TjcriSZ8hQWSBEPFXYKThH+7l9JpUxIhcBW+Nk/LqYhKWRvLWJ31n8e7YI1omyNbHlWurCXK7U+VRbMbzX9JneNQyoXmj6NNsjACGk/P/buzxLqP/HtRWOkSwvm1NYab8uZaQdVfE/ogCaAzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOI/QOnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOI/QOnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F90C4CEF0;
	Sun,  7 Sep 2025 20:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276222;
	bh=1x6pbrbZybFi9HTBfxA4Cdgu3EwuC/T4BvEJmQIDTr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOI/QOnbZxJTv9jM69MjDA05NEM6C1wWWMKNTZblcCoi7mjquhhTVGW0sbVl07zwP
	 V8GjXM9RyQCZ6FSYuEeVolfWZc7nsj1PCi1p155TrigHd0EwOwdtNyvGoqQs1TEMnb
	 hgNwLQNY1i9PSxPHY85QNqXTjkKmPvz3r+gy10ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/104] net: atm: fix memory leak in atm_register_sysfs when device_register fail
Date: Sun,  7 Sep 2025 21:57:53 +0200
Message-ID: <20250907195608.634215118@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b19d851e1f443..7c6fdedbcf4e5 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -112,7 +112,9 @@ struct atm_dev *atm_dev_register(const char *type, struct device *parent,
 
 	if (atm_proc_dev_register(dev) < 0) {
 		pr_err("atm_proc_dev_register failed for dev %s\n", type);
-		goto out_fail;
+		mutex_unlock(&atm_dev_mutex);
+		kfree(dev);
+		return NULL;
 	}
 
 	if (atm_register_sysfs(dev, parent) < 0) {
@@ -128,7 +130,7 @@ struct atm_dev *atm_dev_register(const char *type, struct device *parent,
 	return dev;
 
 out_fail:
-	kfree(dev);
+	put_device(&dev->class_dev);
 	dev = NULL;
 	goto out;
 }
-- 
2.50.1



