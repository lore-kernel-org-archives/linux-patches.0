Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B14C651B;
	Wed, 30 Sep 2026 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785106; cv=none; b=pooII3T+1hSYSrKiCTZJIeQVOXnUKw3D24PeagzSTgQVLaD0jKR1GM0XKIjhW6vOBzk1mIU45JXW8hvoLTaF8qoyEHhg64UzHjp0CV+V85oPVaeYlbetlFWKt5OW2aDe+6eLBxeiqs/JtuZdJr/GWc2z0YSeJXbM9F0t9i/s5Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785106; c=relaxed/simple;
	bh=caDngUOmFkUqOrMNx6pltWMJ8C/SnmZo2C8fqw3K5x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWJVmiOZlej+WRwDyeNqLQQ0LXdJx69O8B+aaFD7QJK25TwvQsZkf73RCBmGLzShyjIYKf/qhpNLhqVPe4y4MSzEOxzlygc+aS5wnX6uICP2YK7wLSGM3Euv7DSO5RR0f8yF6mNYVmCZWnKJYkOkvDR4TfeCQJgMCLCUfk8mz0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlZmV9Zy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlZmV9Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337041F000FF;
	Wed, 30 Sep 2026 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785101;
	bh=fPxT5PNAc3CKCthiK5QVaabzS7o6cBjF8sa/fa9EKN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlZmV9Zy+lIDnIBXhgBzWpzxpobXqnKqaCrS92ksaMcQgy/vS1stOvFSzsWTHhVth
	 pxX46NWiS+n1M8xyL9kRyrozYDp9AHGpCKvgLgBcRV+rGFW0ywgG7MOjBXPN1NTVyu
	 92dRdf6QH7LZrZXeJ/NgqlZS5NCcdwrmfnLPDt+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 388/982] bpf: reject BPF_PSEUDO_FUNC reference to the main program
Date: Wed, 30 Sep 2026 17:18:44 +0200
Message-ID: <20260930152425.140632129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 374b2c5561db80fcdd7cdce44af37a49416f61c7 ]

fixups.c:jit_subprogs() rewrites BPF_PSEUDO_FUNC loads to contain real
function addresses. This function is invoked from bpf_jit_subprogs()
only when env->subprog_cnt > 1. Meaning that for any program like
below:

  int main(void *ctx) {
    void *ptr = main;
    ...
    bpf_timer_set_callback(..., ptr);
    ...
  }

The 'ptr' won't be ever converted to contain an address.
In combination with e.g. bpf_timer_set_callback() this would lead to a
function call at a bogus address.

Instead of complicating the implementation, just assume that no useful
program needs main to be a sync or async callback and reject
BPF_PSEUDO_FUNC loads for the main subprogram.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260902233658.1186477-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9c7384295f13d..c201435ddafd2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10625,6 +10625,15 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			verbose(env, "callback function not static\n");
 			return -EINVAL;
 		}
+		/*
+		 * When env->subprog_cnt == 1 this instruction won't be rewritten
+		 * to hold a real function address. Assume that no usable program
+		 * combines e.g. main and timer callback and just reject here.
+		 */
+		if (subprogno == 0) {
+			verbose(env, "callback function cannot be the main program\n");
+			return -EINVAL;
+		}
 
 		dst_reg->type = PTR_TO_FUNC;
 		dst_reg->subprogno = subprogno;
-- 
2.53.0



