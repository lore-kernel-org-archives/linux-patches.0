Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE4933B6C1;
	Wed,  3 Dec 2025 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777383; cv=none; b=HDO/TFPSV6EN0jgmpq+UbcypvXC7q/UWefGsHrLC87zLAO+Y+6Y0Nvh5o0/PjL12/Iq3I+BUcBMEWD25V8mWTCngDVaV8kAt+eFkUICJdoY5HP83UAIsMUmm3M9hX4wQYy957GLFeyfBpUGCJ9Hm7R5zItHVj3Ktz/kkvgMAcgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777383; c=relaxed/simple;
	bh=c8HL1BQfsJc2uKBj2D7Aw9qEB9LSnXGD7340SD4wGXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndcT6KUvlahFcffKJ49fZVK/PXxPktmSwBfMs7Q7myPRaTB9f60954Sa+EJlcJVDuT+f9aXe4JezJmlfXT/bLpKlTl98HN9PhPMp5bqEGg9ifb9UaTxlNgNVHP+lZJi0l0CDFgTZn0abtBA9JsI8ZCIbs5vrw4sB3OC5iyOu39A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRJona2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRJona2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AC5C4CEF5;
	Wed,  3 Dec 2025 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777382;
	bh=c8HL1BQfsJc2uKBj2D7Aw9qEB9LSnXGD7340SD4wGXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRJona2WWr9157QtcCTxUwKjbTGO656PxNd1xCKkLX2AL/u2x0BkeppYkDl38P6cZ
	 6vUu8hzUn55ez78RSJMoiCKOlLbj497KhI2yq4jpRT+enygF2Em/hy1lAbkzwNtDNP
	 ro7rxRnty71mDF6y8ot/7BcOYAJJJc5zix1ugiE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/392] bpf: Do not audit capability check in do_jit()
Date: Wed,  3 Dec 2025 16:22:50 +0100
Message-ID: <20251203152414.846513051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index 37a005df0b952..4100eed372486 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1786,7 +1786,7 @@ st:			if (is_imm8(insn->off))
 			ctx->cleanup_addr = proglen;
 
 			if (bpf_prog_was_classic(bpf_prog) &&
-			    !capable(CAP_SYS_ADMIN)) {
+			    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN)) {
 				u8 *ip = image + addrs[i - 1];
 
 				if (emit_spectre_bhb_barrier(&prog, ip, bpf_prog))
-- 
2.51.0



