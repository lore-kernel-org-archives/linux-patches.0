Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590915;
	b=MQnVhlLpB31uL3wkmgefAEFMDoyNBLGK7TeTDeNCwz4P37uvSgAozZdYhDOE51QXCekx
	 IOxquZSi6AF/U8DZIW+sFPQSerBIYhfeN3Xk3s+3N0UT4ogr5Y+9g1dvTdEj1/tPejHGN
	 XeFFHgTT1WW2+++ZP7AGOk+TpGlzjLjAvOf7tvrUJDUF+uCaCXgQwE2ghrWqeKGY4UTX9
	 TZZ3GpeJeBNZ5zegJyEwJUz8u2qR2fTi4BbKHV15U9xrBJddGc8JZLE5anJL4kvO+TCHg
	 WfJRwy84tzgz7gwecnfg1IdR8Fv290I2b0pU4oyBcsD3yKLmWad/RB7toebW56/+MKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5+MltuRJgNDtcCUyuV6IBVzMUN5HvfdVQXlPfeUYo1w=;
	b=xmTAu5qNegVGvfx5OUWiCAnfdyJxcnTtbrhP68JudzjVKYD2O5VproDA7GEW9liIP95b
	 AbKdL6BSVls94PGWPWHTO2FVrkVqfcFEoORXXEPhxBJRMpfOhvBcBZ62aowBVNsiDwvEe
	 /4DeK5SUU0ipq7Ea9xgiW4mNZGMGJxTymXtkOiR13wSQDyMITd1xmwNsLAQ4fRbjOr0eY
	 UMCGU6yXRuGXAwh/Ifnc7GQft5D7bfn4n3Q7nDGeAycKUAQxVls/Mr5U3qUZshNIHZKiV
	 95nJRQh3zVkCmidXyTiXGmTGYeHhChyLc3f+Kftqau9sjvK/caxDMslwX3rxOWPtFDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hazufoQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E75606E234;
	Fri, 13 Nov 2026 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hazufoQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617F81F000C5;
	Fri, 13 Nov 2026 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590914;
	bh=5+MltuRJgNDtcCUyuV6IBVzMUN5HvfdVQXlPfeUYo1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hazufoQ2Iedf2Pj3U+MOYOdCX2y6DEWL0QxfNEIPzHOVqvpkG8neGEmUcIXxiQzOt
	 3s/KqvA5kPHTCblmx4mKPgf1xX1SELSbsL4tmoeHDceAPs4iWYukX67dDfUaw5ULMN
	 EespyoFF8I1+sKvBg5sZUzWLOSGtTdlxjOv5bB3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/670] raid6: add missing vzeroupper to AVX-512 code
Date: Fri, 13 Nov 2026 10:43:45 -0500
Message-ID: <20261113153813.583436888@linuxfoundation.org>
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
index 9c3e822e1adf5..30956989e7d74 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -95,6 +95,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -154,6 +155,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -227,6 +229,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -311,6 +314,7 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -417,6 +421,7 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -550,6 +555,7 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			       "m" (q[d+128]), "m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
index fd9e15bf3f30f..c8a152d9ab6da 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -221,6 +221,7 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -363,6 +364,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0



