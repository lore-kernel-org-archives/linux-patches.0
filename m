Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADA7155352;
	Mon,  6 Jan 2025 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177933; cv=none; b=IJqFgfxiHtx9IoFnmoGC63vAF3ddtApmu1gR/olZjuswNgZ1s5E3GrQKd7AMmOaYaLhTtH76u2KDqW6pOJMa2QdQBkQNP/aeP0+LlmTVva+X4v97kM+SU2SeU8DBBxIUKT+IObW8kwS5g/AqLHE4TATUBx5KpoQVpP94oaMOKp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177933; c=relaxed/simple;
	bh=Ovd+EtWl14bxhwF0iSCpdj6RYZFbniDYbip7Fdh0yec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhWhs8zFs3O7ZkfClAWhNGGcQXvNQKErqJAAyV5KWlkp0bZhiAcwutjrQLa2w1eHZHjaQgW7u1RUS30ywF2aN8UZzWmP7G/zdHUU1DIiSUEVQchJ4dqwodgNkjyUigccuPCrkOTdInbu6fOivqMeSIgFeHm1Nfr54/sAY9Bh4Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9mMxFop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9mMxFop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F7EC4CED6;
	Mon,  6 Jan 2025 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177933;
	bh=Ovd+EtWl14bxhwF0iSCpdj6RYZFbniDYbip7Fdh0yec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9mMxFopNwNhWIMv41muU/YBD4NdnlwscFBuz1rpyfPSj8rSd0+ElXbitZ/ZOoaw/
	 RHwWrBr///b9MmufLB7rwHcGA2PDgw5DjDz9+2dG3xzrhGUZhu+SzpODrY6W9c+EUZ
	 O1qJJeK/piC2g3e/nbOnP/o/LKbyhL7S7ktyqcww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/156] bpf: consider that tail calls invalidate packet pointers
Date: Mon,  6 Jan 2025 16:16:31 +0100
Message-ID: <20250106151145.682825009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 1a4607ffba35bf2a630aab299e34dd3f6e658d70 ]

Tail-called programs could execute any of the helpers that invalidate
packet pointers. Hence, conservatively assume that each tail call
invalidates packet pointers.

Making the change in bpf_helper_changes_pkt_data() automatically makes
use of check_cfg() logic that computes 'changes_pkt_data' effect for
global sub-programs, such that the following program could be
rejected:

    int tail_call(struct __sk_buff *sk)
    {
    	bpf_tail_call_static(sk, &jmp_table, 0);
    	return 0;
    }

    SEC("tc")
    int not_safe(struct __sk_buff *sk)
    {
    	int *p = (void *)(long)sk->data;
    	... make p valid ...
    	tail_call(sk);
    	*p = 42; /* this is unsafe */
    	...
    }

The tc_bpf2bpf.c:subprog_tc() needs change: mark it as a function that
can invalidate packet pointers. Otherwise, it can't be freplaced with
tailcall_freplace.c:entry_freplace() that does a tail call.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-8-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c                              | 2 ++
 tools/testing/selftests/bpf/progs/tc_bpf2bpf.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4b0ad74cfff5..54a53fae9e98 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7943,6 +7943,8 @@ bool bpf_helper_changes_pkt_data(enum bpf_func_id func_id)
 	case BPF_FUNC_xdp_adjust_head:
 	case BPF_FUNC_xdp_adjust_meta:
 	case BPF_FUNC_xdp_adjust_tail:
+	/* tail-called program could call any of the above */
+	case BPF_FUNC_tail_call:
 		return true;
 	default:
 		return false;
diff --git a/tools/testing/selftests/bpf/progs/tc_bpf2bpf.c b/tools/testing/selftests/bpf/progs/tc_bpf2bpf.c
index 8a0632c37839..79f5087dade2 100644
--- a/tools/testing/selftests/bpf/progs/tc_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/tc_bpf2bpf.c
@@ -10,6 +10,8 @@ int subprog(struct __sk_buff *skb)
 	int ret = 1;
 
 	__sink(ret);
+	/* let verifier know that 'subprog_tc' can change pointers to skb->data */
+	bpf_skb_change_proto(skb, 0, 0);
 	return ret;
 }
 
-- 
2.39.5



