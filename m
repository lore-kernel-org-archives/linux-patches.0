Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BA127280A;
	Mon, 13 Apr 2026 16:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097164; cv=none; b=aeq0mCX78dG9qKyjWkJzmjN8J31opKrkDEyzCo1yoGFrarKCVhkPm2+f1JxGLD/C8AKRMofvLIGxBJFDEOakucI83i9FvGdpaFznSvt3gL9BkwOqN+pJu5wYaIzNGmofO2Hh20mLt5Uw5lQNXPELGFN+dfCDSTMli+Z/QfSrJBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097164; c=relaxed/simple;
	bh=C4bATp6N08xqHdwkFxpVaj+JGFyYMsm/jjGgeqhNYjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaqD4XdXoKuD8IFJkC+nVNPTInR9BmIZ9x50kxnfauUqsAbl3tQaVwbt9gTBIqndOFKCX7v1lj9vsxiPvinpg1X3UkMo9TWaqGcSXSjAjjY5gUTIPoyJZ1DBag9f9wMORDE2XQKhHT+wRve3Im9b9lMwE/q05S425TeXuOSSQUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cw4R9uYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cw4R9uYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD11C2BCAF;
	Mon, 13 Apr 2026 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097164;
	bh=C4bATp6N08xqHdwkFxpVaj+JGFyYMsm/jjGgeqhNYjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cw4R9uYhcskUACrOLHwCAlf9mQ2tnPYA756XehBH3E5yQOVkABe7b353lzy7KVO4/
	 1QmpAFEEg6pUMVdwXuGaMuDZJXwnX9lH0IJt2wSIApcVjdMb0g2BwdIi69icXRBQjS
	 ZWoGdffN7osQMaBREFDtGvD5b2P0zsqGVfXQy++A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Thomas Richard (TI)" <thomas.richard@bootlin.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/570] usb: cdns3: fix role switching during resume
Date: Mon, 13 Apr 2026 17:52:42 +0200
Message-ID: <20260413155831.589237742@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard (TI) <thomas.richard@bootlin.com>

[ Upstream commit 87e4b043b98a1d269be0b812f383881abee0ca45 ]

If the role change while we are suspended, the cdns3 driver switches to the
new mode during resume. However, switching to host mode in this context
causes a NULL pointer dereference.

The host role's start() operation registers a xhci-hcd device, but its
probe is deferred while we are in the resume path. The host role's resume()
operation assumes the xhci-hcd device is already probed, which is not the
case, leading to the dereference. Since the start() operation of the new
role is already called, the resume operation can be skipped.

So skip the resume operation for the new role if a role switch occurs
during resume. Once the resume sequence is complete, the xhci-hcd device
can be probed in case of host mode.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000208
Mem abort info:
...
Data abort info:
...
[0000000000000208] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 146 Comm: sh Not tainted
6.19.0-rc7-00013-g6e64f4aabfae-dirty #135 PREEMPT
Hardware name: Texas Instruments J7200 EVM (DT)
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : usb_hcd_is_primary_hcd+0x0/0x1c
lr : cdns_host_resume+0x24/0x5c
...
Call trace:
 usb_hcd_is_primary_hcd+0x0/0x1c (P)
 cdns_resume+0x6c/0xbc
 cdns3_controller_resume.isra.0+0xe8/0x17c
 cdns3_plat_resume+0x18/0x24
 platform_pm_resume+0x2c/0x68
 dpm_run_callback+0x90/0x248
 device_resume+0x100/0x24c
 dpm_resume+0x190/0x2ec
 dpm_resume_end+0x18/0x34
 suspend_devices_and_enter+0x2b0/0xa44
 pm_suspend+0x16c/0x5fc
 state_store+0x80/0xec
 kobj_attr_store+0x18/0x2c
 sysfs_kf_write+0x7c/0x94
 kernfs_fop_write_iter+0x130/0x1dc
 vfs_write+0x240/0x370
 ksys_write+0x70/0x108
 __arm64_sys_write+0x1c/0x28
 invoke_syscall+0x48/0x10c
 el0_svc_common.constprop.0+0x40/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x34/0x108
 el0t_64_sync_handler+0xa0/0xe4
 el0t_64_sync+0x198/0x19c
Code: 52800003 f9407ca5 d63f00a0 17ffffe4 (f9410401)
---[ end trace 0000000000000000 ]---

Cc: stable <stable@kernel.org>
Fixes: 2cf2581cd229 ("usb: cdns3: add power lost support for system resume")
Signed-off-by: Thomas Richard (TI) <thomas.richard@bootlin.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260130-usb-cdns3-fix-role-switching-during-resume-v1-1-44c456852b52@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 8e46fd36b0e56..93e93bb9a314f 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -550,7 +550,7 @@ int cdns_resume(struct cdns *cdns)
 		}
 	}
 
-	if (cdns->roles[cdns->role]->resume)
+	if (!role_changed && cdns->roles[cdns->role]->resume)
 		cdns->roles[cdns->role]->resume(cdns, power_lost);
 
 	return 0;
-- 
2.51.0



