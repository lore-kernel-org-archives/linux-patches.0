Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734B05AD5A2;
	Mon, 31 Aug 2026 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184496; cv=none; b=X6+62bhWzMFHqNRKfQyIRyryY1jVYspEsWMe2aJxnx4MRNwIsLFO7mU4agiluaUnX8OQD/t23/fMZAExIPkDhOJOKdbh9tGK39bzfdP3dzdw6XekAZvWG7pEC8oWTAAsJUszA1bBRtINWzWy3G+dAM4XWGmmcVCRrdv1J4hZyOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184496; c=relaxed/simple;
	bh=aZELddZu6tqm4HhP8G4xAd0WDW2q2HaSmgkotg+yNoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoxKwRHBbijG7oYpC3VNnNR48yk8Dz3IkMqHr0KgZgoLcmf/2LTEGYXsXX7OYeCmJxFexcwBo31RjIPQgTDj6oKmEe8qiTUdkQknSZpmtI1gFqpzMKfmu/Jeo+0z8hfQ/7cXYRZ8rEpselx7ll13ciIK/kN0TEEfsDaSuEaSmX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuOci0vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuOci0vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750061F000E9;
	Mon, 31 Aug 2026 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184494;
	bh=bNdrdK6Jt1DtSTIeFtwCzidTk5OK9X+4McKh40U+DOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuOci0vlnBufHl9lceI3zVU78T7U6ZqQt+s/tku2UfO5jcuYZAJBjkx9IqUvIfaR8
	 DCB8ngrV9c1o1FJYQWBT23VWR21ePaQjx9xExaAjYzPMibUlYK0HshKFnyo/LRFZxf
	 QujaMFPuNDa0mHHg5sd63kPEnQPnhRQaGViLnm4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Tao Lyu <tao.lyu@epfl.ch>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Xu Yunxiang <xyx2021@mail.ustc.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/91] bpf: Ensure reg is PTR_TO_STACK in process_iter_arg
Date: Mon, 31 Aug 2026 15:33:54 +0200
Message-ID: <20260831133359.831346414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Lyu <tao.lyu@epfl.ch>

commit 12659d28615d606b36e382f4de2dd05550d202af upstream.

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

[ Xu Yunxiang: Resolve the verifier.c context conflict by retaining the
  6.6.y BTF lookup and its regno diagnostic convention. Omit the
  verifier_bits_iter.c change because that selftest does not exist in
  6.6.y. ]
Assisted-by: Pi:GLM-5.3
[ sashal: print regno - 1 to match upstream and 6.6's own 0-based arg#
  messages in check_kfunc_args(); supersedes the regno convention noted
  above ]

Signed-off-by: Xu Yunxiang <xyx2021@mail.ustc.edu.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ad679bc42427c..0a67f285f4b08 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7827,6 +7827,11 @@ static int process_iter_arg(struct bpf_verifier_env *env, int regno, int insn_id
 	int spi, err, i, nr_slots;
 	u32 btf_id;
 
+	if (reg->type != PTR_TO_STACK) {
+		verbose(env, "arg#%d expected pointer to an iterator on stack\n", regno - 1);
+		return -EINVAL;
+	}
+
 	/* btf_check_iter_kfuncs() ensures we don't need to validate anything here */
 	arg = &btf_params(meta->func_proto)[0];
 	t = btf_type_skip_modifiers(meta->btf, arg->type, NULL);	/* PTR */
-- 
2.53.0



