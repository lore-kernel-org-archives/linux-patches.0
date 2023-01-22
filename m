Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2D87E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F64C433D2;
	Sun, 22 Jan 2023 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400225;
	bh=VBItf0BVoIqFJCVDG/J3cxr/q4AQ74/Ft/5P4TGHYRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/9solLDoajR0I2QPkPOIQHzf3jzwHvN5EvubJfVcQpD6pIdgJtzIKzw3Lo1MKjBl
	 Jo3h0Eex1Dpuwm7sXLgm3gp+sNe4oE3ffZ8anT6pvouN7ONhyuTMUEI6b50LupNluQ
	 LJHK7FF54VdPfqGMcZnTm2jnVTofwTYPPJp0AuUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YingChi Long <me@inclyc.cn>,
	Borislav Petkov <bp@suse.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 50/55] x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN
Date: Sun, 22 Jan 2023 16:04:37 +0100
Message-Id: <20230122150224.248841324@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YingChi Long <me@inclyc.cn>

commit 55228db2697c09abddcb9487c3d9fa5854a932cd upstream.

WG14 N2350 specifies that it is an undefined behavior to have type
definitions within offsetof", see

  https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2350.htm

This specification is also part of C23.

Therefore, replace the TYPE_ALIGN macro with the _Alignof builtin to
avoid undefined behavior. (_Alignof itself is C11 and the kernel is
built with -gnu11).

ISO C11 _Alignof is subtly different from the GNU C extension
__alignof__. Latter is the preferred alignment and _Alignof the
minimal alignment. For long long on x86 these are 8 and 4
respectively.

The macro TYPE_ALIGN's behavior matches _Alignof rather than
__alignof__.

  [ bp: Massage commit message. ]

Signed-off-by: YingChi Long <me@inclyc.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20220925153151.2467884-1-me@inclyc.cn
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/init.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -139,9 +139,6 @@ static void __init fpu__init_system_gene
 unsigned int fpu_kernel_xstate_size;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
-/* Get alignment of the TYPE. */
-#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
-
 /*
  * Enforce that 'MEMBER' is the last field of 'TYPE'.
  *
@@ -149,8 +146,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size
  * because that's how C aligns structs.
  */
 #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
-					   TYPE_ALIGN(TYPE)))
+	BUILD_BUG_ON(sizeof(TYPE) !=         \
+		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))
 
 /*
  * We append the 'struct fpu' to the task_struct:


