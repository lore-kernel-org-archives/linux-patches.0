Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582041D0DED;
	Wed,  2 Oct 2024 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876580; cv=none; b=XORnWvWFmijo9vOm+xn4kEmXx4acw1J9hRTTvjvveL1aJ8TTR8JS8zqWuh8f3Gb6h9w6eNV6UJKeMSvaJBpexOum+c3+Rjq2PPTTm6vll1EjWDB29/+bltpUAruCgZHlMvMO6VXCLkSl713JOjjbjFJtOyTQZU8aoTKV4sJpAaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876580; c=relaxed/simple;
	bh=RR/zmt3Tt5rtBhdPsxAo3mEZohxF2vIly0h5JgJRbQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/mY5MX80H2QY7yE9j80F21dUVuyDC++0SECNMhtDYgvRnfa2t6epRdyI/xauLtTwfkTbLeu0+u5Y4Wjc7ivePNw/Ccy2YS1A8wJKbzjcMCwi1v/ChQt7kF+GE7WelMko/WlDvUDAq7qAbILn68szTdTtSfVeSQTC6oeJPpIMx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4m77F3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4m77F3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C11C4CEC5;
	Wed,  2 Oct 2024 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876580;
	bh=RR/zmt3Tt5rtBhdPsxAo3mEZohxF2vIly0h5JgJRbQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4m77F3/bIsMqQOTPVV7lRqb3jJE4A8bYDnJXb+1Bnb5wG162k66Zp8Ei5gjuOSzg
	 xxZlH+WnndcXw4fa5uqyeiLhuKaCnKwV7TKN8ozqKqKSEJ6B89qcg/IWBGC0AFfH+1
	 DpzvLjf/0qLSU/dMf24ibaWX2U4rc0is/5iLkBms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 461/695] driver core: Fix a potential null-ptr-deref in module_add_driver()
Date: Wed,  2 Oct 2024 14:57:39 +0200
Message-ID: <20241002125840.858694957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 18ec12c97b39ff6aa15beb8d2b25d15cd44b87d8 ]

Inject fault while probing of-fpga-region, if kasprintf() fails in
module_add_driver(), the second sysfs_remove_link() in exit path will cause
null-ptr-deref as below because kernfs_name_hash() will call strlen() with
NULL driver_name.

Fix it by releasing resources based on the exit path sequence.

	 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
	 Mem abort info:
	   ESR = 0x0000000096000005
	   EC = 0x25: DABT (current EL), IL = 32 bits
	   SET = 0, FnV = 0
	   EA = 0, S1PTW = 0
	   FSC = 0x05: level 1 translation fault
	 Data abort info:
	   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
	   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
	   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
	 [dfffffc000000000] address between user and kernel address ranges
	 Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
	 Dumping ftrace buffer:
	    (ftrace buffer empty)
	 Modules linked in: of_fpga_region(+) fpga_region fpga_bridge cfg80211 rfkill 8021q garp mrp stp llc ipv6 [last unloaded: of_fpga_region]
	 CPU: 2 UID: 0 PID: 2036 Comm: modprobe Not tainted 6.11.0-rc2-g6a0e38264012 #295
	 Hardware name: linux,dummy-virt (DT)
	 pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
	 pc : strlen+0x24/0xb0
	 lr : kernfs_name_hash+0x1c/0xc4
	 sp : ffffffc081f97380
	 x29: ffffffc081f97380 x28: ffffffc081f97b90 x27: ffffff80c821c2a0
	 x26: ffffffedac0be418 x25: 0000000000000000 x24: ffffff80c09d2000
	 x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
	 x20: 0000000000000000 x19: 0000000000000000 x18: 0000000000001840
	 x17: 0000000000000000 x16: 0000000000000000 x15: 1ffffff8103f2e42
	 x14: 00000000f1f1f1f1 x13: 0000000000000004 x12: ffffffb01812d61d
	 x11: 1ffffff01812d61c x10: ffffffb01812d61c x9 : dfffffc000000000
	 x8 : 0000004fe7ed29e4 x7 : ffffff80c096b0e7 x6 : 0000000000000001
	 x5 : ffffff80c096b0e0 x4 : 1ffffffdb990efa2 x3 : 0000000000000000
	 x2 : 0000000000000000 x1 : dfffffc000000000 x0 : 0000000000000000
	 Call trace:
	  strlen+0x24/0xb0
	  kernfs_name_hash+0x1c/0xc4
	  kernfs_find_ns+0x118/0x2e8
	  kernfs_remove_by_name_ns+0x80/0x100
	  sysfs_remove_link+0x74/0xa8
	  module_add_driver+0x278/0x394
	  bus_add_driver+0x1f0/0x43c
	  driver_register+0xf4/0x3c0
	  __platform_driver_register+0x60/0x88
	  of_fpga_region_init+0x20/0x1000 [of_fpga_region]
	  do_one_initcall+0x110/0x788
	  do_init_module+0x1dc/0x5c8
	  load_module+0x3c38/0x4cac
	  init_module_from_file+0xd4/0x128
	  idempotent_init_module+0x2cc/0x528
	  __arm64_sys_finit_module+0xac/0x100
	  invoke_syscall+0x6c/0x258
	  el0_svc_common.constprop.0+0x160/0x22c
	  do_el0_svc+0x44/0x5c
	  el0_svc+0x48/0xb8
	  el0t_64_sync_handler+0x13c/0x158
	  el0t_64_sync+0x190/0x194
	 Code: f2fbffe1 a90157f4 12000802 aa0003f5 (38e16861)
	 ---[ end trace 0000000000000000 ]---
	 Kernel panic - not syncing: Oops: Fatal exception

Fixes: 85d2b0aa1703 ("module: don't ignore sysfs_create_link() failures")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240812080658.2791982-1-ruanjinjie@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/module.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/base/module.c b/drivers/base/module.c
index f742ad2a21da0..c4eaa1158d54e 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -66,27 +66,31 @@ int module_add_driver(struct module *mod, const struct device_driver *drv)
 	driver_name = make_driver_name(drv);
 	if (!driver_name) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_remove_kobj;
 	}
 
 	module_create_drivers_dir(mk);
 	if (!mk->drivers_dir) {
 		ret = -EINVAL;
-		goto out;
+		goto out_free_driver_name;
 	}
 
 	ret = sysfs_create_link(mk->drivers_dir, &drv->p->kobj, driver_name);
 	if (ret)
-		goto out;
+		goto out_remove_drivers_dir;
 
 	kfree(driver_name);
 
 	return 0;
-out:
-	sysfs_remove_link(&drv->p->kobj, "module");
+
+out_remove_drivers_dir:
 	sysfs_remove_link(mk->drivers_dir, driver_name);
+
+out_free_driver_name:
 	kfree(driver_name);
 
+out_remove_kobj:
+	sysfs_remove_link(&drv->p->kobj, "module");
 	return ret;
 }
 
-- 
2.43.0



