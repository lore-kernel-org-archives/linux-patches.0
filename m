Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB82E718B;
	Wed, 23 Sep 2026 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172926; cv=none; b=TpMbguhk/bOdcvfuWOM3hoITEyCGdzyym38fnZDKhg2DRszUY5+FFftChepJ1eu0E0YyLIzj+4vOjd3jsR6GXeKNsSIGZjCNBiO6oCQw7E0BUvW3JL0tFCZea2qwQFzxv5xexivQ9KiV0uRDPHN6U2EQY25kNBvdGp9TiXobW6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172926; c=relaxed/simple;
	bh=D6TTwe+dZRrTvq8e3w1PCaiZqjy2h02ad7MDoK3KTZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdHa0/YhlC6/nIDVtfmTeHrhcINNt+wNDSP0ryKJkxpiOeNx7owxoTvZSV6qghz5p0LkYGj0QppZ/7jyij5WmeO1TaNiXGhJREkocuLjA716lsRnthf1fbhcn4HfzHh2hVGzYPe9sxb+2MUzq0pCJ7ZTRnqi7nkM26HKk38w720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDlJ+gpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDlJ+gpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63241F00893;
	Wed, 23 Sep 2026 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172925;
	bh=lJvnJt6PN/yrSdeqJqHUFlFqE5CduW61JRnW5jZZbSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDlJ+gpWy0lnEqtpuG02rfBVyouA8AgM613Py7aU68zyhJ0d5bH2U1BRZ+QrmLeO5
	 ogwT/bNhQu4k5ztehfewbfBZAtmrgR72SBKTj3YiaAJJqwXS9puqWigtLUxBpc5A4V
	 RfEyP/duw9hrrWtJYwq4k5zR6j6rkZVnogsSXISI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 101/438] x86/div64: Fix addition of large constants in mul_u64_add_u64_div_u64()
Date: Wed, 23 Sep 2026 16:02:02 +0200
Message-ID: <20260923140647.395524690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit f65d38155aef069c897a64643a03db237dd1e0c8 ]

Adding constants over 2^31 fails to compile because the ADD instruction only
supports 32bit signed immediates.

Replace the "irm" constraint with "erm" so that the compiler loads large
constants into a register.

Found by a patch to drivers/iio/frequency/ad9910.c

  [ bp: Massage commit message. ]

Fixes: 6480241f31f5 ("lib: add mul_u64_add_u64_div_u64() and mul_u64_u64_div_u64_roundup()")
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Link: https://patch.msgid.link/20260803094702.3852-2-david.laight.linux@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/div64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/div64.h b/arch/x86/include/asm/div64.h
index 30fd06ede751c..8a2d343f977ec 100644
--- a/arch/x86/include/asm/div64.h
+++ b/arch/x86/include/asm/div64.h
@@ -111,7 +111,7 @@ static inline u64 mul_u64_add_u64_div_u64(u64 rax, u64 mul, u64 add, u64 div)
 
 	if (!statically_true(!add))
 		asm ("addq %[add], %[lo]; adcq $0, %[hi]" :
-			[lo] "+r" (rax), [hi] "+r" (rdx) : [add] "irm" (add));
+			[lo] "+r" (rax), [hi] "+r" (rdx) : [add] "erm" (add));
 
 	asm ("divq %[div]" : "+a" (rax), "+d" (rdx) : [div] "rm" (div));
 
-- 
2.53.0



