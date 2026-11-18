Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046065;
	b=GbjPHVb9Y2oXXkHINYJJnPEpILlX0CCPUZ0oemeBjN+4QQmh/OnWm2659cMm2S+FVOm0
	 dLEidmpo3pKPxkVkfH+hjdTV2/vAjKjzgK7VShelLhSwTEUF++8KRg+rwKqY6rEv7l5uO
	 CMmON29qMG8FfvPwWpTJE0//2NuX5piwIObz6Fbcqb/vFYXj8pYCmKgar2z0WuB5xDPbk
	 5jp3lgI32MQcfZusfBG5V172MR5rFP1S0dJaTOpTKS1zIzKP8D5CRtTWdhBLv5YizfUUs
	 h6lCt8O9RGO6WDC1WvQmdx9D7I1cqucS8AR44IHcG5XWZzxNdNSjBpMLGijiGLVdklA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AeR9FujMP21eVWnoxMKeRT9Ya3sbZKR8L2pThByV74o=;
	b=czKhVqXbl8HzQSkgyr6ZLsBnBAV2aO3DaO9AfRuSwjxihLZQ38TjbG+P9N5SYdvAKmkm
	 EBqzz4p1isTtuazUq690046O0HRlvYdpqO1QrUE0Saftd7VB/An37vrXJ2oG/w1jSQ8pm
	 dSE6Yk95azSrEQkgRdKwIvI/CpJyeT8R/VbktuDTW+L07Vo+J8iHcjY9woWSJsuY/W/Tw
	 q3ltNT8H4H68MP4UNysdCqyozNr/TjtNlMCbhjav65pq0UltAIRKdRkWX9677Rrdow1cE
	 oSsdnAhnq0gG2rauNyOfQPzY4ej7klslakJANZY21KyZ8fFcv132XSL2IsazDVCxo3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoUV4WMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033BB60A2600;
	Wed, 18 Nov 2026 23:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoUV4WMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA061F000C5;
	Wed, 18 Nov 2026 23:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046064;
	bh=AeR9FujMP21eVWnoxMKeRT9Ya3sbZKR8L2pThByV74o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoUV4WMjWSIDkFCdaW7Ycki40FVuyMw+PRuaemQMBwnEPtk3Q9RAVMseUJvFQ8VdT
	 rKwUYMBJAMzz4HCF3OjHAYJUkK6EyVWUDH7xcQsvPsPJoemJyBfMWZ33dx7dRBmR2L
	 LiXiM5v+WuMkTENDdz1tvUbxHCgz/atij0KqXLN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1147/2857] xor: add missing vzeroupper to AVX code
Date: Wed, 18 Nov 2026 15:36:21 +0100
Message-ID: <20261118150242.883234941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



