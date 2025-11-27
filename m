Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316CE28D830;
	Thu, 27 Nov 2025 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255430; cv=none; b=c0rFitwokhye7TUHyi7vnWU4/NncqEM0PwCJFF9wtrMUOQvAuYF9ptjKAcKHjjMYQ7X60nNpMM4epfcgG5kEGDUaqcTm3WDAc+oS5OHMeX7jS6MK1fmDetl8uyhYzOVsx1paldhvMXwxcsad4Fxr+mykQtV04HwTlB1PHSvHKyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255430; c=relaxed/simple;
	bh=tPkKX9z1cq2AQEg1ReKGd/zF7x9NDu1z43zAFlIEM34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhBTjpqte6ZkL+rifUTKMSjqT1lFpRlxMxIXPuO8XxZjgAiSP3SHstHsWTisJ6Ux6R0XctUwUrSWnj2bcfOZXDWzOOqYBQsCRNWVzPrSXxpVt1LXIDZMCjLmcJ5gBOb1yuYPvXHavlkcHOMyylvxLVGJk8rHuLMxqW/mRYfPve4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byqvTWi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byqvTWi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29FDC4CEF8;
	Thu, 27 Nov 2025 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255430;
	bh=tPkKX9z1cq2AQEg1ReKGd/zF7x9NDu1z43zAFlIEM34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byqvTWi+F8C4C5BlUfP7Jbr6AiaKIrYS/I1/BUUCpT54jkXRw1+5HXjBwMsi4+pCv
	 UsSHmVJpjyEsgiTtG9WT4zrxTzKIhm0lOeFu+SDZGl6YsnzI37cPx98Ep9DdnAZtNt
	 CfkGSAxH5uuLQjZaAuCbk4mSGr5/BGWFaVwuMhEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koen Koning <koen.koning@intel.com>,
	Peter Senna Tschudin <peter.senna@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/112] drm/xe: Prevent BIT() overflow when handling invalid prefetch region
Date: Thu, 27 Nov 2025 15:46:38 +0100
Message-ID: <20251127144036.354973519@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit d52dea485cd3c98cfeeb474cf66cf95df2ab142f ]

If user provides a large value (such as 0x80) for parameter
prefetch_mem_region_instance in vm_bind ioctl, it will cause
BIT(prefetch_region) overflow as below:
"
 ------------[ cut here ]------------
 UBSAN: shift-out-of-bounds in drivers/gpu/drm/xe/xe_vm.c:3414:7
 shift exponent 128 is too large for 64-bit type 'long unsigned int'
 CPU: 8 UID: 0 PID: 53120 Comm: xe_exec_system_ Tainted: G        W           6.18.0-rc1-lgci-xe-kernel+ #200 PREEMPT(voluntary)
 Tainted: [W]=WARN
 Hardware name: ASUS System Product Name/PRIME Z790-P WIFI, BIOS 0812 02/24/2023
 Call Trace:
  <TASK>
  dump_stack_lvl+0xa0/0xc0
  dump_stack+0x10/0x20
  ubsan_epilogue+0x9/0x40
  __ubsan_handle_shift_out_of_bounds+0x10e/0x170
  ? mutex_unlock+0x12/0x20
  xe_vm_bind_ioctl.cold+0x20/0x3c [xe]
 ...
"
Fix it by validating prefetch_region before the BIT() usage.

v2: Add Closes and Cc stable kernels. (Matt)

Reported-by: Koen Koning <koen.koning@intel.com>
Reported-by: Peter Senna Tschudin <peter.senna@linux.intel.com>
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6478
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20251112181005.2120521-2-shuicheng.lin@intel.com
(cherry picked from commit 8f565bdd14eec5611cc041dba4650e42ccdf71d9)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit d52dea485cd3c98cfeeb474cf66cf95df2ab142f)
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index fc5f0e1351932..30625ce691fa2 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -2903,8 +2903,8 @@ static int vm_bind_ioctl_check_args(struct xe_device *xe,
 				 op == DRM_XE_VM_BIND_OP_PREFETCH) ||
 		    XE_IOCTL_DBG(xe, prefetch_region &&
 				 op != DRM_XE_VM_BIND_OP_PREFETCH) ||
-		    XE_IOCTL_DBG(xe, !(BIT(prefetch_region) &
-				       xe->info.mem_region_mask)) ||
+		    XE_IOCTL_DBG(xe, prefetch_region >= (sizeof(xe->info.mem_region_mask) * 8) ||
+				 !(BIT(prefetch_region) & xe->info.mem_region_mask)) ||
 		    XE_IOCTL_DBG(xe, obj &&
 				 op == DRM_XE_VM_BIND_OP_UNMAP)) {
 			err = -EINVAL;
-- 
2.51.0



