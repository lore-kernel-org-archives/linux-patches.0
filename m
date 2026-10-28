Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210273;
	b=JXeRXVulUHl30q++p11wrhubDqkyTSvFiAa/OMmnws8CAOCxTZWGBkgl3nnId+crDEBX
	 ws7uL467L0luTgVsOlD0R/WwrvGp4dhWt54PhCwLe1qZQWbxKILeI2bB7IS/octLH6/gi
	 B9noOz68aWkFIsW6saTMMgCXxrog7YjBKjk0PbTdh7gT2O2iV4LpyxFL3We0KP0AL0LEr
	 C++xkq9n1ZeyuPCZQ90SVcbnNjgj5moUK5tEvJe01Mil2a+JAQCp7o/f6lbnhze2/mYkc
	 9GlNi1xTJOnq6vHWKx+QXK4M/mTUmdIqc+7S0FNFChJzzka8G6JIbcilxcoRMg48M6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JZ4Ol55NXojn/n2i+skZNv6G3/G5k0YX706eyd5lNpY=;
	b=1x71sNk8MMtwdHj7OG0sgvI+8PPygL1K4suk45pKZQmd/lzF4gDNuMf5XJ8imKvvxkoR
	 wL6mx8Jtz6gy3tsWv21XloHdBH4eHp1qVEHP6NVi7oup7OoUS4hF1yb+iZpH1mlUAOI2C
	 HTCSl/Kz5qi7Rf4S4ojHd4wOtBcRl5zDp4kYu2e7yhtP3C3ugpTJo9gtuDSwfWm0A73T0
	 /JGHN0Y3O5//Tnvq53mxZ0CSCtRYwvPJaklZb4EcALZWZCEBSgsOy81/RouJhFNQt2CKE
	 Cx1r49eGljHzkG6CgvMO+2Nnke1D9flZ+fnKomqDXT2U56+TGO4R6PjvyrjtR4Hgdfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrQJzaH+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00577606A31A;
	Wed, 28 Oct 2026 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrQJzaH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084AE1F01825;
	Wed, 28 Oct 2026 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210272;
	bh=JZ4Ol55NXojn/n2i+skZNv6G3/G5k0YX706eyd5lNpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrQJzaH+FpD+xFE+Go/6gj1qlggLFF6zRb0EAfXlBEhACNFMdbav8+els88GXOBTS
	 N1KzWSWb+1MEAR1vVHay1kNKU7JHp848uOXAtHHpfYXqG4egvgMMvnf1Xgk170vkTs
	 IyzUI4O2xc4x26uOmh6bZ8U1deO8Ip8VHlZzuQ2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 136/168] io_uring/cancel: recognize "no timeout" on 32-bit
Date: Wed, 28 Oct 2026 18:01:12 +0100
Message-ID: <20261028165946.302711323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 3774e4d4c8533da2caae95556c4d635c7c4f45b8 upstream.

IORING_REGISTER_SYNC_CANCEL waits without a limit if both fields of
io_uring_sync_cancel_reg::timeout are -1. io_sync_cancel() compares them
with -1UL. They are of type long long. With a long of 32 bits -1UL is
4294967295, which is what it stays when it is converted for the
comparison, and the fields are never equal to it.

So { -1, -1 } is taken for a timeout. ktime_set() takes the nanoseconds as
an unsigned long, so what becomes of it is -1s + 4294967295ns = 3.29s.

If the request is being run by io-wq and can't be interrupted, the call
returns -ETIME after that time, rather than waiting for the request to be
gone. On i386, with a buffered read from a null_blk device that takes 4s
to complete a request, IOSQE_ASYNC, that is what each call does.

Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-17-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -308,7 +308,7 @@ int io_sync_cancel(struct io_ring_ctx *c
 	if (ret != -EALREADY)
 		goto out;
 
-	if (sc.timeout.tv_sec != -1UL || sc.timeout.tv_nsec != -1UL) {
+	if (sc.timeout.tv_sec != -1 || sc.timeout.tv_nsec != -1) {
 		struct timespec64 ts = {
 			.tv_sec		= sc.timeout.tv_sec,
 			.tv_nsec	= sc.timeout.tv_nsec


