Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF4D21504D;
	Wed,  7 May 2025 19:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644932; cv=none; b=RX4yhyWX9Iv3weUlp41b6SmDuu2mw47dLH+PGWCw8uG2p1VhRMEMufyCEFu3kKPHLmvqPzS0bYm6zvl5PFMyg/xX427g1GMS/ELq7WR30G0AO1klHLb5k5JA1BM/QcNjy7fo93JAvH87iEO9BMA3kFDVhlpedVy8jcYYXOUjLdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644932; c=relaxed/simple;
	bh=QYy1puwB4kpnzhrhhY92fVT05xfLetmc6XywLIA1l/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/4EaXhzpbI8fIe1u91dqt1zwI59Ph14Ovr2UEIwg1JN7vu7SibJcWJ8OPzFLuZ4UhfcnDh3Q838USgnrgbuZ2JzplbsrIE5MuBdGhE53uPDlLn0FkTqRF58UPG31gkshwbBVINjGtW+Ywh7+2BmnIkFK5mCgGj9U+QoBwltXh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXXO3pYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXXO3pYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07ADC4CEE2;
	Wed,  7 May 2025 19:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644932;
	bh=QYy1puwB4kpnzhrhhY92fVT05xfLetmc6XywLIA1l/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXXO3pYycGYW7C+YNDkA9Tjx0R0VXMOLCh1WcqW/3Z22JzPmUHERQmcc+kdpn6574
	 RdLFe7hk36IOgYCSXkAl7tdqiWXwtrrWSHPdtinPgPkRgRj0t9vySkKi95tFdk8E+h
	 11H+COU6cen5aGhb551TZIERgcSXaN2bd1CDwVU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 039/129] bpf: consider that tail calls invalidate packet pointers
Date: Wed,  7 May 2025 20:39:35 +0200
Message-ID: <20250507183815.119372997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 1a4607ffba35bf2a630aab299e34dd3f6e658d70 upstream.

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
[ shung-hsi.yu: drop changes to tools/testing/selftests/bpf/progs/tc_bpf2bpf.c
because it is not present. ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7893,6 +7893,8 @@ bool bpf_helper_changes_pkt_data(enum bp
 	case BPF_FUNC_xdp_adjust_head:
 	case BPF_FUNC_xdp_adjust_meta:
 	case BPF_FUNC_xdp_adjust_tail:
+	/* tail-called program could call any of the above */
+	case BPF_FUNC_tail_call:
 		return true;
 	default:
 		return false;


