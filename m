Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE54BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D739C433D2;
	Tue,  7 Mar 2023 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211899;
	bh=/oqOi06+9R0m0sOyym3nL8rA/F+pfMizr+RHSktR8Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+I9W42ycpYwKZYrL03Mj0NdPKAhi+8BkPHrxTJXcuALFMp3lHgc+XEqHuQKiEh2B
	 pFfxuIzrU1ofjywiJRCip5vDS8wSZ7di0PaFPj4eBzgd5SGZ7ULrDXXkDDkL3EXfdS
	 nlbxNBbLG77RD/0PMxZIUA67w8EVlgZqxflm4eS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Anders Roxell <anders.roxell@linaro.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	=?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: [PATCH 6.1 003/885] powerpc/mm: Rearrange if-else block to avoid clang warning
Date: Tue,  7 Mar 2023 17:48:57 +0100
Message-Id: <20230307170001.772904194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anders Roxell <anders.roxell@linaro.org>

commit d78c8e32890ef7eca79ffd67c96022c7f9d8cce4 upstream.

Clang warns:

  arch/powerpc/mm/book3s64/radix_tlb.c:1191:23: error: variable 'hstart' is uninitialized when used here
    __tlbiel_va_range(hstart, hend, pid,
                      ^~~~~~
  arch/powerpc/mm/book3s64/radix_tlb.c:1191:31: error: variable 'hend' is uninitialized when used here
    __tlbiel_va_range(hstart, hend, pid,
                              ^~~~

Rework the 'if (IS_ENABLE(CONFIG_TRANSPARENT_HUGEPAGE))' so hstart/hend
is always initialized to silence the warnings. That will also simplify
the 'else' path. Clang is getting confused with these warnings, but the
warnings is a false-positive.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220810114318.3220630-1-anders.roxell@linaro.org
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/book3s64/radix_tlb.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -1179,15 +1179,12 @@ static inline void __radix__flush_tlb_ra
 			}
 		}
 	} else {
-		bool hflush = false;
+		bool hflush;
 		unsigned long hstart, hend;
 
-		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-			hstart = (start + PMD_SIZE - 1) & PMD_MASK;
-			hend = end & PMD_MASK;
-			if (hstart < hend)
-				hflush = true;
-		}
+		hstart = (start + PMD_SIZE - 1) & PMD_MASK;
+		hend = end & PMD_MASK;
+		hflush = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hstart < hend;
 
 		if (type == FLUSH_TYPE_LOCAL) {
 			asm volatile("ptesync": : :"memory");


