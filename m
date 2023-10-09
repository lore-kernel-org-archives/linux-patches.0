Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42539182A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6s3VJz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE505C433C7;
	Mon,  9 Oct 2023 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858966;
	bh=TH9GiUwhCwqienXnyFTn+0OIFcCe+23sC10nwjYIvz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6s3VJz4EWQjh04mmHISsNu+9F/LvXiNEktyQPB9+m56p+zQTqyqAm4Q46bC7oIB7
	 TpAaSQg9GQwsDoL6HWrodWMfXof63LwzIq6Gs0ggx6o4CZQQ8ALc8kXp56SY+iQvoH
	 w1VsfVrUIaxbZMNvVe2dBtD0zkxDxoLJzQ6nqRXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
	Marcus Seyfarth <m.seyfarth@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5.10 157/226] bpf: Fix BTF_ID symbol generation collision in tools/
Date: Mon,  9 Oct 2023 15:01:58 +0200
Message-ID: <20231009130130.793985505@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Desaulniers <ndesaulniers@google.com>

commit c0bb9fb0e52a64601d38b3739b729d9138d4c8a1 upstream.

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
Co-developed-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/CAEf4Bzb5KQ2_LmhN769ifMeSJaWfebccUasQOfQKaOd0nQ51tw@mail.gmail.com/
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20230915-bpf_collision-v3-2-263fc519c21f@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/btf_ids.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -38,7 +38,7 @@ asm(							\
 	____BTF_ID(symbol)
 
 #define __ID(prefix) \
-	__PASTE(prefix, __COUNTER__)
+	__PASTE(__PASTE(prefix, __COUNTER__), __LINE__)
 
 /*
  * The BTF_ID defines unique symbol for each ID pointing


