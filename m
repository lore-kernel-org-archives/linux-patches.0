Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B34B18C03D;
	Mon, 28 Oct 2024 06:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097501; cv=none; b=OsKD2tzta48Wk5vAW+FifWsRLa58GGYSGeeDve/7IetV+ZaxErepmN594nt0KGLijQA85YzXW4h03FDwGulCm9Js3UhxyzgLymL39ewqfpRDNcC4AaDW4CD3s49Ff2Ts/A+vB9k6SRvMo2EoaS9+A+NwkbnsvVfKqqa1ggcW8DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097501; c=relaxed/simple;
	bh=Xb6GExwADol7koVSq/1qU74muGAiKZs1VracmWWMxic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MX6a+2aqFm4mgGcpriM5FIgR2OQnJmMRwOoeMBIarv3KYpjwgR/PMXlM7h91E3VOtozWc8VKlKPYUnU/w/+xH/TPNoYiIegmbcRGYPWB0+ISFkjrv9yqv0DR5eMtrBlNJ/W4JUabW3GhEoCi8m7VhM7muSPwLFeZ7cquf66rKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZ/6iofZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZ/6iofZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B560C4CEC3;
	Mon, 28 Oct 2024 06:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097501;
	bh=Xb6GExwADol7koVSq/1qU74muGAiKZs1VracmWWMxic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZ/6iofZ7A6VKeLa4gGeay6OoSBlM5ryBbyuTSRl49ZtOOoFh8HdT0krb+olPdjPr
	 t1eD5WuKR3/XbOvAhh4ZpsxhKgU3nT5eks85YZ5pbOQPDG9X+30jZgYmF1n8bG6eyw
	 WOS7OIQ0iaiVSxnL+jvz2xVz2GC4Iju8NeOnJzik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Sundberg <simon.sundberg@kau.se>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/208] bpf: fix kfunc btf caching for modules
Date: Mon, 28 Oct 2024 07:23:20 +0100
Message-ID: <20241028062307.155315180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 6cb86a0fdece87e126323ec1bb19deb16a52aedf ]

The verifier contains a cache for looking up module BTF objects when
calling kfuncs defined in modules. This cache uses a 'struct
bpf_kfunc_btf_tab', which contains a sorted list of BTF objects that
were already seen in the current verifier run, and the BTF objects are
looked up by the offset stored in the relocated call instruction using
bsearch().

The first time a given offset is seen, the module BTF is loaded from the
file descriptor passed in by libbpf, and stored into the cache. However,
there's a bug in the code storing the new entry: it stores a pointer to
the new cache entry, then calls sort() to keep the cache sorted for the
next lookup using bsearch(), and then returns the entry that was just
stored through the stored pointer. However, because sort() modifies the
list of entries in place *by value*, the stored pointer may no longer
point to the right entry, in which case the wrong BTF object will be
returned.

The end result of this is an intermittent bug where, if a BPF program
calls two functions with the same signature in two different modules,
the function from the wrong module may sometimes end up being called.
Whether this happens depends on the order of the calls in the BPF
program (as that affects whether sort() reorders the array of BTF
objects), making it especially hard to track down. Simon, credited as
reporter below, spent significant effort analysing and creating a
reproducer for this issue. The reproducer is added as a selftest in a
subsequent patch.

The fix is straight forward: simply don't use the stored pointer after
calling sort(). Since we already have an on-stack pointer to the BTF
object itself at the point where the function return, just use that, and
populate it from the cache entry in the branch where the lookup
succeeds.

Fixes: 2357672c54c3 ("bpf: Introduce BPF support for kernel module function calls")
Reported-by: Simon Sundberg <simon.sundberg@kau.se>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20241010-fix-kfunc-btf-caching-for-modules-v2-1-745af6c1af98@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3032a464d31bb..d1050479cbb33 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2799,10 +2799,16 @@ static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
 		b->module = mod;
 		b->offset = offset;
 
+		/* sort() reorders entries by value, so b may no longer point
+		 * to the right entry after this
+		 */
 		sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
 		     kfunc_btf_cmp_by_off, NULL);
+	} else {
+		btf = b->btf;
 	}
-	return b->btf;
+
+	return btf;
 }
 
 void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab)
-- 
2.43.0



