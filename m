Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D341E520A;
	Sat, 17 Oct 2026 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255450; cv=none; b=Ovj2bHZ9H4DWn1hqDF6VM8IBHGjwcxw3uFst5G22hi9MYK0bZIdkfOt/b3Nvr2/gBDsKdDtq2M+PW6WxMvF+0z4Jq8D8Va+JFl6x/mYRR2yqmRZFLEUDwXb5oBTFT4p9VOaOR4YcFiZizbNiC5R+d6XOvHTEotlWeLr1gYaQQxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255450; c=relaxed/simple;
	bh=3dcWHaTKBWJnrAdkf/QGP7jmrtcHWXGWrThgMCoTApE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BScxXq75koCfa4zK8fHwyuTiRA00WiYAfato34L8qiQm+A0d2tY+2ZX1b6oQJEiwcKs+/apy58iNalJoH1HADQSuO+/WE8GLr6AHGHA5SOwnlfiwZw0aVswHQjhtmP9biELmMxVSFxI2eTabNqZui4WzH9J9EN771JZGGakltUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsQ3Fytm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsQ3Fytm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452BF1F000C4;
	Sat, 17 Oct 2026 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255449;
	bh=Y632TRk5jRddR0D0gx6qiQxeuaS1xaOTQEOVtv5q+q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsQ3FytmeE71kSwvSk8FGo+yBZ5JvaPHuiJ6+Yi/nWLTxigctu6Z5ShE4K298Bhco
	 YrKkFDUnOHAyBOF0GVES8CBna7hd9TiNI692dyl7JRDydVBNj/7ECb/GDezK8BcpA3
	 JUijBhI+Hso4XXy4q7OxDawBeG/XlcknKCfAmxl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Ning Ding <dingning04@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 779/869] bpf: Keep refcount_acquire nullable for borrowed RCU kptrs
Date: Sat, 17 Oct 2026 18:00:20 +0200
Message-ID: <20261017160056.892477382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit dc36739e5cc9f60485418a910b42bc95339218d2 ]

bpf_refcount_acquire() is fallible for a borrowed reference because the
object may have reached a zero refcount. The verifier therefore keeps
KF_RET_NULL on the return value unless the argument is an owning reference.

An RCU-protected load of a local kptr is marked MEM_ALLOC, but it only
receives NON_OWN_REF when the pointee contains a graph node. A refcounted
object without a graph node consequently looks like an owning reference
even though the loaded register has no acquired reference state. If the
program drops the last real reference while remaining in the RCU critical
section, refcount_inc_not_zero() returns NULL while the verifier treats the
result as non-NULL.

Only classify the argument as owning when it is backed by a verifier-tracked
reference. This retains the non-NULL return for pointers from bpf_obj_new(),
bpf_kptr_xchg(), or an earlier successful acquisition, while requiring a
NULL check for borrowed RCU kptrs.

Fixes: 1b12171533a9 ("bpf: Mark direct ld of stashed bpf_{rb,list}_node as non-owning ref")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Ning Ding <dingning04@gmail.com>
[ kkd: Rewrote commit log ]
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904084325.52250-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ebce193173ce7..c1957d03f9d23 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12732,7 +12732,7 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				verbose(env, "arg#%d is neither owning or non-owning ref\n", i);
 				return -EINVAL;
 			}
-			if (!type_is_non_owning_ref(reg->type))
+			if (!type_is_non_owning_ref(reg->type) && reg->ref_obj_id)
 				meta->arg_owning_ref = true;
 
 			rec = reg_btf_record(reg);
-- 
2.53.0



