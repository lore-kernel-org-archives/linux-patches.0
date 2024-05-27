Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED00168C4;
	Mon, 27 May 2024 19:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837367; cv=none; b=d4PDJHuYN12Ov10F1+jopus9wfL554IKoL/0axr3uH6s6Iz6w/HEGiPTOdHdXgd4REjkvsk8SzzrQ/MtSr4GhmMt7WWIF9rq/QUr3EZrIJ9MTeX5kHP0f9Nkib3/7P7c5x/76cthvnBdwnbU851MTV34Mn2fVlKnGYvesXUHf0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837367; c=relaxed/simple;
	bh=WfQhlA17Ts+YQMAdqg53Gt2DTF1jvsgV5O517OfrObo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLNw8iE8HXDZkshcgdg2nf3OVUBVbfKO4/96ZRSuluAAHyRaqGe5cg58hYAvz9IAjUTF4SkUGz4kp7rAG9OltnnmKttIGsG5qPboyyGUYVh16G+FDWJufIW45WahcUT7zRKG44FguGhsGhEm3pzFYnkgUaSmBuaTz7TtVCggtJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhYvlJ43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhYvlJ43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25071C2BBFC;
	Mon, 27 May 2024 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837367;
	bh=WfQhlA17Ts+YQMAdqg53Gt2DTF1jvsgV5O517OfrObo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhYvlJ43fupPQluU180ePeOJVNnhCpIM12RxpB1FDqeIzr6npA5cbEbBrpTvsys/P
	 6SK9izxFWJSShps3wfjrNNp5uLxfzvEoacuwqLDZ4CL44qVFujgPEIKGCA5udeKuvi
	 s8wHrYmW5ZqK1RIzBERv58pjp/Xo+EavG8OgQ/TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 414/427] libbpf: fix feature detectors when using token_fd
Date: Mon, 27 May 2024 20:57:41 +0200
Message-ID: <20240527185635.524641556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 1de27bba6d50a909647f304eadc0f7c59a842a50 ]

Adjust `union bpf_attr` size passed to kernel in two feature-detecting
functions to take into account prog_token_fd field.

Libbpf is avoiding memset()'ing entire `union bpf_attr` by only using
minimal set of bpf_attr's fields. Two places have been missed when
wiring BPF token support in libbpf's feature detection logic.

Fix them trivially.

Fixes: f3dcee938f48 ("libbpf: Wire up token_fd into feature probing logic")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240513180804.403775-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf.c      | 2 +-
 tools/lib/bpf/features.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 97ec005c3c47f..145b8bd1d5ff1 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -105,7 +105,7 @@ int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts)
  */
 int probe_memcg_account(int token_fd)
 {
-	const size_t attr_sz = offsetofend(union bpf_attr, attach_btf_obj_fd);
+	const size_t attr_sz = offsetofend(union bpf_attr, prog_token_fd);
 	struct bpf_insn insns[] = {
 		BPF_EMIT_CALL(BPF_FUNC_ktime_get_coarse_ns),
 		BPF_EXIT_INSN(),
diff --git a/tools/lib/bpf/features.c b/tools/lib/bpf/features.c
index 4e783cc7fc4b5..a336786a22a38 100644
--- a/tools/lib/bpf/features.c
+++ b/tools/lib/bpf/features.c
@@ -22,7 +22,7 @@ int probe_fd(int fd)
 
 static int probe_kern_prog_name(int token_fd)
 {
-	const size_t attr_sz = offsetofend(union bpf_attr, prog_name);
+	const size_t attr_sz = offsetofend(union bpf_attr, prog_token_fd);
 	struct bpf_insn insns[] = {
 		BPF_MOV64_IMM(BPF_REG_0, 0),
 		BPF_EXIT_INSN(),
-- 
2.43.0



