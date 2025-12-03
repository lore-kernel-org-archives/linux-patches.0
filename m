Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8537934888F;
	Wed,  3 Dec 2025 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778725; cv=none; b=G5dvOY0srusx1JbanGVMnQyrzjUXSrkywaRJH3bMXete3PXNk+K/1l4N0q/8cfDcIb3iSmShJm4RO448XFr+3PCiEdj9U3mV4eymIrevH9pPw6lO1txFkWvDFPTSyPJxNyPOiOzbrs4AIL/x+86xyC20VjkfOiqjgGfibjSSn4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778725; c=relaxed/simple;
	bh=BAuHPzXYPH5+rp7PNJWiV4dUpmQcnZ03S2kghAxng6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iakVQNuTLF7H76ySb0pq8BUrD8fIQhcIpDqP4ScN8QLXriH/79SXjl1U/6/So2ohflg9T2Bs5OJevOC1QnRhorapmvipAAyjsoentGo474ZqyNJZZx5TG1R0juuHKRlYL+OS1pmiMFU4LbFHHLvkcVv9ca4f7xzev4HUdStSuUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXOS3gHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXOS3gHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849DAC4CEF5;
	Wed,  3 Dec 2025 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778725;
	bh=BAuHPzXYPH5+rp7PNJWiV4dUpmQcnZ03S2kghAxng6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXOS3gHOz+5UO2NivsohAGr6WIxolqElCbQQwSMki7II1xVvI1deVmto5lf+FhAIR
	 zHhLFNGG9o/Spz8is3V7hif9e/BvwQWDP+3kAQGxkz7abrGWJLFA/8OHKBSH7mqi8J
	 OhialtygmG7UGA7PsYClWeOZse1ja/LUkUVFo0n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/568] bpf: Do not audit capability check in do_jit()
Date: Wed,  3 Dec 2025 16:20:43 +0100
Message-ID: <20251203152442.195622641@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3068bb53c4db..095fec941bb73 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1809,7 +1809,7 @@ st:			if (is_imm8(insn->off))
 			ctx->cleanup_addr = proglen;
 
 			if (bpf_prog_was_classic(bpf_prog) &&
-			    !capable(CAP_SYS_ADMIN)) {
+			    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN)) {
 				u8 *ip = image + addrs[i - 1];
 
 				if (emit_spectre_bhb_barrier(&prog, ip, bpf_prog))
-- 
2.51.0



