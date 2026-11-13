Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590033;
	b=csocJT2SRa5AROYklpU7egpzJ+lE0ZoMZCsmOJYhxcSGHKbvphYn13J/VFI9Zx0uvfEw
	 h/QCBslkceLADO6jntr/MeHfdOOrJSL9yksTaVndeeycw86DY9uWtK2/LTwnhnz3dgzEi
	 RvL80+wwJKcZvBrm+abrS0XSsoJ3cEHKZaTjrHkKCgYrTKaRH4hU9sP1LBK88PWlhfm66
	 +OjTR77ckTi0j+ddQ8Fx77TxpSUr7bHKEbW6E7q2Lnd/6/nKSNH1Y3Yi4ctP3l5YQJ529
	 ysVsfyK2VX97chs3XnERNz4NuJfs5ioFDpoQW1XzCsD7XJxpwWOxi3QcUYb5z6zmYQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bpPtVuqnBnhzLEJv+r5f8IYUnQWT/DQNtEZib4pBNQs=;
	b=GQntF9HrG226AuuOdadiaNOLHeMvEU/8EI1ZBMm70XGH0+NivR4Y6TZgJ0ZOwPQ2+G6X
	 0NOFvLq4rRZhkFWZEmDT3SlgV2HbU4UZz34nDeUcSCtb8oMjxXr+0SjpF0Ca9nUpTTAXs
	 KHYICagd82B5v+fzDSk/KmrmqO+a7zpRElMAiO4fs074LqnQGjvZj+isM4MoMnjEST29b
	 xoWNfsUI09OP8QScaRJEnFznd73sRTJ4050ZutePsHXms4nD2YA2oeLWTvuUONC9CGUm7
	 XycGcmZexbG7ev1Kgcjz5erF3th7mOefxcbupytfo0cVliezv8L/KrTsp8zgyi5vnBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evLt2YJ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CDE60A6F61;
	Fri, 13 Nov 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evLt2YJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5081F000C5;
	Fri, 13 Nov 2026 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590033;
	bh=bpPtVuqnBnhzLEJv+r5f8IYUnQWT/DQNtEZib4pBNQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evLt2YJ3A34EMqT5WCYxl04fZdDsmlZ7AsbzsjX+PZA8I7FOaNZLtefi91YHmrwp0
	 iZe9WGS3/lSoSLhCFxC9UjEdD/kn6J1p+cK7b9kLbvns12dO7G8VG+VnAyqz0fRwPf
	 g5e+2v2oR+eoxUHrBO3QZ9FAXl61YOjh1AVv5qRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/686] raid6: add missing vzeroupper to AVX-512 code
Date: Fri, 13 Nov 2026 10:43:24 -0500
Message-ID: <20261113153823.317494859@linuxfoundation.org>
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

commit b82cf9e49c1be7cf1fd8e1bd806b0cdd25ab8127 upstream.

Since the AVX-512 optimized RAID6 code uses ZMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212316.213896-1-ebiggers@kernel.org
Fixes: e0a491c12968 ("lib/raid6: Add AVX512 optimized gen_syndrome functions")
Fixes: 13c520b2993c ("lib/raid6: Add AVX512 optimized recovery functions")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid6/avx512.c       | 6 ++++++
 lib/raid6/recov_avx512.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index 009bd0adeebf0..d989ca64847a5 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -93,6 +93,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -152,6 +153,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -225,6 +227,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -309,6 +312,7 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -415,6 +419,7 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -548,6 +553,7 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			       "m" (q[d+128]), "m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
index 7986120ca4442..32a9720be269d 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -219,6 +219,7 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -361,6 +362,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0



