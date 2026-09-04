Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E1B40F742;
	Fri,  4 Sep 2026 05:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498613; cv=none; b=GhSJveAzTBYNIO8u8NN/EUARZvI+cJPkrXov6q2NUWCralO0ezJWomW6nkkELx2NKx/kUHtGxqMB6MEs8SpikBe+32KSwGOXpsf9/3jmfb+B5llE50/zoRoaaVZ/0h//8UIjMja901mJGpN7vOprdQ26Iw2NYuSjD8RYikBPowA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498613; c=relaxed/simple;
	bh=cqkxCpDqcvXHXwle+bwFCynL+HK1Lh3NeesTN4cRsV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRrVGPXf2GuKPZ63PXruGbkFgsqbwPxjjsXSoru2zCv661Wj4QQwn6E6zudXh+NJNhUkzNuu2vOc3xKSZDOKMkCB5zZXdbGLDhXzmnUnsIC1Yp4t3CACQ5iIzeWMKLG2+B/rgn23IWvsqcvsG01PqAB4GSlojTFQaZJHkxkugOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEB9k2N7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEB9k2N7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134471F00A3D;
	Fri,  4 Sep 2026 05:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498612;
	bh=HuOU+16uBN1foWm+3QN/yGorup2xWML2ZiC0uiHBJeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEB9k2N7Z0E0yj8b1J4/22YYmcL0jNryRCnAgmP+6JSV06eQygPuQQO1+ipCA6WB0
	 P2RVC6Jo2Dv739jeOzfQ4UwDNgeApzm3IqywCY1b1Bqw+ZM2/f2s86SAwdPuFYPNyp
	 NKTRuIaO/h15kVsOxVw7NarR9a6VY3zbSRPm76ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.2 082/713] x86/locking: Use sfence for wmb() if SSE is available
Date: Fri,  4 Sep 2026 06:50:50 +0200
Message-ID: <20260904045805.677574287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Yao Zi <me@ziyao.cc>

commit d824ed1307680dd482f607b0e707c575f70668c4 upstream.

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


