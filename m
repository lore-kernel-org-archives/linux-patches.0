Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A58399D0C;
	Thu, 17 Sep 2026 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659366; cv=none; b=TyJOUCqVfyZnjGyQWQ/i5Pt/2KELJKIzFYRP3S478pF9s2e+Vg+Qam0z70Dcemfo7jhC1U0KSHBvVQIVBtvCTHuJqxPp5W7ljFeHUdEGuXVVG/4B5X+QvkNAexhDksZV3ytwbsnbgxOEvhj2mZ6OkWZurHRnS3J9+MDx4ZCF9m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659366; c=relaxed/simple;
	bh=o8tGXCxAK6S6yqhk3J9NRqjahDr9R380PWR8y89JRQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6DFVc2VqJIMyuVs8dp+vh//sPVPvQMmby23iCOE17iC1sqzSiBZS7L6m+snw2HKGsnTA9M7e18D/GGK01cpbOd0/MC5ZIWjzE8QJeyFVrffb06jKxk14aely153GsjmOCd/6ziY+bpbVJ3A3GlkHsaNCUsHXkrFfDkRRmNitDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccFw2p3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccFw2p3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDFF1F008A0;
	Thu, 17 Sep 2026 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659362;
	bh=aWR0ZmotOKpReYT5XsvxfpnFYa04Frl1ZBWpLroweOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccFw2p3xKpmouq/z3MH36drbf9Tchgnykg9wtoiOzryIr5BjOoFfo2AZeuB6Ru3Er
	 uimGDz+Wmlhm1n2HmGscVMgn9Zo/+txsw55eG/MoDWHKV4XupFkxBIfGlyNHP9Rz+y
	 FpTK5+KwKVyNdhyToke3VEWb9iJ/OKLbJBVVzNe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 231/733] bpf: Reject resilient lock operations in rbtree callbacks
Date: Thu, 17 Sep 2026 16:08:59 +0100
Message-ID: <20260917151356.985357631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 7b7b8b5960102566bd625ae829d1f330c5b5d104 ]

__bpf_rbtree_add() keeps parent and link pointers live across calls to the
program-supplied comparison callback. The verifier therefore requires the
root's lock to remain held throughout the callback.

The helper path enforces this rule for bpf_spin_lock() and
bpf_spin_unlock(), but the resilient lock kfunc argument path does not.
Since resilient locks may protect BPF rbtree roots, a callback can release
the root lock and let another CPU remove and free the node referenced by
the in-progress tree walk. The walk then resumes using freed pointers.

Reject resilient lock kfuncs in an rbtree comparison callback, matching
the existing policy for the spin lock helpers. Resilient-lock-protected
trees remain valid when their comparison callbacks leave lock state alone.

Fixes: 0de2046137f9 ("bpf: Implement verifier support for rqspinlock")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-6-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index aeb5711211245..bc5aea31df589 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12544,6 +12544,11 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 		{
 			int flags = PROCESS_RES_LOCK;
 
+			if (in_rbtree_lock_required_cb(env)) {
+				verbose(env, "can't res_spin_{lock,unlock} in rbtree cb\n");
+				return -EACCES;
+			}
+
 			if (reg->type != PTR_TO_MAP_VALUE && reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
 				verbose(env, "%s doesn't point to map value or allocated object\n",
 					reg_arg_name(env, argno));
-- 
2.53.0



