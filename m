Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777563D953B;
	Sat, 12 Sep 2026 07:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197447; cv=none; b=gF0qMbc3vARzNzxgXGORfd8nmUON6NYpuZhwCcQs9rkGLd5g29W/Qg607BQnm/N3D2i+q7cMz7ZRfHMNVoOJRa/GF4t1XSTJ2+D/IaLQuWmD32/rXVqpTW6M2kc/OFn6GoKWiFLvVsZSJrBOqkE1CWrkkccreD9uvl6zsi9vKlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197447; c=relaxed/simple;
	bh=yK0jnBnN8u5T5FoHdadykU+/g2ml2IfUS3WDqW1Mmhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evDOfWKvaRDfZ5c+ucGa/7wxVhbLjUp3tBQeyse8AfDq2Yd/MDjpfFrH3OkQWcI2/RYxw4Q4QvVMEV8++UNp0m/baOqmneDOYHw+J2i9sOilHt2JrhP2x4quPPwp1KHKjtAyZvkhFeRtHoIz3DDYvH0yaNuaSKwG5hTv5kBpGEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcBydMel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcBydMel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B931F000FF;
	Sat, 12 Sep 2026 07:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197446;
	bh=kACzvq4/h1h+/PWBZrjx7JX2Ea+fxQQvrOE6Z3VdyYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcBydMelHRcGWwaWRTzY2zPYM8iEEJRLV92D56ct6zdzMoGIGRkfSOqFsa7M5e5ea
	 1jLZ0RthWzVVNkaeh3wPE68aNCBVRpxEkGaSI9N0u5SlAIshrXuCSCjuqVX4cwEyum
	 fBXfO5NN3pO9DIpAnmJ0WUO6KsBrxiDtZZlVSPqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0174/1815] uprobes/x86: Do not leak trampoline vma mapping on optimization failure
Date: Sat, 12 Sep 2026 08:32:04 +0200
Message-ID: <20260912065653.092859341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 07c308eb2bcfe4727ba669e1ba6f5b0ba7d2696e ]

In case the optimization fails, we leak new-ly created trampoline
vma mapping (in case we just created it), let's unmap it.

Fixes: ba2bfc97b462 ("uprobes/x86: Add support to optimize uprobes")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20260703114917.238144-4-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/uprobes.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index a76203a33a7b0..7f820560e6f83 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -677,11 +677,14 @@ static unsigned long find_nearest_trampoline(unsigned long vaddr)
 	return high_tramp;
 }
 
-static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsigned long vaddr)
+static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsigned long vaddr,
+						    bool *new_mapping)
 {
 	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma;
 
+	*new_mapping = false;
+
 	if (vaddr > TASK_SIZE || vaddr < PAGE_SIZE)
 		return ERR_PTR(-EINVAL);
 
@@ -696,6 +699,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
 	if (IS_ERR_VALUE(vaddr))
 		return ERR_PTR(vaddr);
 
+	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
 				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_DONTCOPY|VM_IO,
 				&tramp_mapping);
@@ -1053,6 +1057,7 @@ static int __arch_uprobe_optimize(struct arch_uprobe *auprobe, struct mm_struct
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	struct vm_area_struct *vma, *tramp;
+	bool new_mapping;
 	int ret;
 
 	if (!user_64bit_mode(regs))
@@ -1060,10 +1065,13 @@ static int __arch_uprobe_optimize(struct arch_uprobe *auprobe, struct mm_struct
 	vma = find_vma(mm, vaddr);
 	if (!vma)
 		return -EINVAL;
-	tramp = get_uprobe_trampoline(mm, vaddr);
+	tramp = get_uprobe_trampoline(mm, vaddr, &new_mapping);
 	if (IS_ERR(tramp))
 		return PTR_ERR(tramp);
-	return WARN_ON_ONCE(swbp_optimize(auprobe, vma, vaddr, tramp->vm_start));
+	ret = swbp_optimize(auprobe, vma, vaddr, tramp->vm_start);
+	if (WARN_ON_ONCE(ret) && new_mapping)
+		WARN_ON_ONCE(do_munmap(mm, tramp->vm_start, PAGE_SIZE, NULL));
+	return ret;
 }
 
 void arch_uprobe_optimize(struct arch_uprobe *auprobe, unsigned long vaddr)
-- 
2.53.0



