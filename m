Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4362C3AF665;
	Sat, 17 Oct 2026 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256090; cv=none; b=a7PRlOgCVqABmNz+61ewXC/X/y2mERiJeB1LUK9t14VZIhgb3iWNPLCYecj4n7ANflPdt6uU25Zk5rUpEWyttf4GW0KdissGcKIOn7o28LEfFXYNx4m0Kq53p76yg71pyjA5/j00d1NRDdJ9gk4S4nQQG+nbakpfv2EWUZK9Akk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256090; c=relaxed/simple;
	bh=+f6urvfCCkL80JRHvhijd4Biq1QU7VMBVa9MHNMIHpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2bHevZVJcBgmElgL1UWiTN/THyYtfEze+Yos9BXZi10B/nkwexmQxVzIHfsnDhtyo6GDuZ0b985kWIyq1WTK/ttvNQZ5qTOun6VyasJbT7PXokzGTfIrMVg7qVVWCgA7CYyYC5MiY4fDyB9ROCi2FbN9GX3YpqkTmliZmdNEW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fttjO9Ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fttjO9Ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977BD1F000C4;
	Sat, 17 Oct 2026 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256089;
	bh=ZiHBXFxiZp28c1CWdfOKFBH5p3Kv35JMr8teH9wFoI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fttjO9Ai6PT9fWR/BCED8i4tX9KtgOOjZ87vU0SG3KrlSkqlnViN5/OlY162Pkqer
	 MDazkUtsxEAG0NCJvhCeuQjNwMHrh2U99fPGZa0e3jJWoPecepglT1ehohiPW5lgDv
	 gkupkp3nvOfjjoVy9/0g8kTFTgVmPUkWB1CnJZ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0068/1674] params: fix charp corruption on allocation failure
Date: Sat, 17 Oct 2026 17:39:00 +0200
Message-ID: <20261017160432.881180962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Yu <yujiacheng3@huawei.com>

[ Upstream commit 3dfaae04243cde460d82dfc2a7dd0bb6664d20ae ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index f6d11831749be..12fb187ebf63e 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -265,6 +265,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
+	char *tmp;
 	size_t len, maxlen = 1024;
 
 	len = strnlen(val, maxlen + 1);
@@ -273,19 +274,20 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
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
-- 
2.53.0



