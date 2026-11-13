Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590032;
	b=oX8Ja6qwQ2VdDcSLVTTRBvDBUFJXEonJEhOPX51lA/CN427bBozcghunYYn2+5IIiH9p
	 D2LeQtNfP2gTWGEp62S8Nme6p5+BXgsqbPjxUhYiYuc3BkCy3CT2h6gfj6MuYTLDkwPWv
	 mxnjMEPpc4WoMTaGs2yxGh/MWSN8uzaqwLsYdQnPrVtavSHIJLxR243vl8tR/0MzNKR2h
	 8zj1qvALHfqFVFFhnHz9DAaGvaIYPAalAZQ6DVTnE6ifufXxgGNEjxjRs10/92Wts7OGk
	 +qfhYQT65w4h6s/6uTTSipwtHpOFqgtZATTZ/ylEZ2XtOREv4IQyCQOrNt5Gd+bhZ2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gol0KF5CmbnLCWTjl+pnvgrZi4ziYU1yOea/rvlmhLo=;
	b=bjupXuoxshZGCrAbatP4ybWe2K7QgrENWMvKBEq8SoLaI6uuh+xrhK253uG3Ail9gkwu
	 mmghszJYVSitW96qqWskgXxk2dYV4+4fYxTNgXrvOIGontoWm1AfIQcZ9cV1VOPI/Wwqv
	 mLiV0ZkQFPZ9hDdIDus03SK9knD8lalEkuG8foghmqrqKu7JwusY1cp1+Be0+EYmAnfUV
	 zK0GKeSPWGWMN02YarxdoDkClhqRMv/3Y3Oy4BxD69pH0pJhK25qQY0XjeKM3eYqYgDos
	 OfPbdG1BUgZF6HhHX0WjBYCVH7Lgu89cJOjzTzRkGtlyFuixK1vNMWcqrrI3REayoiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pn8m0iCa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6B360A380A;
	Fri, 13 Nov 2026 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pn8m0iCa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B8F1F000C5;
	Fri, 13 Nov 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590032;
	bh=Gol0KF5CmbnLCWTjl+pnvgrZi4ziYU1yOea/rvlmhLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pn8m0iCaZHF9nwcSHO36wFf5vxPj/FWXL4q9RLhVvNxsTRIoQiXTkP6NSosODYrv2
	 O6dK4w8ct9bSbzYm3W7VY8F1XXfc5CTpiE/7lDaYx17Bmk5FbsbXzgV99kzcwFrsCe
	 eriz2cWeHga/SM/NpeZqingXvo2ObGFDMXdhjqrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/686] xor: add missing vzeroupper to AVX code
Date: Fri, 13 Nov 2026 10:43:23 -0500
Message-ID: <20261113153823.288165695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 7b8fc26c40d6cf4c6751a045c9e42bbb7e78d81b upstream.

Since the AVX optimized XOR code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

(Backported to the old organization of the XOR code.)

Link: https://lore.kernel.org/20260831212248.213805-1-ebiggers@kernel.org
Fixes: ea4d26ae24e5 ("raid5: add AVX optimized RAID5 checksumming")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/xor_avx.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 7f81dd5897f41..c6450acd055d1 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -50,6 +50,7 @@ do { \
 		p1 = (unsigned long *)((uintptr_t)p1 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -81,6 +82,7 @@ do { \
 		p2 = (unsigned long *)((uintptr_t)p2 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -116,6 +118,7 @@ do { \
 		p3 = (unsigned long *)((uintptr_t)p3 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -155,6 +158,7 @@ do { \
 		p4 = (unsigned long *)((uintptr_t)p4 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0



