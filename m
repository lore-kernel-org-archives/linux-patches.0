Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15D524113D;
	Tue, 11 Nov 2025 00:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822360; cv=none; b=lz3ZEm0ex37ZFzd4KiPxebGLpGRCIHnoGLQphOuR+pGG6WIvsrwE6aDPMxoNU1Jq09KAfSp2VjgwHnpZS+20NTvvQ1RsDuffyOOKUfg9SOd3pqllN9OAv5QRt15Wk9OQj9DnebNExvE70Z/OCrwA0WIlNvaC0Iqh4yHyP2LXJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822360; c=relaxed/simple;
	bh=D44oObjobkoBdE6Y9Hr72kGXTViRPQZzwlV3mq+s7yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRiTrAHOSdbGozKLtuVeMVEs9O+zIhF7cMJbGSQpNb/mZrhTuJ1D4Hl3iyzvf3qLKhl6zxxmEmDMm8/aIh0VQa0xeIXzni8sUYAn9cPTaIDApH+cXDERvDNQeIuVm3sXeSs+m86a3dRHseN5JmkizflhxWf7dTw4rQjh1TTUI/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQcCw+ZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQcCw+ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CFFC19425;
	Tue, 11 Nov 2025 00:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822360;
	bh=D44oObjobkoBdE6Y9Hr72kGXTViRPQZzwlV3mq+s7yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQcCw+ZHY2OR1Q/IaW0AA4OSvibwTh7CAH6QSvBw6L3ang7cf7zN8kc1SRvJvSQXd
	 DcS6VDrySOCTZPYSmxF1/8wIs9vhPUH0CDqVnYJ4V4AzNrkAAy8i8Ef6sbhYuJlWE+
	 sAwbSGX2dkE6/ENx3IXvaM+TPhctDnC1sFxZZfK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/565] bpf: Do not audit capability check in do_jit()
Date: Tue, 11 Nov 2025 09:38:10 +0900
Message-ID: <20251111004527.652267814@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 881a9c9cb7856b24e390fad9f59acfd73b98b3b2 ]

The failure of this check only results in a security mitigation being
applied, slightly affecting performance of the compiled BPF program. It
doesn't result in a failed syscall, an thus auditing a failed LSM
permission check for it is unwanted. For example with SELinux, it causes
a denial to be reported for confined processes running as root, which
tends to be flagged as a problem to be fixed in the policy. Yet
dontauditing or allowing CAP_SYS_ADMIN to the domain may not be
desirable, as it would allow/silence also other checks - either going
against the principle of least privilege or making debugging potentially
harder.

Fix it by changing it from capable() to ns_capable_noaudit(), which
instructs the LSMs to not audit the resulting denials.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2369326
Fixes: d4e89d212d40 ("x86/bpf: Call branch history clearing sequence on exit")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20251021122758.2659513-1-omosnace@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 9a861ac77f8eb..8cbc26081bdb2 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2453,7 +2453,7 @@ st:			if (is_imm8(insn->off))
 			/* Update cleanup_addr */
 			ctx->cleanup_addr = proglen;
 			if (bpf_prog_was_classic(bpf_prog) &&
-			    !capable(CAP_SYS_ADMIN)) {
+			    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN)) {
 				u8 *ip = image + addrs[i - 1];
 
 				if (emit_spectre_bhb_barrier(&prog, ip, bpf_prog))
-- 
2.51.0



