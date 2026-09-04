Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A035B632;
	Fri,  4 Sep 2026 06:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502418; cv=none; b=XTUkx/5MAESxh43eywrcobpkQ66dhcF3lQnDjtOd2tvw7rAaILUQkcRDbKusUIZ4Q3GZQSB9SvdlwM9QWH+EBGy4wU0rj5HkFxZtedWfgJeYZmYLxsaYzmRhnGcgXhmJjspA7YfKJ+xJUq3QF1LJKO4AniWu9tsyuiH+UCMjVL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502418; c=relaxed/simple;
	bh=CR98goAluIHFtdwDCU9QvJsBpomkcmWFF5QFQKr0qpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ntl/IvUcKkubVvHAsoZ3XVWFMQs/fxOOXC5RhaqvwVaa//2hlCdj+0zxFCfBz24ccEecRpWQBvaPuPV6VPIrPj6fckh//7IQijiRM9pX87a4Z008NFuxVVz/NmeCRwOyyO3Acz4aEJVAgy7lS8bKuaYPEFPimwIuuzfrekejRXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiOPBx0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiOPBx0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2151F00A3D;
	Fri,  4 Sep 2026 06:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502416;
	bh=5nwc4OnuCUT5pFJjwRWdp8J2iIlzVFMdyFk2I9U0+7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiOPBx0pBYAsoX/IcjOUv2ZuoTehRHTJftIHmxhyGs7OacSOO2GfRuize108ZiKvK
	 UJR9Www/YwMkdHvrSI66ozNqPOSRKd7dgj8i+hVaw9Qj/pGG8nugN4IepbboCNx67U
	 T0ohD8acygy1yC3KCqhts9LcUK3w109MMYef7hvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH 6.12 200/403] params: fix charp corruption on allocation failure
Date: Fri,  4 Sep 2026 07:00:03 +0200
Message-ID: <20260904045739.402614879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Yu <yujiacheng3@huawei.com>

commit 3dfaae04243cde460d82dfc2a7dd0bb6664d20ae upstream.

param_set_charp() stores charp parameters in allocated memory after slab is
available, and releases the previous value when the parameter is updated.

The previous value is released before the replacement allocation succeeds.
If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
left as NULL.

Failing zswap's compressor update before zswap is initialized can later
trigger:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:strcmp+0x10/0x30
  Call Trace:
    zswap_setup+0x3b1/0x490
    zswap_enabled_param_set+0x5b/0xa0
    param_attr_store+0x93/0xe0
    module_attr_store+0x1c/0x30
    kernfs_fop_write_iter+0x116/0x1f0

Allocate and copy the replacement first, then replace the parameter value
only after allocation succeeds.

Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/params.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -261,6 +261,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax)
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
+	char *tmp;
 	size_t len, maxlen = 1024;
 
 	len = strnlen(val, maxlen + 1);
@@ -269,19 +270,20 @@ int param_set_charp(const char *val, con
 		return -ENOSPC;
 	}
 
-	maybe_kfree_parameter(*(char **)kp->arg);
-
 	/*
 	 * This is a hack. We can't kmalloc() in early boot, and we
 	 * don't need to; this mangled commandline is preserved.
 	 */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(len + 1);
-		if (!*(char **)kp->arg)
+		tmp = kmalloc_parameter(len + 1);
+		if (!tmp)
 			return -ENOMEM;
-		strcpy(*(char **)kp->arg, val);
+		memcpy(tmp, val, len + 1);
 	} else
-		*(const char **)kp->arg = val;
+		tmp = (char *)val;
+
+	maybe_kfree_parameter(*(char **)kp->arg);
+	*(char **)kp->arg = tmp;
 
 	return 0;
 }


