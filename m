Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9601BDEC
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8Cb4+Gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113FCC433C8;
	Wed,  4 Oct 2023 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444571;
	bh=K6jsXLU+zLNl4JX1kRYFLq9M5BoBjKpyY/jJJR21H+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8Cb4+Gx8qljzncH6jBlWXFYRUh/rngrnKC82tBv7dBNRaSUUC8IKrRzSSVVyVs2P
	 xw4BB8cYM+RFiUujys8c8ikM4Mk8zrvizDN2ODMgF1tNQdMS5roOEz8TDwHhqnTNaV
	 OGXxNTGC25Y1wA+8bvf2mSUHdbFLenPajwsBaUL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
	Marcus Seyfarth <m.seyfarth@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.5 297/321] bpf: Fix BTF_ID symbol generation collision
Date: Wed,  4 Oct 2023 19:57:22 +0200
Message-ID: <20231004175243.053802278@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 8f908db77782630c45ba29dac35c434b5ce0b730 upstream.

Marcus and Satya reported an issue where BTF_ID macro generates same
symbol in separate objects and that breaks final vmlinux link.

ld.lld: error: ld-temp.o <inline asm>:14577:1: symbol
'__BTF_ID__struct__cgroup__624' is already defined

This can be triggered under specific configs when __COUNTER__ happens to
be the same for the same symbol in two different translation units,
which is already quite unlikely to happen.

Add __LINE__ number suffix to make BTF_ID symbol more unique, which is
not a complete fix, but it would help for now and meanwhile we can work
on better solution as suggested by Andrii.

Cc: stable@vger.kernel.org
Reported-by: Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>
Reported-by: Marcus Seyfarth <m.seyfarth@gmail.com>
Closes: https://github.com/ClangBuiltLinux/linux/issues/1913
Debugged-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/bpf/CAEf4Bzb5KQ2_LmhN769ifMeSJaWfebccUasQOfQKaOd0nQ51tw@mail.gmail.com/
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230915-bpf_collision-v3-1-263fc519c21f@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/btf_ids.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -49,7 +49,7 @@ word							\
 	____BTF_ID(symbol, word)
 
 #define __ID(prefix) \
-	__PASTE(prefix, __COUNTER__)
+	__PASTE(__PASTE(prefix, __COUNTER__), __LINE__)
 
 /*
  * The BTF_ID defines unique symbol for each ID pointing


