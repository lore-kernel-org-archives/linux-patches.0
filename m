Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F008612EBEA;
	Tue, 25 Jun 2024 09:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308666; cv=none; b=Nzwc8e9M6m84WpRBvyBw4VkivMhZ2k20CNVgo6GJZMrVAvwBUn19B2VVpVU+rzLk2S81v586Dsshnt0eVO9JDkIcy7PKt0y4QqtruLiFxklLkWZ13Qzj840i2A4z7GYqOhQ4QMEBfrjNjzxDDn5WZlWhUgd0xaGLB8pFHKop3TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308666; c=relaxed/simple;
	bh=e0jZi+8BaNQf0DokQV/TWYhWdKAjOMHMY/0XItVHtYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3xzePczfPlJf8tC1XWLZMx7SzEgw05JwhDjiGnEtfLfyy4WQt+HkWVLgmIfWYjvGF+v9sRob1B2CB+vlCYyHF7QQF6F4bpa1t4gS0NhNkdI5sWocxKR5uMNF/I+L7aIz+11xGmzpc/pDnJVox8LnM8nmUVDwflFgoPdQjYz61k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thycQagQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thycQagQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CAFC32781;
	Tue, 25 Jun 2024 09:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308665;
	bh=e0jZi+8BaNQf0DokQV/TWYhWdKAjOMHMY/0XItVHtYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thycQagQP/dC0sIjhhi+74vwc/pINi9nP11adPEtLRhiAyj2l4L0OcGykNk1q+ZdO
	 U3TMwNrFyks4mWzZola2auiAnr/5hjn91a9MO9DQ0ZfxcIXGRqeVMjqLsxsUy5DD6d
	 P5Lp9ILgXZzfaR+NtuFjfFuFq4HYCUTf4S6kkMKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Martin <Dave.Martin@arm.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 168/250] x86/resctrl: Dont try to free nonexistent RMIDs
Date: Tue, 25 Jun 2024 11:32:06 +0200
Message-ID: <20240625085554.503817430@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Martin <Dave.Martin@arm.com>

[ Upstream commit 739c9765793e5794578a64aab293c58607f1826a ]

Commit

  6791e0ea3071 ("x86/resctrl: Access per-rmid structures by index")

adds logic to map individual monitoring groups into a global index space used
for tracking allocated RMIDs.

Attempts to free the default RMID are ignored in free_rmid(), and this works
fine on x86.

With arm64 MPAM, there is a latent bug here however: on platforms with no
monitors exposed through resctrl, each control group still gets a different
monitoring group ID as seen by the hardware, since the CLOSID always forms part
of the monitoring group ID.

This means that when removing a control group, the code may try to free this
group's default monitoring group RMID for real.  If there are no monitors
however, the RMID tracking table rmid_ptrs[] would be a waste of memory and is
never allocated, leading to a splat when free_rmid() tries to dereference the
table.

One option would be to treat RMID 0 as special for every CLOSID, but this would
be ugly since bookkeeping still needs to be done for these monitoring group IDs
when there are monitors present in the hardware.

Instead, add a gating check of resctrl_arch_mon_capable() in free_rmid(), and
just do nothing if the hardware doesn't have monitors.

This fix mirrors the gating checks already present in
mkdir_rdt_prepare_rmid_alloc() and elsewhere.

No functional change on x86.

  [ bp: Massage commit message. ]

Fixes: 6791e0ea3071 ("x86/resctrl: Access per-rmid structures by index")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/r/20240618140152.83154-1-Dave.Martin@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c34a35ec0f031..2ce5f4913c820 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -508,7 +508,8 @@ void free_rmid(u32 closid, u32 rmid)
 	 * allows architectures that ignore the closid parameter to avoid an
 	 * unnecessary check.
 	 */
-	if (idx == resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
+	if (!resctrl_arch_mon_capable() ||
+	    idx == resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
 						RESCTRL_RESERVED_RMID))
 		return;
 
-- 
2.43.0



