Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C5235293F;
	Wed,  3 Dec 2025 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778579; cv=none; b=i7/5Nh6eFMAE/D6OtKqt2QAKz0dSYRyXZrCbyfOg/AeF3KiL65r20+C7fSAN/hsQvvB+9Ym1cs/N6VeIQLqe+LJJIaNjDOEKx+a2XQSRSS4V2Qn7sfd6gJJXobkb1EmQvi308xglraHz8wFeclLZSLgfy3ehcIAYaQQCQlZ8Pv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778579; c=relaxed/simple;
	bh=9jLDUhb01PVWj2MMAUcS889hNZtwd2lfYEOlopBIQaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHe15sK0ABqqLTXgniV7IoSutfRrGaKSSayUvU218el3PbB9TK+ELvyiwEPWgrz61rIEu9FvXaLUhKFO3JEHghletpj/xUMz1aSYJuCiNa7Z9TZx6IeEc9Rku5b5HMtcy76I1zaM+mw3uHt6Yl4W/j5yL24QPwjwiEFAq3TE2qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhvBLPR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhvBLPR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02F7C4CEF5;
	Wed,  3 Dec 2025 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778579;
	bh=9jLDUhb01PVWj2MMAUcS889hNZtwd2lfYEOlopBIQaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhvBLPR3LS/HiLds5NfMqjCEUuhkECxG/S99npIY4cBQV1KoyGJeKob1SsiHfRCDT
	 53mec1umxgMBaIpRWSNmdDZ4yyRS47S00OKRsk0O41NFpOFJzLVeBTn7NNQ2gELc6U
	 HCcQP/agV9NJHEd+qpYA4jSm60jkkYiemcYFVn3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 389/392] selftests/bpf: Dont rely on preserving volatile in PT_REGS macros in loop3
Date: Wed,  3 Dec 2025 16:28:59 +0100
Message-ID: <20251203152428.508639906@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

commit 70bc793382a0e37ba4e35e4d1a317b280b829a44 upstream.

PT_REGS*() macro on some architectures force-cast struct pt_regs to
other types (user_pt_regs, etc) and might drop volatile modifiers, if any.
Volatile isn't really required as pt_regs value isn't supposed to change
during the BPF program run, so this is correct behavior.

But progs/loop3.c relies on that volatile modifier to ensure that loop
is preserved. Fix loop3.c by declaring i and sum variables as volatile
instead. It preserves the loop and makes the test pass on all
architectures (including s390x which is currently broken).

Fixes: 3cc31d794097 ("libbpf: Normalize PT_REGS_xxx() macro definitions")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220106205156.955373-1-andrii@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/loop3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/progs/loop3.c
+++ b/tools/testing/selftests/bpf/progs/loop3.c
@@ -12,9 +12,9 @@
 char _license[] SEC("license") = "GPL";
 
 SEC("raw_tracepoint/consume_skb")
-int while_true(volatile struct pt_regs* ctx)
+int while_true(struct pt_regs *ctx)
 {
-	__u64 i = 0, sum = 0;
+	volatile __u64 i = 0, sum = 0;
 	do {
 		i++;
 		sum += PT_REGS_RC(ctx);


