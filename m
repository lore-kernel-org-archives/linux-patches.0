Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCBB6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31392C433F1;
	Mon, 19 Dec 2022 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477787;
	bh=GqlCljcXYcLyLProTWx1L+qLCPI4QH6WP7FAKEXkoJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bapva+Jp7y4A9sy6VLJkNLO6qY5aVOguHvTwHqFAP7Ob4EheTh9pxJJIi5368s8Zf
	 pFbWsZ2nTbVUCn9NLehW5MztspaEdRZzzgKiB47yg0Z6oyELVEKI72uRukm2Vf141Q
	 3w3UJqvTR+7koBLSi2m5yNPMmF55aQ2SW3h87gbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 6.1 01/25] x86/vdso: Conditionally export __vdso_sgx_enter_enclave()
Date: Mon, 19 Dec 2022 20:22:40 +0100
Message-Id: <20221219182943.454694192@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 45be2ad007a9c6bea70249c4cf3e4905afe4caeb upstream.

Recently, ld.lld moved from '--undefined-version' to
'--no-undefined-version' as the default, which breaks building the vDSO
when CONFIG_X86_SGX is not set:

  ld.lld: error: version script assignment of 'LINUX_2.6' to symbol '__vdso_sgx_enter_enclave' failed: symbol not defined

__vdso_sgx_enter_enclave is only included in the vDSO when
CONFIG_X86_SGX is set. Only export it if it will be present in the final
object, which clears up the error.

Fixes: 8466436952017 ("x86/vdso: Implement a vDSO for Intel SGX enclave call")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1756
Link: https://lore.kernel.org/r/20221109000306.1407357-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/vdso/vdso.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/entry/vdso/vdso.lds.S
+++ b/arch/x86/entry/vdso/vdso.lds.S
@@ -27,7 +27,9 @@ VERSION {
 		__vdso_time;
 		clock_getres;
 		__vdso_clock_getres;
+#ifdef CONFIG_X86_SGX
 		__vdso_sgx_enter_enclave;
+#endif
 	local: *;
 	};
 }


