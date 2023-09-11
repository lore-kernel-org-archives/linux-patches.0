Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3380F11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F8FC433C7;
	Mon, 11 Sep 2023 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444377;
	bh=tJNTCdtpib/KK2gyg3XfEe3ucrvGenG0VB7lO13AOG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw/NTuJCy3gPK2w7LRh/qkUyzawe1QuK1HkWbRjovRAKl+Gr9WnYOiQ1TxVo8PM6M
	 lqo4CFVnrUGioi+uwMXU3gVfU9RIS4Tkblh0YTMsUs9regv1IzXy9uEpzCCd1QwKy/
	 u8zlkJIBxFqAxC2+BVWiL0plPotxGtzJpeVUp5AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.4 669/737] powerpc/ftrace: Fix dropping weak symbols with older toolchains
Date: Mon, 11 Sep 2023 15:48:48 +0200
Message-ID: <20230911134709.229009217@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

commit f6834c8c59a8e977a6f6e4f96c5d28dfa5db8430 upstream.

The minimum level of gcc supported for building the kernel is v5.1.
v5.x releases of gcc emitted a three instruction sequence for
-mprofile-kernel:
	mflr	r0
	std	r0, 16(r1)
	bl	_mcount

It is only with the v6.x releases that gcc started emitting the two
instruction sequence for -mprofile-kernel, omitting the second store
instruction.

With the older three instruction sequence, the actual ftrace location
can be the 5th instruction into a function. Update the allowed offset
for ftrace location from 12 to 16 to accommodate the same.

Cc: stable@vger.kernel.org
Fixes: 7af82ff90a2b06 ("powerpc/ftrace: Ignore weak functions")
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/7b265908a9461e38fc756ef9b569703860a80621.1687166935.git.naveen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ftrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index 91c049d51d0e..2edc6269b1a3 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -12,7 +12,7 @@
 
 /* Ignore unused weak functions which will have larger offsets */
 #ifdef CONFIG_MPROFILE_KERNEL
-#define FTRACE_MCOUNT_MAX_OFFSET	12
+#define FTRACE_MCOUNT_MAX_OFFSET	16
 #elif defined(CONFIG_PPC32)
 #define FTRACE_MCOUNT_MAX_OFFSET	8
 #endif
-- 
2.42.0



