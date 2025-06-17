Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100402EA72C;
	Tue, 17 Jun 2025 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178465; cv=none; b=g4FcZtl/IL0Xnu5LywaE+7gJH05UFchwbut7MH/U3PNHeWSrK58XJa11f24mXaTcATcrij95zIQ8jk2a2zNbqN36z3krjCCrjVnU7TqbAyhgabKdVwVV8khbu0nHTYpMDqpn62Vwkix7k/fkgFDbSsK3RMci0zEqlw6nFn4tMaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178465; c=relaxed/simple;
	bh=awFXpan8vcccc+tshElBr8CYJlKZCndFVlK6S+oLVks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIqik9NBuNsZWJOVH81v4noV3ANcQ8u9ZzClFbg+nQdgGGAvIu+PDPCqUncrL9AvU7/7Q9OYABX8ZVH1ned1JHOchT0H29P/3BPBtZOtS95ybjxFo9eTo0HourYmZyGwHm2hLeK1G9cP4rsuDKQJmfZVDjFM2rxrDQn3NoYd2/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+byQ53z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+byQ53z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FE6C4CEE3;
	Tue, 17 Jun 2025 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178464;
	bh=awFXpan8vcccc+tshElBr8CYJlKZCndFVlK6S+oLVks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+byQ53z8F6fM6TQKkB/9gb2RAz2Bu/yZY7SVvJul+v5whnahtctJnT3cHZLxvhLE
	 aV0abP927cE3wWWzd81RLmxCD8nWTJfDoplh9kC3vM2UIk6Q7UhLkuuc0c5WJp6cf6
	 tgBUOl76wYaerEuEUeXCN5ZD/o0FZ0NyEgaHVgwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Stefano Stabellini <stefano.stabellini@amd.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 503/512] xen/arm: call uaccess_ttbr0_enable for dm_op hypercall
Date: Tue, 17 Jun 2025 17:27:49 +0200
Message-ID: <20250617152440.004782545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


