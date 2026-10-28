Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208003;
	b=tsYG8sEezCceYIjnWuEvPrhANFWGE9AVDO2Yadfm8Sao/GN7Bg8ygO2qvbg/1/nU5aj8
	 hbp8YPMBY/9AjTc5n3QqSERtLGnLJ9R1cyZJRKXHtkeLtlCQGjNuDaLC1ucdUu9QJELpJ
	 cyyb6HHzpzWdNJreGq+PDc/AVqc+nkwnM6DdiMdoce6rtAL0w+ydxQb5siRkuTwGLrnsh
	 9lZ3TH2N1N/D5AzH86mJfFW2KkBUU8bAJ7lhbJE1Rl+8HWoxsjzgv8vQwLG11LMkM4hVY
	 EVh51xgAzretET73yZfhwpGnE/7supIF/27QMZkWt9taNUtQffSXLLyIDf03J1uEi/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=feo8msLtPohAxs3KDxDCDjKRpyvppnyQ+IPvwmiI2FE=;
	b=xGkZL2HJHZs+8x0vJ4tjNDEsuvczAyJWpzfJKIGfNRPbub7QiFnfCjMMi9mLC4wEiMxO
	 SZh/dfSqVFHQMWTq4bf8t2WXWIZcOXpREmanbEmJkK2ZX9XG4sDiBNdzUgTI5pPKCA1Q5
	 azDFWJkMifXzYoLAR1kkMvL0y4MsPZkv0dNRkaiqDF82BtAIjN6HMcliIiZHiot+pfBdL
	 yLr3Ik6AEvOtjMbjtWfBVjManLmL3BvLx1/HEcHlU5R1SqDRK4w3aD53RxFdk/C6pOEjR
	 T+oqNxLilFL+dhZaJTj4Tf7SlJ3cfU62CRyqGnuV0SYtSvbQ61reF6JCSHCj16h/GcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OdwIJEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE03606A31A;
	Wed, 28 Oct 2026 17:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OdwIJEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C781F01825;
	Wed, 28 Oct 2026 17:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208003;
	bh=feo8msLtPohAxs3KDxDCDjKRpyvppnyQ+IPvwmiI2FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OdwIJEZJKM77eSzECltlWG7B07zLTCUNbiFYzRLxW1oIoChlM8/RvIM8YUK+BLv/
	 gb9lJmDIR7ehCs/4+lPDy+zcMKiXzFkaIwV36uL7Xu2YQE/+M/4D7j5UCmREmRQrIU
	 D3QBjXGNx9v8q21urnUWRKQSHHKmw8kNY4ubdwdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 213/247] io_uring/napi: make stale entries time out after 60s
Date: Wed, 28 Oct 2026 18:00:16 +0100
Message-ID: <20261028165952.464575929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 9c151648780d89e5446e5f89f3fa2e416c3bb911 upstream.

With dynamic tracking a NAPI id that hasn't been seen for a minute is
meant to be dropped from the list the ring busy polls. The timeout is
added to jiffies, but it is defined as 60 * SEC_CONVERSION, and
SEC_CONVERSION isn't the number of jiffies in a second. It is the
internal factor of __timespec64_to_jiffies(), HZ scaled up by
SEC_JIFFIE_SC bits. For HZ=1000 that is 1000 << 22, which puts the
timeout at about eight years. On 32-bit the multiplication overflows.

So entries are never removed, and every id that a socket of the ring
ever had keeps being polled on each wait.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-33-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -6,7 +6,7 @@
 #ifdef CONFIG_NET_RX_BUSY_POLL
 
 /* Timeout for cleanout of stale entries. */
-#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
+#define NAPI_TIMEOUT		(60 * HZ)
 
 struct io_napi_entry {
 	unsigned int		napi_id;


