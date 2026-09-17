Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B7C4F93CA;
	Thu, 17 Sep 2026 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665684; cv=none; b=QoqsjWH53135JLp0Sq4phTkhUi3ik1+zdoUXzvy1sSWGC/329QbbDAsVNUCVTCpn9IQmb1LlYF4c1H9jwjez+VaANJiq+fv8DXtcvzFPTPJhK6vqyNHJrwSF+naUDHyU95FnSFHc/MHTtPKrnuN6Oa7rWGuwr+C8xNjthPF63no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665684; c=relaxed/simple;
	bh=bghWoUQs+Tjg1nht8OUEuLyOuzvrQECiL6I88KqsRBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtT1QAUm8eI0rTKLzmk7VDkh2dM/seXubZagBiHue2dVsVnl08Pb4vJ+gKXnhLXJsuTzZf0yOhYxR5KkENMkr3UnnmGygevSs/CT6wBbbHFY4OA9wYozN8WnhyBX9mKB9T/PHEMqXm6rdmSjvjWozibwL62oK5P/VFdlYuyPWh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eiR3bhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eiR3bhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA9C1F00893;
	Thu, 17 Sep 2026 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665683;
	bh=upe25V8Qcg3xJvEzwXGxWF1EXVWXJw6bcIj4M/pdUHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eiR3bhsZlpldFKWY3eQDNtS+BrHObOhRwcxZy+R8eD2vDMnqookaM+0V3TYqWh9j
	 ZSuoyh3+p5/LoIyYExr6mY4VC7nu1M0DqbWGxO6v3kqdqRCq6ZBC+GLnFJRbnHpyKI
	 kpHxVe07znTJ/S8U/Big2fmQ0Ip87SV9/FQxlOYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0787/1250] selftests/bpf: Fix flaky bpf_nf test when random NAT port is 0
Date: Thu, 17 Sep 2026 16:09:42 +0100
Message-ID: <20260917151613.225581378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 5e8c349bc8d790fe031a4332e502f5d4f9878644 ]

The bpf_nf test allocs a ct, sets snat and dnat with random addr and
port via bpf_ct_set_nat_info(), then looks the ct up and checks the
reply tuple against what was set.

The port comes from bpf_get_prandom_u32() and can be 0. For
bpf_ct_set_nat_info(), port 0 means "port not specified", so only the
addr is mapped and the kernel keeps the original port. The check then
compares that port with 0 and fails, which shows up as a flaky
"Test for source natting" failure in CI [1][2].

Keep the random port in 1..65535 so it is always specified.

[1] https://github.com/kernel-patches/bpf/actions/runs/33830002889/job/100893868791
[2] https://github.com/kernel-patches/bpf/actions/runs/33829976794/job/100893220999

Fixes: b06b45e82b59 ("selftests/bpf: add tests for bpf_ct_set_nat_info kfunc")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260904073745.363314-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_bpf_nf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index f7b330ddd007e..b42e6e149e26c 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -171,8 +171,8 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
 		      sizeof(opts_def));
 	if (ct) {
-		__u16 sport = bpf_get_prandom_u32();
-		__u16 dport = bpf_get_prandom_u32();
+		__u16 sport = bpf_get_prandom_u32() % 65535 + 1;
+		__u16 dport = bpf_get_prandom_u32() % 65535 + 1;
 		union nf_inet_addr saddr = {};
 		union nf_inet_addr daddr = {};
 		struct nf_conn *ct_ins;
@@ -274,8 +274,8 @@ nf_ct_opts_new_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *
 	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
 		      sizeof(opts_def));
 	if (ct) {
-		__u16 sport = bpf_get_prandom_u32();
-		__u16 dport = bpf_get_prandom_u32();
+		__u16 sport = bpf_get_prandom_u32() % 65535 + 1;
+		__u16 dport = bpf_get_prandom_u32() % 65535 + 1;
 		union nf_inet_addr saddr = {};
 		union nf_inet_addr daddr = {};
 		struct nf_conn *ct_ins;
-- 
2.53.0



