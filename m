Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC08336EDA;
	Fri,  9 Jan 2026 12:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962044; cv=none; b=SFd3rOZrXBJJ8Y1xjf4V8G5o4Ljg0IttTWpXhy0JbHmcGL6LFMc24zhLH3p+VcVts29y9pkBQc3lGeCNaTLGJeyADaFF/XUqFyv8/vyk8VNbEwUvXrGYyu7bjeDXLsFVS9Foi5YegWhqXHwfEDnRY4gWgoZ0XZtBS9bbfl6GrYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962044; c=relaxed/simple;
	bh=p9POYlynfmVFn+n1lQ4wkJC+FlDd5bQVQD7/d4znnn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljH1xDaL2wHoc0gzSw8NUtDfIFhMqTDNmMebRO/MEmBdjiW4ym9pm/yB8hAh8Qtqp51LdE3NtmVihqoG+bETKN70Wjcwl8WwJkYoJwK2NfWhYoaBY/MabD4nnGZ6PGS64dk/clnrWrfophHzOxR+6zcZTNqTONP1jgQv2bodb8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PO9Dy0z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PO9Dy0z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2BEC4CEF1;
	Fri,  9 Jan 2026 12:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962043;
	bh=p9POYlynfmVFn+n1lQ4wkJC+FlDd5bQVQD7/d4znnn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PO9Dy0z+Pb0+cEqjFcgE9Wlmv4xR2h5eGkU0/5pcFNJwZbGmA48PXEBy8LBzg3Rx/
	 8qwsVwcbACRo/7abQ0ciNvEeI4cbjcP92CMJhKiteAkL11iprQeh+S4q2/oAGu2nMH
	 ca7nmfM7gH/Y2Myq3rXe120bGfliHlJn0ziEIl1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/634] bpf, arm64: Do not audit capability check in do_jit()
Date: Fri,  9 Jan 2026 12:38:24 +0100
Message-ID: <20260109112125.935365439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

[ Upstream commit 189e5deb944a6f9c7992355d60bffd8ec2e54a9c ]

Analogically to the x86 commit 881a9c9cb785 ("bpf: Do not audit
capability check in do_jit()"), change the capable() call to
ns_capable_noaudit() in order to avoid spurious SELinux denials in audit
log.

The commit log from that commit applies here as well:
"""
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
"""

Fixes: f300769ead03 ("arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Link: https://lore.kernel.org/r/20251204125916.441021-1-omosnace@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 3dd23050a6c89..783883721aaf5 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -666,7 +666,7 @@ static void __maybe_unused build_bhb_mitigation(struct jit_ctx *ctx)
 	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
 		return;
 
-	if (capable(CAP_SYS_ADMIN))
+	if (ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
 		return;
 
 	if (supports_clearbhb(SCOPE_SYSTEM)) {
-- 
2.51.0



