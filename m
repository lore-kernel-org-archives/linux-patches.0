Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907F71E1A05;
	Mon, 23 Jun 2025 21:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714377; cv=none; b=G3dGDOGi5uWq4T8JPSljbzYG6mQWfHtBdG5NNmjVdYm4wNg6JMr22uAsZpITFjDQDMFUCaC9P86oLJKt9i3PVZkKb72DDdB491Xr985jck63HGI2dJEB/icjkAp+OEH/N4iEtpurf8jTq5BrwroPmyEPbR/aFg4Qb4Gq58y8J0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714377; c=relaxed/simple;
	bh=ERpaKlRmDsfnJRKu2fjrQwC4ZnhA3sLlJieP4IAlda0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scuLXRhMP9iservaggIxYPjIbA2OTSInPXVSigNzv8gMBeS4vD27CI8/HzT0LT7rG8o2Bgh8Euv4WU3UH3Il2ykgi7UJdqPM2aAyVYYtwR8BT2p3msKiFnEAS+F965Z7j/Yh4S0bM5EInI2/S+TyZh0JsEnYryoPyJry7iNoRvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzMrVkI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzMrVkI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29699C4CEEA;
	Mon, 23 Jun 2025 21:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714377;
	bh=ERpaKlRmDsfnJRKu2fjrQwC4ZnhA3sLlJieP4IAlda0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzMrVkI0TahnjVBaBtgxY8Z0h2Ag3UdG6UIlq4ifZ12WWkPs6sPGeFHEMJjfR6Bl1
	 YWQXFtmEsnQQs4JHdKjA0KNJ8OOgOaAQZqdzMJIX0as9ZI6A4W5as0L2Ol/4SQKeL1
	 BcUJMxFzutNGkx/RtGarGMUhwlcPf7jd9MpUeTgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Stefano Stabellini <stefano.stabellini@amd.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 184/411] xen/arm: call uaccess_ttbr0_enable for dm_op hypercall
Date: Mon, 23 Jun 2025 15:05:28 +0200
Message-ID: <20250623130638.314626262@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -84,7 +84,26 @@ HYPERCALL1(tmem_op);
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


