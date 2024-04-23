Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89843143C5F;
	Tue, 23 Apr 2024 21:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908768; cv=none; b=NKHrtU9NPPuDenay/JkyItSCR2f+mDBuG7Ge5aWTFCvOaZRBYXm/lQG1EJ7sY+fd5Q+EmRzD4sYheMr+VyodNsLbEKmbE/4rcnJq3Zdfm2fsbI3y6ou6OI2P1LoGUBfvQCYiCWBQKhUPpdzeFf9XLOPmOIM1B0mqCqyiVdF71Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908768; c=relaxed/simple;
	bh=wz9YJ+YO7lnt/Y9FMsfvMp/oY7kbKkzl/IxNL8HBZkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgK2d7G1YUssf0mvmhqBS5pZSJksgF4Cg5GiY54TKerzV7R4OdBpLjwYom2ygODGA8CkedKD2Erp1fpXwKG4r1mbLf/Xg0GBfSJR0Hb1vGAGoIigpTFlBExjFJ47Xi18gn3pXOysb6WvKbz1/a6QyFiHDvA2Tei40YKPFtmDcrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfX3nASb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfX3nASb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB73C3277B;
	Tue, 23 Apr 2024 21:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908768;
	bh=wz9YJ+YO7lnt/Y9FMsfvMp/oY7kbKkzl/IxNL8HBZkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfX3nASbC4iZ76IR+z6fGkW1KmTFLRYiXOI3sZNmboBxEm+/r20RFKty2KGy4mLb0
	 QONukolrze1IkF0p0N5k6k2og8IEjkjoqcLlEhvct1PRM6n5YiTUaRQAU+3T11w/92
	 VDAprWyRZVenxF2S9KQk70ZHSBCQ8EbKNL7k+xjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Edward Liaw <edliaw@google.com>,
	tr3e.wang@gmail.com
Subject: [PATCH 5.15 10/71] bpf: Fix out of bounds access for ringbuf helpers
Date: Tue, 23 Apr 2024 14:39:23 -0700
Message-ID: <20240423213844.477417680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit 64620e0a1e712a778095bd35cbb277dc2259281f upstream.

Both bpf_ringbuf_submit() and bpf_ringbuf_discard() have ARG_PTR_TO_ALLOC_MEM
in their bpf_func_proto definition as their first argument. They both expect
the result from a prior bpf_ringbuf_reserve() call which has a return type of
RET_PTR_TO_ALLOC_MEM_OR_NULL.

Meaning, after a NULL check in the code, the verifier will promote the register
type in the non-NULL branch to a PTR_TO_MEM and in the NULL branch to a known
zero scalar. Generally, pointer arithmetic on PTR_TO_MEM is allowed, so the
latter could have an offset.

The ARG_PTR_TO_ALLOC_MEM expects a PTR_TO_MEM register type. However, the non-
zero result from bpf_ringbuf_reserve() must be fed into either bpf_ringbuf_submit()
or bpf_ringbuf_discard() but with the original offset given it will then read
out the struct bpf_ringbuf_hdr mapping.

The verifier missed to enforce a zero offset, so that out of bounds access
can be triggered which could be used to escalate privileges if unprivileged
BPF was enabled (disabled by default in kernel).

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: <tr3e.wang@gmail.com> (SecCoder Security Lab)
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Edward Liaw <edliaw@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5340,9 +5340,15 @@ static int check_func_arg(struct bpf_ver
 	case PTR_TO_BUF:
 	case PTR_TO_BUF | MEM_RDONLY:
 	case PTR_TO_STACK:
+		/* Some of the argument types nevertheless require a
+		 * zero register offset.
+		 */
+		if (arg_type == ARG_PTR_TO_ALLOC_MEM)
+			goto force_off_check;
 		break;
 	/* All the rest must be rejected: */
 	default:
+force_off_check:
 		err = __check_ptr_off_reg(env, reg, regno,
 					  type == PTR_TO_BTF_ID);
 		if (err < 0)


