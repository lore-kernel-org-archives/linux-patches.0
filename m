Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063358;
	b=tFXKgQNTiJ5bsRdBzlEQbD5N27U/uuGoLAFnU0glUqDV9Fum/rI9Reh/JTIxwWQg7B6x
	 +5lqsA97qAOxLgBwM18sPRtnADIuaj8eFRZjQKFV9VYwie6ossYXbzcFZc/aCOFW7L3vE
	 ufYbtkvnO3zTN8/0M6BsscdHk1dSTEW2VKmI2I0MNTE/XzjqI9C6KP16eRIl58WVOAPsR
	 scWaYyCqezwfosNT4eYnNHkHr1BA2uyQhZ3rU+TiHbUrhTP2HHRfoE1op2chHPXAIdGXY
	 ePMWu3JfGUKkj53fa/EYTqJ5JX1z5/975OVKuwb5Y8iNxj7jvLxQO/TA2effHSqp6gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWEIJuChYGoLJLH6PrNYwVKQ+4fEfyB6P9TmRNy/Q9A=;
	b=licX5s6KfLJkjx2aQRtqpvr4tUQxuFSOxhykVWEBdBjskHblmuwUHqjtDDK83hu2haQl
	 QyvhZ3Z0NFkPuN7Tcq7rHgTZA9eH7VmzKyB3GH+HpzwtW8taRlAUwiBKKgZpS4CFl9SP+
	 vitbSy6Yr3GO/CteOA22jZ3NiL3SgenF9vfJFNHl9K0H5AM7+VeUZEzROKLCMyiJn5gsT
	 EzVNfL3mIu9Y2xFTd5LYqAZBMB/9ix8ROR6C/YeEzRQFfMMyWr6I9ukYIM0pWP8WALaAs
	 P4rbuDy7zTDba870T6X02nPyWdueVj84TWSGHKZjhsGm0nGtS/QroFwD+mQX55T/3Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Za31+DnB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFD4606A336;
	Sat,  7 Nov 2026 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Za31+DnB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475851F0089F;
	Sat,  7 Nov 2026 14:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063358;
	bh=EWEIJuChYGoLJLH6PrNYwVKQ+4fEfyB6P9TmRNy/Q9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Za31+DnBwggyKtdyrDJWxwFYx+T6xN/ayOPW4/I12VN3KE7bPKLAkYuFUV3ql6210
	 uAYKrkYqjIsE/Ki5I+Bovd8cHYUjsDkqVsi8x9hMv+g152FUB6yuVN4jAw1epTJwfa
	 LGI7CQz4pf8mDDsfh5pkCYOAzUcv9YOmHpPQpKUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 537/869] lib: decompress_bunzip2: fix integer overflow in run-length decoding
Date: Sat,  7 Nov 2026 08:53:39 -0500
Message-ID: <20261107134911.644007068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit b822ad8d702df0be9fe3f24f71caeb0522d72319 ]

The RUNA/RUNB decoder in get_next_block() accumulates a run length into
the signed int t with no bound.  runPos doubles per symbol, so t grows as
at least 2^n-1 and reaches INT_MAX after 31 RUNA symbols.  The guard that
follows, dbufCount+t >= dbufSize, is itself a signed addition, and as the
kernel builds with -fno-strict-overflow it wraps negative once dbufCount
is nonzero, so the guard is skipped.  while (t--) dbuf[dbufCount++] = uc
then writes INT_MAX entries into a buffer holding at most 900000.  One
literal symbol ahead of the run is enough to make dbufCount nonzero.

Bound t to the block size as it is accumulated.  t only grows within a
run, so the value tested never exceeds the final run length; any stream
that decodes today satisfies dbufCount+t < dbufSize at the flush, hence t
< dbufSize throughout, and no such stream is rejected.  Because t grows as
at least 2^n-1 the bound trips by the 20th symbol, leaving runPos at most
2^19, so the following runPos <<= 1 cannot overflow either.

Link: https://lore.kernel.org/AS8P251MB00010FE5E38D253CF98A652AC8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_bunzip2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 4f98cdea7e0b3..b8fb40ed06d22 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -428,6 +428,10 @@ static int INIT get_next_block(struct bunzip_data *bd)
 			t += (runPos << nextSym);
 			/* +runPos if RUNA; +2*runPos if RUNB */
 
+			/* Bound the run so t and runPos cannot overflow. */
+			if (t >= dbufSize)
+				return RETVAL_DATA_ERROR;
+
 			runPos <<= 1;
 			continue;
 		}
-- 
2.53.0



