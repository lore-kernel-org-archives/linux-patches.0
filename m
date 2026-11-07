Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062402;
	b=J5kpLIdEos382Qxi4wW3gdBtUhKHhLkoK9zQHcP/FBJ5e7nsqp+BDGmgwX5tcO92XMTo
	 iCg80n5NVeSNNL9QkA4qCW1sVMVdCCd0O5eLNgWecAvIZS+Xd7Vaq1IiPY9UzYr824M5c
	 yOYFFc6ML59s0e2KUao/WhHr64fbCR8dU/zYIv8+86N7tpJVaxyAdqXVQUUUF15yKQr+A
	 sDPt/vGEkwQFH8hTuPvsQaKtitfDwsHXpHmx+vIyT4R5oM4oKsFyuESM3qjD+pKW5OTjR
	 V/FC3JEulRjyo/1Il12EYeAffJHk4kh8ElGK7nIu8NJNHvmBFH7b4J+X8RfU6B1TZ+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xt/OiDbN55zAO7cSiv6iaQfc3yN5IFWe/Vq3kpBSAcA=;
	b=yqzKi8FdfFx7LWYfQwLf/McHI7ly/8NBd/Kr2Lri4Qqko6DEcB8eGz0/exE34QeGYJs/
	 Au90FpCHu8Kms57peZDheFeO0ZRDdY93RSQUKrk2QR2pSUcXak4XlHrxuk+0swrHkNuxQ
	 gJcMeZA38V3gMDVUJff/Us+Ft3NbGk698GFqgqtTUNrDEMom+LOdDNgO3lVsThmypwmbq
	 okqrCbVm+mZ+JBUry3z7bBDelPVbL6jKbZvH43IfDfYDJNPeTHDjcWnjqhmgqcjCY2/qd
	 giN8b5v7fpeqwErYTcQ+HV568B0h0tbyQxfoJYsChofaqxt4wrqTVVPg6ZQetmYHKSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G+KNysM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8144A606EE96;
	Sat,  7 Nov 2026 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+KNysM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381121F0089F;
	Sat,  7 Nov 2026 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062402;
	bh=xt/OiDbN55zAO7cSiv6iaQfc3yN5IFWe/Vq3kpBSAcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+KNysM/FtttDXjF06s/+LoFs+insh/8e1CnPRvO/kHhFNBVys4a2aNJmDLg12LiY
	 95378F0ItVe9RPB2Xpv5uWHTltu0xxa4hzT+j8bzTAYcTwwjuqicKSLQSMArnJosvS
	 U8eVlzSIcLjnba5Ytl+ViDMqPmGyA40v4VgVXQ44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1281/1536] lib/decompress_bunzip2: fix off-by-one in run-length bounds check
Date: Sat,  7 Nov 2026 08:54:57 -0500
Message-ID: <20261107135033.758809825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit 69919be2b93ef3922f646729ff42b4bd9a30846b ]

The run-length path rejects a block when dbufCount+t equals dbufSize, but
the loop that follows writes exactly t bytes starting at dbufCount, so a
block that fills the buffer exactly is legal.  bzip2 allows it too: its
decompressor bounds a block at 100000 * blockSize100k and checks that
limit per byte appended.  Use > instead of >=.

bzip2's encoder stops filling a block 19 bytes early, so nothing it
produces ever reaches the limit and the bug stays hidden.  Compressors
that use the full block size do reach it: an lbzip2 -9 image whose block
ends on a run fails to decode, and a self-extracting kernel built that way
does not boot.

This code came from busybox, which fixed the same line in 2013 in commit
932e233a491b ("bunzip2: fix off-by-one check").

I ran into this because my system uses lbzip2 as /bin/bzip2 -- a common
thing on Gentoo I believe.  As far as I can tell, anyone using lbzip2
as their system bzip2 would run into this and it's only because it's
very uncommon these days to compress a kernel with bzip2 that no one
has noticed.  I only noticed because I was adding support for various
compression formats on alpha.

Link: https://lore.kernel.org/20260912-b4-bunzip2-blocksize-fix-v1-1-c7384bbfc954@gmail.com
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_bunzip2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index ca736166f1000..4f98cdea7e0b3 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -439,7 +439,7 @@ static int INIT get_next_block(struct bunzip_data *bd)
 		   array.) */
 		if (runPos) {
 			runPos = 0;
-			if (dbufCount+t >= dbufSize)
+			if (dbufCount+t > dbufSize)
 				return RETVAL_DATA_ERROR;
 
 			uc = symToByte[mtfSymbol[0]];
-- 
2.53.0



