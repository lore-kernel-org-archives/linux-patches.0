Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1F73CE4B2;
	Thu, 17 Sep 2026 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671523; cv=none; b=BoJZqvCEnlBiX/R4GLLbKGJS+Hs00lIIGTswWvxalWARFr5Jv7tn0i2s7DQUel6JIFj0KmY2GdI5HOIO/Zesz5lUh/Np/71vg8AJo4NkybDbFPdhQCnN0R6hQ74Gf/t0BRM7xg6c7MesI1AANoKeGWMVu9Gd4rAqBfaUBT96taw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671523; c=relaxed/simple;
	bh=pSG+EUzLbFT6/jpojnoYnddQSMTG00Zy2Net0U747Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbtYwhHbLZmj1IbStImymQ/MTRgzLgBhF9AwcXdiYwwFMt7vWEzcmOzUL8uY5+HKduibVJBK5nmH4rTBvlIYXSkMzO77giQ8UNpVGnpllLLkUfapl8a1IS/FrVkYdF6X7mkApbQcaZ8GhbIx8xm+ERmRFM9I7d422yGC/AgLj0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIpoYKgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIpoYKgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAC51F000FF;
	Thu, 17 Sep 2026 18:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671521;
	bh=snxYKsuZDUHVEiykum7YX1VNl5y5U2lO/FuSskDAMLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YIpoYKgk10fSZv7s45JXUf8lm9Wnvkmlo4iDW57fNKFXVeYYIYYWyuAsmzlpV766h
	 wjzi4w6COpt4U2DTibR3EQNZMZPb+U8FUhHy5y5gEFtqiu5Sp1SefhQa2EXuL/aOA8
	 kMGfig65E+fe3IlG7qckczpd/sf4d8q2A8Ql/QKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1002/1102] x86/locking: Use sfence for wmb() if SSE is available
Date: Thu, 17 Sep 2026 16:15:45 +0100
Message-ID: <20260917151605.896788509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <me@ziyao.cc>

[ Upstream commit d824ed1307680dd482f607b0e707c575f70668c4 ]

When adding cc clobber to wmb()'s definition, the alternative()
condition to use sfence was incorrectly raised from X86_FEATURE_XMM to
X86_FEATURE_XMM2.

Restore the correct constraint for potential better performance on
machines without SSE2.

Fixes: bd922477d935 ("locking/x86: Add cc clobber for ADDL")
Signed-off-by: Yao Zi <me@ziyao.cc>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260801182953.15069-1-me@ziyao.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/barrier.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -17,7 +17,7 @@
 #define rmb() asm volatile(ALTERNATIVE("lock addl $0,-4(%%esp)", "lfence", \
 				       X86_FEATURE_XMM2) ::: "memory", "cc")
 #define wmb() asm volatile(ALTERNATIVE("lock addl $0,-4(%%esp)", "sfence", \
-				       X86_FEATURE_XMM2) ::: "memory", "cc")
+				       X86_FEATURE_XMM) ::: "memory", "cc")
 #else
 #define __mb()	asm volatile("mfence":::"memory")
 #define __rmb()	asm volatile("lfence":::"memory")


