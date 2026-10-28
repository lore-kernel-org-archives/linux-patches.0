Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207281;
	b=C6XmLM2ElznS51qQBKWFneTHSPliW709lsecLesuwXIFi3OyYTPC7/uGbLf8MR+aHV7X
	 oESHtIY//oqJPYUTTIno23R/REKos2khwrxhDYEfem2WPrKusKL0LIGzdtKFod+DuKs+V
	 /1KU6P+Ur4IJy9WHxiplJ9TmOcf47BMEs7SUOG5OiUZEvRdL3NwOfXHeUnNuf14OHgBBy
	 9EAb7ZzuSSeLeZJAEembjp7xRkDhhJKDGrLom+B11udpdOp9JosE2Tw3CLMORYvFmmK0M
	 berU1ucdTAEE+JXJoX1Ho7RFcxzPZsaxlXOB6+Js5RfRZJ+zAOzK4tNtpzesGntzUog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQvBIx4cYQ3RihdQ+9LCzNczFVX1cUxmEav0aw/O2OE=;
	b=1+5FU7aheKjaF+57wBlGmcJy6lbYglpjXBKWBmgmY7OzPdm5tQZ/al+UbpMQYcrjXW0n
	 X5BROPyXprQatirTSlmad9WiwXiR/GrrbaVC0MpaNYKtJhokFAn4VuF1SEAzX5SYZ8GaK
	 Ih8hCBuGQzoOt8TVEpiYRu+XZuOEslTvb/ZQ5KCdlL9DTM6Ag2kJddqafrRRw5KuiQnvF
	 3SLkmeyr9iBQ7L4J7l/hOed6Ip02dd9a7zdH/8k29YfoHYaOfSm4pHTjmNhliylXtQcJU
	 HsbvV5NMV3PELYxRUsQAYfdaES5dB+kfVVvu7wzA/jj8TA44qcThqS2RaDmzx6ObHag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nWHNu7oO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C9606A31E;
	Wed, 28 Oct 2026 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nWHNu7oO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F721F01825;
	Wed, 28 Oct 2026 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207280;
	bh=QQvBIx4cYQ3RihdQ+9LCzNczFVX1cUxmEav0aw/O2OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWHNu7oO2nKNI8/dfgowUfg1MKgednqEI3khMYpv/sVFAtQoG+Y+O8kKtRAWIM+ol
	 OrfvJy+XycdgavKgywZEW9UxaQnlY+aszZHFTTaxQhWpX6EKEDcXtphkL1HYlC6O+M
	 EVXSKDnm/r5kIvmVRizwkxI7K92gxXu4cnLD4vhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 49/88] io_uring/napi: make stale entries time out after 60s
Date: Wed, 28 Oct 2026 17:59:57 +0100
Message-ID: <20261028165943.267994179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


