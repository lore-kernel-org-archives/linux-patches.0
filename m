Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ECF4C74;
	Mon, 23 Jun 2025 22:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716134; cv=none; b=h7mt+xPehXEjySGcXZv8J4Vv+Bxj7v41TH666eNpuQxgtFU7x9oQ2OV7dxxnR/3A5/l6fpKyrKdPkHsaf1s9nD98NDnbpo10mfaPJzdmYHks/NSl2EoOsdbnd0F91AXbc/RAzcK0yWEylqklhJiaDhy1UGKN32virpGc3E/y1BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716134; c=relaxed/simple;
	bh=do4ri06HBTJ0T6Oxz+1MbQKZU6UfHx19nW+ntEiDeFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ug+2ce6qUvUWWRYNKHDk4QcbY6nlWkPfN/bba79J7OXv5Tkm2nUgts5rMuUcY2eig1W+qr39sxBuc/9rTzgEez1mEQ5q4mPqqoyU3LNsqdVFzgIAFRSYC46fSdODJHVMg7RGEB0N/4q7c0Zklb6zuB3JbtI9sNPmwkaHkMvDRM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWIHAkyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWIHAkyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E511C4CEEA;
	Mon, 23 Jun 2025 22:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716134;
	bh=do4ri06HBTJ0T6Oxz+1MbQKZU6UfHx19nW+ntEiDeFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWIHAkyixciQvcGSKw1hTqBlflKheCw8klDe4qyDsxi65fgieI1nFulYgKWSsJuls
	 Chn2oAjGUe8RYdAjAqwtFkpHpEiQQ9sD+41wFLzy07Q/ZbEa0dsTwqsR85PzpC+NWx
	 qx+23FI3xznhWZnK49TbU/7riYyITTq2oJo5fFDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Stefano Stabellini <stefano.stabellini@amd.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 282/508] xen/arm: call uaccess_ttbr0_enable for dm_op hypercall
Date: Mon, 23 Jun 2025 15:05:27 +0200
Message-ID: <20250623130652.199176413@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Stefano Stabellini <stefano.stabellini@amd.com>

commit 7f9bbc1140ff8796230bc2634055763e271fd692 upstream.

dm_op hypercalls might come from userspace and pass memory addresses as
parameters. The memory addresses typically correspond to buffers
allocated in userspace to hold extra hypercall parameters.

On ARM, when CONFIG_ARM64_SW_TTBR0_PAN is enabled, they might not be
accessible by Xen, as a result ioreq hypercalls might fail. See the
existing comment in arch/arm64/xen/hypercall.S regarding privcmd_call
for reference.

For privcmd_call, Linux calls uaccess_ttbr0_enable before issuing the
hypercall thanks to commit 9cf09d68b89a. We need to do the same for
dm_op. This resolves the problem.

Cc: stable@kernel.org
Fixes: 9cf09d68b89a ("arm64: xen: Enable user access before a privcmd hvc call")
Signed-off-by: Stefano Stabellini <stefano.stabellini@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <alpine.DEB.2.22.394.2505121446370.8380@ubuntu-linux-20-04-desktop>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/xen/hypercall.S |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/arch/arm64/xen/hypercall.S
+++ b/arch/arm64/xen/hypercall.S
@@ -83,7 +83,26 @@ HYPERCALL3(vcpu_op);
 HYPERCALL1(platform_op_raw);
 HYPERCALL2(multicall);
 HYPERCALL2(vm_assist);
-HYPERCALL3(dm_op);
+
+SYM_FUNC_START(HYPERVISOR_dm_op)
+	mov x16, #__HYPERVISOR_dm_op;	\
+	/*
+	 * dm_op hypercalls are issued by the userspace. The kernel needs to
+	 * enable access to TTBR0_EL1 as the hypervisor would issue stage 1
+	 * translations to user memory via AT instructions. Since AT
+	 * instructions are not affected by the PAN bit (ARMv8.1), we only
+	 * need the explicit uaccess_enable/disable if the TTBR0 PAN emulation
+	 * is enabled (it implies that hardware UAO and PAN disabled).
+	 */
+	uaccess_ttbr0_enable x6, x7, x8
+	hvc XEN_IMM
+
+	/*
+	 * Disable userspace access from kernel once the hyp call completed.
+	 */
+	uaccess_ttbr0_disable x6, x7
+	ret
+SYM_FUNC_END(HYPERVISOR_dm_op);
 
 SYM_FUNC_START(privcmd_call)
 	mov x16, x0


