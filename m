Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062239;
	b=4Vofmribfya5NnWER38SxXMMZhwGTT7XgnuRFe1BQBCp4x3i+wtjgPHtnnIlEUHJEE1q
	 1TBv+Lnl7ACoh0qqH74PH5KqqYuOupUc5eHTa9I8OaiSq5msp75qnry4QtgeWUGUINbSj
	 hjviLr96YnR3IfCwvyblKV4/uSz9If2hGxFu07fh92C6xgiDBE4QWBUcZSp65p65tuAG6
	 B6D5wT8gj20LS3zXk8KhPBhPMBg0KwXTLrzo6ezXudcC+7PyUCRnivn3nEZvYRBetKixI
	 rPqIZFsOtxbgEb5OWPwzNb0i4F+VjK+o6v6UX35ndjSGFCcz+jgT3oeNmA1rIqWT2Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1Kh9A7xZKpWHliYuM7/eMSF+aJRacM6McCASL9Logb8=;
	b=JzdZ8jc56tjj7R9EFXMRgV3iniEcH9SXzABPLXr5m1coE3ywYcVQhbelveMnwnktj+w9
	 +GZeyXkAyKNCDbWOH4uZknk6PO2UcJ2+wJk5q4jRjUbkWmWcuRMaczIH0R3HhEaXsf6OE
	 izSbCfX99UVLTJtjUpqooSFmGPu4L4CnygW5sDcYV1wlGJORD9DY76wi/IZLqurJNeZlP
	 ytp3CLyBQ1CMOp2TwIDZLsGNg9LF6m8LEbc+UtRM76H7oJAD2p+RUaKN4ncO2xyZYzEmP
	 oxrisRTfw+DBPP0Nz+xhYRvfwLKyCR8s/a1WcMlZ3b1DD+YJzWpgVJfcuu8dhbCL2sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R25ShBbx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E207A606A320;
	Thu, 19 Nov 2026 04:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R25ShBbx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F29A1F000C4;
	Thu, 19 Nov 2026 04:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062238;
	bh=1Kh9A7xZKpWHliYuM7/eMSF+aJRacM6McCASL9Logb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R25ShBbx9K8oLqE5moWvFOZPs7noI+f9nqNbtBjk3iNTqDesIQtEAR9RCcDrwXY3A
	 1R4S78spiCjtdh7ZserWIfJpzER/mrSOfBq4KthQCrGm7WVQcEYwF06pQ4Doohh5mz
	 mfwFUnlVupAYxSds0UkDRWNd+WSJTPIvrmByAIN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 1839/1848] crypto: tcrypt - fix skcipher multi-buffer tests for 1420B blocks
Date: Wed, 18 Nov 2026 16:04:37 +0100
Message-ID: <20261118150036.571196113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geantă <horia.geanta@nxp.com>

commit 3ae88f676aa63366ffa9eebb8ae787c7e19f0c57 upstream.

Commit ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
mentions:
> power-of-2 block size. So let's add 1420 bytes explicitly, and round
> it up to the next blocksize multiple of the algo in question if it
> does not support 1420 byte blocks.
but misses updating skcipher multi-buffer tests.

Fix this by using the proper (rounded) input size.

Fixes: ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/tcrypt.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1148,7 +1148,7 @@ static void test_mb_skcipher_speed(const
 
 			if (bs > XBUFSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for buffer (%lu)\n",
-				       *b_size, XBUFSIZE * PAGE_SIZE);
+				       bs, XBUFSIZE * PAGE_SIZE);
 				goto out;
 			}
 
@@ -1201,8 +1201,7 @@ static void test_mb_skcipher_speed(const
 				memset(cur->xbuf[p], 0xff, k);
 
 				skcipher_request_set_crypt(cur->req, cur->sg,
-							   cur->sg, *b_size,
-							   iv);
+							   cur->sg, bs, iv);
 			}
 
 			if (secs) {


