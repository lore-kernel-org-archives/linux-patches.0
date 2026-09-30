Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D142F709;
	Wed, 30 Sep 2026 19:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795226; cv=none; b=JQMQ97ncXkyxka+sL6jl1f/TtaGinscLmt0DeDlM+89DjB4nLupCHiDihzdw2lj2Yvt+D5l3GOl86c0I6DKn56v4XCRUsrc7D3SQGzS/ggP+ivPT3otNbbl9mvAIXbFpvWwCTBAtzYhyMylYKku5pb7lu+9c/AMyNjEo/zE3R2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795226; c=relaxed/simple;
	bh=NLcJhu22/ShE+K56/qcEYWdE9lqpg7XQSW+rTHtb3rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2DxzKPOHjcG26DKE/ys0goLyvyuO/J1P0erzAzds3F1QDIHnCM54amZEvHvseLZqX6ncrHDycmKs4lcx3k/WDrAI44tYcNt3RFKpOH+aThUOX95WTcH4Kj39dx64LyrS0iI5rKSl2uNZTc04hPYxgy6uYcfRXNweKJYtLnIQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDJ+lcWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDJ+lcWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59041F000FF;
	Wed, 30 Sep 2026 19:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795225;
	bh=cHRHOzX369reMBz1uQw6RPFQqegWjKC8cTRH/cAnU4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDJ+lcWNHcOu/NnPbVfHG2ru6nZ3jjjIuLnkhzROWTwGAiOSDOSu+2ErCydtPqYrF
	 DFqj1912tbxGk0Bmb2d8WkuhXQ2Gh1Q6jVj9BTmJAmT6NLBwju3jYEumx/bpdGcy+D
	 6rRkEgF5T5yJZ5Hnd82mHs8ytrdhcx49qIN8eOzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0487/1193] selftests/bpf: Fix flaky bpf_nf test when random NAT port is 0
Date: Wed, 30 Sep 2026 17:19:31 +0200
Message-ID: <20260930152444.972921321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0289d8ce2b80d..a1b1a5f121d44 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -170,8 +170,8 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
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
@@ -273,8 +273,8 @@ nf_ct_opts_new_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *
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



