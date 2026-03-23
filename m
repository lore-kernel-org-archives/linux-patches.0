Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B5E284881;
	Mon, 23 Mar 2026 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282786; cv=none; b=t2QWTMYm8gzfyjwJLD1jG0uctbpgqvbfEz0ZLY8lnsXPVbc+uH4vsz0mepXSqG+6MAe1eW9oOpBR+pCsupUYCZzX5gOsXLPq0+qeY+oN4afWhplJumjxhunBb6cCQx8yu1917n7rw2vriiECV1VchUzQlBmHwL1w1qhYLOqjpUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282786; c=relaxed/simple;
	bh=zstthBn0KF/JrKwZNWtdPZc6Kip9y3puHcEBmfZyWbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrtF4p4d44W3oFxiMLQnMHZFXZY0KpJkBqLk7Yu+5gqvQuRDC8vHS/qh34X87s2GVlknBRRdQDidzKjz43wi/Da6InW5f/LR31wwiGbFWWL8yEoGTyFhfDL+tDVR865POsA+HoD+lNQdSbCPSNXCVn9b8bwNVOeQO1S4JjJw8g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwIKOHBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwIKOHBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B293C4CEF7;
	Mon, 23 Mar 2026 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282786;
	bh=zstthBn0KF/JrKwZNWtdPZc6Kip9y3puHcEBmfZyWbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwIKOHBK2ybN0wEmWYrgWFKuPQ57giVyQmFPQ5O3Mr6+r3l6lHZc34KlKW6mh1urZ
	 Dx7AVcwtaVd2Ztx7Ob06NP+2eUn96xI6uSs1AtdatNL1cnsYlloVLM6ed6eojvoDbv
	 bpOLKc7SzoTIKegS0m2E++Ye/mXdSj9fwaTy4yt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c711ce17dd78e5d4fdcf@syzkaller.appspotmail.com,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.1 278/481] bpf: Forget ranges when refining tnum after JSET
Date: Mon, 23 Mar 2026 14:44:20 +0100
Message-ID: <20260323134531.894515712@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

commit 6279846b9b2532e1b04559ef8bd0dec049f29383 upstream.

Syzbot reported a kernel warning due to a range invariant violation on
the following BPF program.

  0: call bpf_get_netns_cookie
  1: if r0 == 0 goto <exit>
  2: if r0 & Oxffffffff goto <exit>

The issue is on the path where we fall through both jumps.

That path is unreachable at runtime: after insn 1, we know r0 != 0, but
with the sign extension on the jset, we would only fallthrough insn 2
if r0 == 0. Unfortunately, is_branch_taken() isn't currently able to
figure this out, so the verifier walks all branches. The verifier then
refines the register bounds using the second condition and we end
up with inconsistent bounds on this unreachable path:

  1: if r0 == 0 goto <exit>
    r0: u64=[0x1, 0xffffffffffffffff] var_off=(0, 0xffffffffffffffff)
  2: if r0 & 0xffffffff goto <exit>
    r0 before reg_bounds_sync: u64=[0x1, 0xffffffffffffffff] var_off=(0, 0)
    r0 after reg_bounds_sync:  u64=[0x1, 0] var_off=(0, 0)

Improving the range refinement for JSET to cover all cases is tricky. We
also don't expect many users to rely on JSET given LLVM doesn't generate
those instructions. So instead of improving the range refinement for
JSETs, Eduard suggested we forget the ranges whenever we're narrowing
tnums after a JSET. This patch implements that approach.

Reported-by: syzbot+c711ce17dd78e5d4fdcf@syzkaller.appspotmail.com
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/9d4fd6432a095d281f815770608fdcd16028ce0b.1752171365.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ shung-hsi.yu: no detection or kernel warning for invariant violation before
  6.8, but the same umin=1,umax=0 state can occur when jset is preceed by r0 < 1.
  Changes were made to adapt to older range refinement logic before commit
  67420501e868 ("bpf: generalize reg_set_min_max() to handle non-const register
  comparisons"). ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10012,6 +10012,10 @@ static void reg_set_min_max(struct bpf_r
 		}
 		break;
 	case BPF_JSET:
+		/* Forget the ranges before narrowing tnums, to avoid invariant
+		 * violations if we're on a dead branch.
+		 */
+		__mark_reg_unbounded(false_reg);
 		if (is_jmp32) {
 			false_32off = tnum_and(false_32off, tnum_const(~val32));
 			if (is_power_of_2(val32))


