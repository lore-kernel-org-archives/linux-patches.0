Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3918383BA;
	Mon,  1 Apr 2024 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987656; cv=none; b=OolP/EZx/67D54IiDmo3mrOWxS5Chx3isRde7Dyc5dG3+gIe5KC10xYyAk7Y+GRM5FXf7qcarrUcVkhvUjEqoOYh9E8mR+PuF4bRuovmVNO59M1x2xbXje63nzH/bjxkXmWSfdCxcToIIxxDpCmlUOIP4zuK0JiV53BvZloA3ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987656; c=relaxed/simple;
	bh=gnWWfq6FLeatSv1OaXltruKRIRyl8RSEh1Rzz1HbE5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAhStwbX1/PvROJ4x0ipotRsTqkFL12yFBweWzZX5oL2vomCYb4vTmbD77SWgx8moOxsizzkLmkmoNF/GMRxueWDUlLU6xlcf14pkU2KvSyGmUZYkaoqliG44lRlW330yndHK3/OTKhl9NY3eXTxTbSnYcRgwM8e8ifsrVZJgM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIcS7K4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIcS7K4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4267EC433C7;
	Mon,  1 Apr 2024 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987656;
	bh=gnWWfq6FLeatSv1OaXltruKRIRyl8RSEh1Rzz1HbE5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIcS7K4IVg98SEYc/WFhCYZ9my+sQQpKP3kvDb7nede5PnIdVogza29sDRGFvJQw4
	 lL/XqyAu8BRrkjlIamHGXGSxobgtne+IVx+567I9NA3Q9fRoGWUrIdYdRxlkz4GI3t
	 d/IR6b2aNVCVMWMNc/G8dFogIsUqKY+3E4ysNUns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.8 325/399] drm/vmwgfx: Create debugfs ttm_resource_manager entry only if needed
Date: Mon,  1 Apr 2024 17:44:51 +0200
Message-ID: <20240401152558.881562467@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jocelyn Falempe <jfalempe@redhat.com>

commit 4be9075fec0a639384ed19975634b662bfab938f upstream.

The driver creates /sys/kernel/debug/dri/0/mob_ttm even when the
corresponding ttm_resource_manager is not allocated.
This leads to a crash when trying to read from this file.

Add a check to create mob_ttm, system_mob_ttm, and gmr_ttm debug file
only when the corresponding ttm_resource_manager is allocated.

crash> bt
PID: 3133409  TASK: ffff8fe4834a5000  CPU: 3    COMMAND: "grep"
 #0 [ffffb954506b3b20] machine_kexec at ffffffffb2a6bec3
 #1 [ffffb954506b3b78] __crash_kexec at ffffffffb2bb598a
 #2 [ffffb954506b3c38] crash_kexec at ffffffffb2bb68c1
 #3 [ffffb954506b3c50] oops_end at ffffffffb2a2a9b1
 #4 [ffffb954506b3c70] no_context at ffffffffb2a7e913
 #5 [ffffb954506b3cc8] __bad_area_nosemaphore at ffffffffb2a7ec8c
 #6 [ffffb954506b3d10] do_page_fault at ffffffffb2a7f887
 #7 [ffffb954506b3d40] page_fault at ffffffffb360116e
    [exception RIP: ttm_resource_manager_debug+0x11]
    RIP: ffffffffc04afd11  RSP: ffffb954506b3df0  RFLAGS: 00010246
    RAX: ffff8fe41a6d1200  RBX: 0000000000000000  RCX: 0000000000000940
    RDX: 0000000000000000  RSI: ffffffffc04b4338  RDI: 0000000000000000
    RBP: ffffb954506b3e08   R8: ffff8fee3ffad000   R9: 0000000000000000
    R10: ffff8fe41a76a000  R11: 0000000000000001  R12: 00000000ffffffff
    R13: 0000000000000001  R14: ffff8fe5bb6f3900  R15: ffff8fe41a6d1200
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffffb954506b3e00] ttm_resource_manager_show at ffffffffc04afde7 [ttm]
 #9 [ffffb954506b3e30] seq_read at ffffffffb2d8f9f3
    RIP: 00007f4c4eda8985  RSP: 00007ffdbba9e9f8  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 000000000037e000  RCX: 00007f4c4eda8985
    RDX: 000000000037e000  RSI: 00007f4c41573000  RDI: 0000000000000003
    RBP: 000000000037e000   R8: 0000000000000000   R9: 000000000037fe30
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007f4c41573000
    R13: 0000000000000003  R14: 00007f4c41572010  R15: 0000000000000003
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b

Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: af4a25bbe5e7 ("drm/vmwgfx: Add debugfs entries for various ttm resource managers")
Cc: <stable@vger.kernel.org>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240312093551.196609-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1444,12 +1444,15 @@ static void vmw_debugfs_resource_manager
 					    root, "system_ttm");
 	ttm_resource_manager_create_debugfs(ttm_manager_type(&vmw->bdev, TTM_PL_VRAM),
 					    root, "vram_ttm");
-	ttm_resource_manager_create_debugfs(ttm_manager_type(&vmw->bdev, VMW_PL_GMR),
-					    root, "gmr_ttm");
-	ttm_resource_manager_create_debugfs(ttm_manager_type(&vmw->bdev, VMW_PL_MOB),
-					    root, "mob_ttm");
-	ttm_resource_manager_create_debugfs(ttm_manager_type(&vmw->bdev, VMW_PL_SYSTEM),
-					    root, "system_mob_ttm");
+	if (vmw->has_gmr)
+		ttm_resource_manager_create_debugfs(ttm_manager_type(&vmw->bdev, VMW_PL_GMR),
+						    root, "gmr_ttm");
+	if (vmw->has_mob) {
+		ttm_resource_manager_create_debugfs(ttm_manager_type(&vmw->bdev, VMW_PL_MOB),
+						    root, "mob_ttm");
+		ttm_resource_manager_create_debugfs(ttm_manager_type(&vmw->bdev, VMW_PL_SYSTEM),
+						    root, "system_mob_ttm");
+	}
 }
 
 static int vmwgfx_pm_notifier(struct notifier_block *nb, unsigned long val,


