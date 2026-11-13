Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590913;
	b=qmV5qYI9LRevmBpZP8ZJ28A+rKu4FCo/1MgPsWyetLYJE82vuk418o10cFHYnfflHF20
	 KKpIleyHytbUDAuAeP/OwLhz6qAYXVfK1v05DmxU4AETrTFnwuH1GkwO22xbAPf1zs2bw
	 tXDoseC5Q6rGttS3j2GQeoelUbh+2abqTI1W/1qB3CzPVW6gv9y+jnOvTeVbQPH+hLVCF
	 QhGuRYVhgqNAoDoHyi4OyPTfL71O0+8FQXrjvPT0lpYlxikRDe1x92evx9wujSPhqpa5h
	 eJGWKD8HGEioAPbijTRtp72BPghQPPegYWL+mk+/dyGmENFJkKGMFBQhlgkXLSC1dKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O6fhS+PtcJXW66/KS64ZQqxFq6GI7ryJIKzaF6+o5wg=;
	b=5fF/Rv8KSOOFzv6LFh636II4s30/uQc+0/b9nY2wSN7tGgGSmB2ZrI6Unus4wQHWI+VF
	 yz5zGyXrgsuEUDHEIQ5SlXlez+AjrCRtLRCL/mj+h1Lxf8GubOYmDewfS6Xh6aGdxPHAz
	 17ctGd2HNpMd/4u6U8kMwl5ZO2PlZWyW78TRBbXcI6SXHj8Zfc/Zuc3Sor34FijqR94Ym
	 pFHmF3642/sOWiyARaAp4GPxLtcFK47ShpGl8XTMA4ar7ca9EXV8FX4I0KJOlyL9kirTg
	 7aSEuCrn6MWDClTb7YIzzfIiPysJ2As7V4T7RiKRfQIQj9/1YGXtK4Cutc4YjrSSpXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roQVJJrY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B54606E233;
	Fri, 13 Nov 2026 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roQVJJrY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E41F000C5;
	Fri, 13 Nov 2026 17:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590913;
	bh=O6fhS+PtcJXW66/KS64ZQqxFq6GI7ryJIKzaF6+o5wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roQVJJrYq/RjjMQlGfJr8PUK8QU9iEjgM67SymKSebhl4DBZQFFRUVn3aQWl9BVHS
	 rNmeYZFblSOKwt/keif33hUTpJ2RUb1NLMLZjY/QT9WnpspfQosWx89YhjoG/EDvZC
	 jpizB5nvvB8ZSKwMWoLVkGaxY8kmuywh/lj+zNJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/670] xor: add missing vzeroupper to AVX code
Date: Fri, 13 Nov 2026 10:43:44 -0500
Message-ID: <20261113153813.548838730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



