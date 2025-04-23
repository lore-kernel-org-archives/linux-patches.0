Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340E419CCEC;
	Wed, 23 Apr 2025 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422462; cv=none; b=ogSfhtXb94mW7g37uA0eGByyXS3nhkKSkLNCe6bRl/hnN5mHUR7zngaaKz73jq4C9faJaXZy7X+AsyOM/n7tFEHjufBmgmXOExhNFXkqFq6lFOT2h+TuftBDUNmGxo+WbExPP6tLiHy9rW2yacAZQOt2QG/Kl9evSSYRv+BO6oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422462; c=relaxed/simple;
	bh=KOzFCu1RVKBvJMMWBUmQrW79PGckYdeEfpWOwejzBuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNjLdLmnzeS795arMfszAiturXh4rByPpoQcXDOoJozbLo32zYvThJDnX6xiN35RBeWhi9H0Ebt7pyfHs3u14Jfi1F3W2l63TPz4NseGGcJ0149qvIOGrMCcHw9N7hQdnG4gLYXhxupGbxLpEV4etqUslws9EOZ1WDPcc60V8jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsG58NL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsG58NL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97694C4CEE2;
	Wed, 23 Apr 2025 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422461;
	bh=KOzFCu1RVKBvJMMWBUmQrW79PGckYdeEfpWOwejzBuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsG58NL49qoty04B5XJfGrq7WdmfmU+u8jGo3gISkx39Ocz2hQ7lEOSWAjis80R5R
	 ctXJqsQwINP+tHqXWfhfpJ+yqaxjuXz20DoZwnwdKfJ6ra63DMHPUiyOmw2hnD9jS7
	 IW1RtKpOmYkWI932G7Z1tYbBvkyGoguofBGvzU2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 282/291] bpf: Prevent tail call between progs attached to different hooks
Date: Wed, 23 Apr 2025 16:44:31 +0200
Message-ID: <20250423142635.949057828@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

commit 28ead3eaabc16ecc907cfb71876da028080f6356 upstream.

bpf progs can be attached to kernel functions, and the attached functions
can take different parameters or return different return values. If
prog attached to one kernel function tail calls prog attached to another
kernel function, the ctx access or return value verification could be
bypassed.

For example, if prog1 is attached to func1 which takes only 1 parameter
and prog2 is attached to func2 which takes two parameters. Since verifier
assumes the bpf ctx passed to prog2 is constructed based on func2's
prototype, verifier allows prog2 to access the second parameter from
the bpf ctx passed to it. The problem is that verifier does not prevent
prog1 from passing its bpf ctx to prog2 via tail call. In this case,
the bpf ctx passed to prog2 is constructed from func1 instead of func2,
that is, the assumption for ctx access verification is bypassed.

Another example, if BPF LSM prog1 is attached to hook file_alloc_security,
and BPF LSM prog2 is attached to hook bpf_lsm_audit_rule_known. Verifier
knows the return value rules for these two hooks, e.g. it is legal for
bpf_lsm_audit_rule_known to return positive number 1, and it is illegal
for file_alloc_security to return positive number. So verifier allows
prog2 to return positive number 1, but does not allow prog1 to return
positive number. The problem is that verifier does not prevent prog1
from calling prog2 via tail call. In this case, prog2's return value 1
will be used as the return value for prog1's hook file_alloc_security.
That is, the return value rule is bypassed.

This patch adds restriction for tail call to prevent such bypasses.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20240719110059.797546-4-xukuohai@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h |    1 +
 kernel/bpf/core.c   |   19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -250,6 +250,7 @@ struct bpf_map {
 	 * same prog type, JITed flag and xdp_has_frags flag.
 	 */
 	struct {
+		const struct btf_type *attach_func_proto;
 		spinlock_t lock;
 		enum bpf_prog_type type;
 		bool jited;
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2121,6 +2121,7 @@ bool bpf_prog_map_compatible(struct bpf_
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	bool ret;
+	struct bpf_prog_aux *aux = fp->aux;
 
 	if (fp->kprobe_override)
 		return false;
@@ -2132,12 +2133,26 @@ bool bpf_prog_map_compatible(struct bpf_
 		 */
 		map->owner.type  = prog_type;
 		map->owner.jited = fp->jited;
-		map->owner.xdp_has_frags = fp->aux->xdp_has_frags;
+		map->owner.xdp_has_frags = aux->xdp_has_frags;
+		map->owner.attach_func_proto = aux->attach_func_proto;
 		ret = true;
 	} else {
 		ret = map->owner.type  == prog_type &&
 		      map->owner.jited == fp->jited &&
-		      map->owner.xdp_has_frags == fp->aux->xdp_has_frags;
+		      map->owner.xdp_has_frags == aux->xdp_has_frags;
+		if (ret &&
+		    map->owner.attach_func_proto != aux->attach_func_proto) {
+			switch (prog_type) {
+			case BPF_PROG_TYPE_TRACING:
+			case BPF_PROG_TYPE_LSM:
+			case BPF_PROG_TYPE_EXT:
+			case BPF_PROG_TYPE_STRUCT_OPS:
+				ret = false;
+				break;
+			default:
+				break;
+			}
+		}
 	}
 	spin_unlock(&map->owner.lock);
 


