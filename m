Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C782163AB;
	Thu, 12 Dec 2024 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016094; cv=none; b=rcUlFdnJ0QRS+86hbt0NJM7Ht3qppv+V4U0iNRY8oGS3cTnj8kxZCZi/otkaZEJvYBHLLUnjoamr35fkSw4kpOIESXmF6mJemzlM0q17K08hCr7DVs8tE07Izn80F62ect6SPp7AywDHjOVaRhh7Cuvg+/f7PbXEErQUytIEvIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016094; c=relaxed/simple;
	bh=QNs04o5wKwEJZ8VigCa51mj/wTcuOH9cFHoSnSC0RnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHiNDRjAFO1cJ9QCLUHcX6J2irBx8cWu4D3HyUtPe5AzyDZEcALldhiCdvjDsVublxIyr2s0Pa5JSFGVVyHyTSYb3SftgQuMoHd5SZmxBIgwtucavd8ZDpTu7yFvGGNG2INjbzlirzFj/FcYcSfCXxLSK9gY3zbxnO8YT0yGZEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlmMQtbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlmMQtbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA04C4CECE;
	Thu, 12 Dec 2024 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016094;
	bh=QNs04o5wKwEJZ8VigCa51mj/wTcuOH9cFHoSnSC0RnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlmMQtbJzNtKMuwBRQjYj0Xf2EZ/D3UDQERbdjFf9rENIXuTnNxsUlK1mbZN7Mc9h
	 RQh2/AstyFNzQM/MqicFfpmowTI5uL1Qo3up8PqUPgkS3Tc3w55GQ9E4TFi3DB9J3L
	 axLJbd8dkxNsUiwdyRPIF3KOy/iB9S9h7jt8FSsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Tao Lyu <tao.lyu@epfl.ch>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/466] bpf: Ensure reg is PTR_TO_STACK in process_iter_arg
Date: Thu, 12 Dec 2024 15:54:29 +0100
Message-ID: <20241212144310.765861597@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Lyu <tao.lyu@epfl.ch>

[ Upstream commit 12659d28615d606b36e382f4de2dd05550d202af ]

Currently, KF_ARG_PTR_TO_ITER handling missed checking the reg->type and
ensuring it is PTR_TO_STACK. Instead of enforcing this in the caller of
process_iter_arg, move the check into it instead so that all callers
will gain the check by default. This is similar to process_dynptr_func.

An existing selftest in verifier_bits_iter.c fails due to this change,
but it's because it was passing a NULL pointer into iter_next helper and
getting an error further down the checks, but probably meant to pass an
uninitialized iterator on the stack (as is done in the subsequent test
below it). We will gain coverage for non-PTR_TO_STACK arguments in later
patches hence just change the declaration to zero-ed stack object.

Fixes: 06accc8779c1 ("bpf: add support for open-coded iterator loops")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Tao Lyu <tao.lyu@epfl.ch>
[ Kartikeya: move check into process_iter_arg, rewrite commit log ]
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241203000238.3602922-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                                  | 5 +++++
 tools/testing/selftests/bpf/progs/verifier_bits_iter.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 91317857ea3ee..8955259112c03 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8021,6 +8021,11 @@ static int process_iter_arg(struct bpf_verifier_env *env, int regno, int insn_id
 	const struct btf_type *t;
 	int spi, err, i, nr_slots, btf_id;
 
+	if (reg->type != PTR_TO_STACK) {
+		verbose(env, "arg#%d expected pointer to an iterator on stack\n", regno - 1);
+		return -EINVAL;
+	}
+
 	/* For iter_{new,next,destroy} functions, btf_check_iter_kfuncs()
 	 * ensures struct convention, so we wouldn't need to do any BTF
 	 * validation here. But given iter state can be passed as a parameter
diff --git a/tools/testing/selftests/bpf/progs/verifier_bits_iter.c b/tools/testing/selftests/bpf/progs/verifier_bits_iter.c
index 7c881bca9af5c..a7a6ae6c162fe 100644
--- a/tools/testing/selftests/bpf/progs/verifier_bits_iter.c
+++ b/tools/testing/selftests/bpf/progs/verifier_bits_iter.c
@@ -35,9 +35,9 @@ __description("uninitialized iter in ->next()")
 __failure __msg("expected an initialized iter_bits as arg #1")
 int BPF_PROG(next_uninit, struct bpf_iter_meta *meta, struct cgroup *cgrp)
 {
-	struct bpf_iter_bits *it = NULL;
+	struct bpf_iter_bits it = {};
 
-	bpf_iter_bits_next(it);
+	bpf_iter_bits_next(&it);
 	return 0;
 }
 
-- 
2.43.0



