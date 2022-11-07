Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCBF7F;
	Mon,  7 Nov 2022 17:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F91C433C1;
	Mon,  7 Nov 2022 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667843476;
	bh=4LXa6C3utC5hFi7jr0THCrMlopaxq6gu+qTu+NmrJCM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jJlluNNXko3tP2Eo+4YJypIwk3mj/SodclE1XNIHkXVsuzOUcxg5+jXHiXkQuFc1S
	 s2pJ8mV7X8iTn8DkPX5ru3MXu7I0nA05mM36EwS/y0+qt4EnXca+Wy2Qjy/l+00P39
	 11NtPIN1/XDFx+yvDV9sOnnVQ8wVfMXHwFRM7aPcP4KNDCZOC240INegZ08MEM6cSS
	 8M9NWBZRYZkNlxQUUkMCP6sXSbFw/k5WEnR77BiqvkrtKIDmVrvX6XmGQsKCsYr4Qg
	 E0ouXkti4JM0e0emoFLab5Oa/3WnGKChKZ4M+m0EYY7iylGmK3urOdBaNj0SXXVwj4
	 Zoks3C5oU1Bvw==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>, kernel
 test robot <lkp@intel.com>, "kernelci.org bot" <bot@kernelci.org>
Subject: Re: [PATCH bpf] bpf: Add explicit cast to 'void *' for
 __BPF_DISPATCHER_UPDATE()
In-Reply-To: <20221107170711.42409-1-nathan@kernel.org>
References: <20221107170711.42409-1-nathan@kernel.org>
Date: Mon, 07 Nov 2022 18:51:12 +0100
Message-ID: <87wn86d567.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nathan Chancellor <nathan@kernel.org> writes:

> When building with clang:
>
>   kernel/bpf/dispatcher.c:126:33: error: pointer type mismatch ('void *' =
and 'unsigned int (*)(const void *, const struct bpf_insn *, bpf_func_t)' (=
aka 'unsigned int (*)(const void *, const struct bpf_insn *, unsigned int (=
*)(const void *, const struct bpf_insn *))')) [-Werror,-Wpointer-type-misma=
tch]
>           __BPF_DISPATCHER_UPDATE(d, new ?: &bpf_dispatcher_nop_func);
>                                      ~~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~
>   ./include/linux/bpf.h:1045:54: note: expanded from macro '__BPF_DISPATC=
HER_UPDATE'
>           __static_call_update((_d)->sc_key, (_d)->sc_tramp, (_new))
>                                                               ^~~~
>   1 error generated.
>
> The warning is pointing out that the type of new ('void *') and
> &bpf_dispatcher_nop_func are not compatible, which could have side
> effects coming out of a conditional operator due to promotion rules.
>
> Add the explicit cast to 'void *' to make it clear that this is
> expected, as __BPF_DISPATCHER_UPDATE() expands to a call to
> __static_call_update(), which expects a 'void *' as its final argument.
>
> Fixes: c86df29d11df ("bpf: Convert BPF_DISPATCHER to use static_call() (n=
ot ftrace)")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1755
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
