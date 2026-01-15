Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1880C3AE701;
	Thu, 15 Jan 2026 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497896; cv=none; b=lCg2L0K2Mv55IaqoqMEjiPrQTjol7CWZAMqVuZBr30V8JnvbjwNkLRkKYQwN/w+Q0aRmdMyBkl1sCev6KWYIb/uMTyoJxgk4YZ5LQ3ILTJPqOrDb2xJT/YOaZhvBlAHeRMs6hClZP67Muhbghx6lesJdSNg43+aqT+dYn/EXUv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497896; c=relaxed/simple;
	bh=crNi+4DI9poXXVGWgiWBnEcM773+IO2Pf++6CkvDAH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAdgGzHmJuBtVxMgQNDSw5RFoN5r2kXGvpAuQ03K2aLmhQcaUaHfc+KVjKXsN8mehjeKdIx/dSJvXkWg9vxnclSahQvBO6WcxlHHy3aC9OSKx9HS6eGP4OgnRu8SbjqPapiKtUEfs3K9WJ6G+GYq0wDrjGBZIpDJeZl2xCgpbwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psoNnceZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psoNnceZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99754C116D0;
	Thu, 15 Jan 2026 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497896;
	bh=crNi+4DI9poXXVGWgiWBnEcM773+IO2Pf++6CkvDAH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psoNnceZKPc0Q6EW7gyv8TJawKySnc+LKihDzugsNSiGkm5AMQl1VWlTxzNo1w8qn
	 eBUf3itRvm/nJBjNVZuxSfRqaSmTV3dfKJ806uyi0r5SxhwNyUopk5sOaKBeV2acW9
	 WPc7PDtKkYAnaLaYZwX+U6Xev0/ui8HV+Y8FF6oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/554] bpf, arm64: Do not audit capability check in do_jit()
Date: Thu, 15 Jan 2026 17:44:34 +0100
Message-ID: <20260115164253.782235507@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 654e7ed2d1a64..e934ad5837d08 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -341,7 +341,7 @@ static void __maybe_unused build_bhb_mitigation(struct jit_ctx *ctx)
 	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
 		return;
 
-	if (capable(CAP_SYS_ADMIN))
+	if (ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
 		return;
 
 	if (supports_clearbhb(SCOPE_SYSTEM)) {
-- 
2.51.0



