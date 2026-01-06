Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56EE2D8777;
	Tue,  6 Jan 2026 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721269; cv=none; b=W1BiCIIxZVutl3XcFXc0B2nhbY4/Nrae3xih77C9Nzq0Q1yb6vSG2ADwkHX6mXxixRTg9RjSzChaqsVuwPAZXMJj4q109FqVVqdF1sFOvkjb5b45N+C9O/41OG3hOPwxOkDJ38OcWFYlDgezh6F7a657fPZUxvYyIVkVUaxmJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721269; c=relaxed/simple;
	bh=4J1zYQzlNpt88nmBAr2YpJmCyzD1bNNO3W/hHUZxWkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHnjjY8PeWxiNJHy5P7f7fET2E6Nn15/nmqErsoakqJmFOALnuF2siNJ4W00hZAocrJUPWgAplP3FvERYtImXId8zBcIQdCIoITC8YTnEtqky+8gqHbwaxCyD2es9IfE702m/X6cLuZVlS9d5wY4EMp1DRpuElroYbuJehg/1ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2IjDEC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2IjDEC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD3BC116C6;
	Tue,  6 Jan 2026 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721269;
	bh=4J1zYQzlNpt88nmBAr2YpJmCyzD1bNNO3W/hHUZxWkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2IjDEC5JjxgbQWMszkrsRBV5lUfy6Wmj0D1gOgc7jABLrZW6Hx3hONaSKxO9W9AY
	 MQUqmhIFHk57XXNUSvLzsZQME/eFPa7IRJ0QZAWvrATz4UVSULrEIE/m4LBFp4rV5Z
	 guIesckCJxYyrvrEmvbJF7sxQWLpYRbZ9nQQomIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 485/567] lib/crypto: riscv/chacha: Avoid s0/fp register
Date: Tue,  6 Jan 2026 18:04:27 +0100
Message-ID: <20260106170509.300061672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 43169328c7b4623b54b7713ec68479cebda5465f upstream.

In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
by reallocating KEY0 to t5. This makes stack traces available if e.g. a
crash happens in chacha_zvkb.

No frame pointer maintenance is otherwise required since this is a leaf
function.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Fixes: bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/crypto/chacha-riscv64-zvkb.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/riscv/crypto/chacha-riscv64-zvkb.S
+++ b/arch/riscv/crypto/chacha-riscv64-zvkb.S
@@ -60,7 +60,8 @@
 #define VL		t2
 #define STRIDE		t3
 #define NROUNDS		t4
-#define KEY0		s0
+#define KEY0		t5
+// Avoid s0/fp to allow for unwinding
 #define KEY1		s1
 #define KEY2		s2
 #define KEY3		s3
@@ -141,7 +142,6 @@ SYM_FUNC_START(chacha20_zvkb)
 	srli		LEN, LEN, 6	// Bytes to blocks
 
 	addi		sp, sp, -96
-	sd		s0, 0(sp)
 	sd		s1, 8(sp)
 	sd		s2, 16(sp)
 	sd		s3, 24(sp)
@@ -277,7 +277,6 @@ SYM_FUNC_START(chacha20_zvkb)
 	add		INP, INP, TMP
 	bnez		LEN, .Lblock_loop
 
-	ld		s0, 0(sp)
 	ld		s1, 8(sp)
 	ld		s2, 16(sp)
 	ld		s3, 24(sp)


