Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C810786;
	Wed, 15 Feb 2023 18:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E63C4339E;
	Wed, 15 Feb 2023 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676486488;
	bh=fc+5seqhTO5BvvY3isnCsCZbytpHZYKbkp6X0pw+tz0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KwKxexKOjWpIM62ogFQODLQ1bQsNzLet37om+7MP+97xaJyIyy2vgnIwKvqGHgSum
	 AK1HlTcMi+AvC332r/QIwE+/49lsjRtJJSV4BIXQMrnonWfh+22HtMsqqs7j8kwYyW
	 w1EKs81R8h99F0BIHuSoZfDAmS6VE5JSMLdZ+IFrjA4FhQ/WlqFpzGOvDUzu4ZTqOq
	 FYLfMowZLmq29qGViyPSz7myGFzjL33q7gGLhZfuv3GDwHSYvo80FQH+P2N8ItH8t1
	 EkSsDc48uZakeV8iEsThXGc2ro9ZjG3icqKXOi2XHl4Nf9kwmXsGAq9DohtR+CUXdi
	 ndi0MW4G87mvA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 15 Feb 2023 11:41:17 -0700
Subject: [PATCH 3/3] powerpc: Allow CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 with
 ld.lld 15+
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230118-ppc64-elfv2-llvm-v1-3-b9e2ec9da11d@kernel.org>
References: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
In-Reply-To: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
To: mpe@ellerman.id.au
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, erhard_f@mailbox.org, 
 nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com, 
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1504; i=nathan@kernel.org;
 h=from:subject:message-id; bh=fc+5seqhTO5BvvY3isnCsCZbytpHZYKbkp6X0pw+tz0=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDMlv1UPn3nmjdiU36FOT54YGk9jbwdOfzrpwQ4Lldo2jh
 aTmydrijlIWBjEOBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjAR3mCG/xFvgraEdZq6CVXX
 CPptLaiNF2zQ335f/duS/6bbGRO9lRgZHkb0V30yMWtbK9nNreCq1Vi8e/3F+z8LMgqXK/R7Bzh
 zAwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 5017b4594672 ("powerpc/64: Option to build big-endian with ELFv2
ABI") restricted the ELFv2 ABI configuration such that it can only be
selected when linking with ld.bfd, due to lack of testing with LLVM.

ld.lld can link ELFv2 kernels without any issues; in fact, it is the
only ABI that ld.lld supports, as ELFv1 is not supported in ld.lld.

As this has not seen a ton of real world testing yet, be conservative
and only allow this option to be selected with the latest stable release
of LLVM (15.x) and newer.

While in the area, remove 'default n', as it is unnecessary to specify
it explicitly since all boolean/tristate configuration symbols default
to n.

Tested-by: "Erhard F." <erhard_f@mailbox.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b8c4ac56bddc..f9f13029c98a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -603,8 +603,7 @@ config PPC64_BIG_ENDIAN_ELF_ABI_V2
 	bool "Build big-endian kernel using ELF ABI V2 (EXPERIMENTAL)"
 	depends on PPC64 && CPU_BIG_ENDIAN
 	depends on CC_HAS_ELFV2
-	depends on LD_IS_BFD && LD_VERSION >= 22400
-	default n
+	depends on LD_VERSION >= 22400 || LLD_VERSION >= 150000
 	help
 	  This builds the kernel image using the "Power Architecture 64-Bit ELF
 	  V2 ABI Specification", which has a reduced stack overhead and faster

-- 
2.39.2

