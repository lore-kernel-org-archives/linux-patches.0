Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826862;
	b=ScB3ppUCJsGj4ej8eQLoYOZenZOyAUgMuA6xTS9it+zYwsLqeTI+iaagHd3h2CM3eJv6
	 BbZ2iTXAQDm/Q+V/QmWI1tt7/b2w2T4t1PgKKa7zOaHP59In/MzGoeteQMwoYlf7B4w0P
	 FEpVbsttfG8N6QCYYRP1Zjt/Ev4Rma7LYj2f5zAk5yMTz4x6SJFUTX/NcZcG0y6xF5jqk
	 NvKtDBXM4IB5JwTkQbRhdHFiaHbsY1Cj/OjuRWTdc6r0HjTTG11HcrnMHbwAGDYkvlUud
	 OswAFMna1QOtgT6cI2loU9KrBGtzouEaTQabBm+o9FCPB0pajt3panSZtj10rNL2+ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3AMP8Iv/nYpVwPk6pGXW8REsDT1rmNz1bh3/DrAK8M4=;
	b=VYGv+pnhtf6lBVfU9oGJEog+ZynCBm3wl1IYi8vXDcTNVXIdzpDeWtIAZjkkzsuHw+cA
	 8hk6htziczlWcQ9jOqZCNOBAcMPAn1rJYOzjeWVcrMmvfv/UwGejqOgUKnWyGqSy2mMjH
	 flaT1MwBR3LCLB3y+9/P5YdeZsnYzUQyDTAaMsQvEiQ/rPaa8cwIWUzQs0BWbQdM1cg8w
	 FHl1sTLiKdn8CdRmUDZ7m22BWEuAamrnrhfRlMf7ll9k3Vew07fC/JNa14GIo9gHX3tIu
	 ABtQ9rvZ1NbQ4MVmd7eeU/IKSiE4QRKBS1wxOrpXgndxzS3ppUYa5XN2twD1fWoQMOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1DzbSLk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA265607E4A3;
	Wed,  4 Nov 2026 21:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1DzbSLk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5EF1F000C1;
	Wed,  4 Nov 2026 21:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826861;
	bh=3AMP8Iv/nYpVwPk6pGXW8REsDT1rmNz1bh3/DrAK8M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1DzbSLk34HFn7tvVlhh+rhkqecgj9OffvOhum0/RZ1TMSBgMxuCBLZUET3jlY4PF
	 3tw9OH0rxBijbrEUwrw+EI9cQexjOdpVKFIOIy9KNWlPyUHsP9pHg3TO2Z4Px1waLu
	 C6z36pfoJAer2fctDWz+l+HCWD9AQW8wxvLCHppU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 049/547] io_uring/napi: make stale entries time out after 60s
Date: Wed,  4 Nov 2026 16:03:53 -0500
Message-ID: <20261104211039.700597337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 9c151648780d89e5446e5f89f3fa2e416c3bb911 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index ca1c814fa73a2..53d7623e4d237 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -6,7 +6,7 @@
 #ifdef CONFIG_NET_RX_BUSY_POLL
 
 /* Timeout for cleanout of stale entries. */
-#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
+#define NAPI_TIMEOUT		(60 * HZ)
 
 struct io_napi_entry {
 	unsigned int		napi_id;
-- 
2.53.0



