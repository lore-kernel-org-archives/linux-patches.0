Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40F23537EF;
	Wed,  8 Apr 2026 18:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672909; cv=none; b=kb/R+5cJMUlEhsBANnshl/up+PrxjHivfuIZi+AFW9z0Rizu9jJjxIv9L2/pc00aVNP8ZNFdg9us1REWAD2Pb/+J3Y5HxyEq8Oe19qAOsfPD15PuVwCdQpb+fqQIopxZcaJg0pFe8YuQrq4ZLH8SalpJ9TsMaLO7sxp1aaqgt74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672909; c=relaxed/simple;
	bh=DOyHaR8UFlc5Cy18uHTvYXNBrN6eG+Z4nqnCypF1SOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/yTxjioQwjZ7FHbIAAPM36o1zJ4d9Pnl+JSsOWcsMwOISkxuVkOobv79o82HbuzmciuIKSoR1oKbKcUxWWFj1jnK91s7bBVdbR8JxLcdb/avAAsJ5Knj3RfyVn2FyAFQU1YrhOKmyW0/H1h3qmO9LsuSiO35pWDxIbQrimgGoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/VxJze/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/VxJze/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C2FC19421;
	Wed,  8 Apr 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672909;
	bh=DOyHaR8UFlc5Cy18uHTvYXNBrN6eG+Z4nqnCypF1SOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/VxJze/3lel/rNclnSsjEpninxQWBBxvE4VYoKHKo0Nmr57Dp7tF5r1vekq3lyd/
	 YKIJ6fEOd+2qEqT4/grxygPDffL70fhG4fnh6QqE+FEyG9DTu8Y90HglaagZrrUMTg
	 t+VdQfqAD4e3CvzobtzrvuAhHXb7ImvYvzomR+H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/277] crypto: deflate - fix spurious -ENOSPC
Date: Wed,  8 Apr 2026 20:00:12 +0200
Message-ID: <20260408175934.866073838@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6d89f743e57cb34e233a8217b394c7ee09abf225 ]

The code in deflate_decompress_one may erroneously return -ENOSPC even if
it didn't run out of output space. The error happens under this
condition:

- Suppose that there are two input pages, the compressed data fits into
  the first page and the zlib checksum is placed in the second page.

- The code iterates over the first page, decompresses the data and fully
  fills the destination buffer, zlib_inflate returns Z_OK becuse zlib
  hasn't seen the checksum yet.

- The outer do-while loop is iterated again, acomp_walk_next_src sets the
  input parameters to the second page containing the checksum.

- We go into the inner do-while loop, execute "dcur =
  acomp_walk_next_dst(&walk);". "dcur" is zero, so we break out of the
  loop and return -ENOSPC, despite the fact that the decompressed data
  fit into the destination buffer.

In order to fix this bug, this commit changes the logic when to report
the -ENOSPC error. We report the error if the destination buffer is empty
*and* if zlib_inflate didn't make any progress consuming the input
buffer. If zlib_inflate consumes the trailing checksum, we see that it
made progress and we will not return -ENOSPC.

Fixes: 08cabc7d3c86 ("crypto: deflate - Convert to acomp")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/deflate.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 21404515dc77e..fd388dad5d60b 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -163,18 +163,21 @@ static int deflate_decompress_one(struct acomp_req *req,
 
 		do {
 			unsigned int dcur;
+			unsigned long avail_in;
 
 			dcur = acomp_walk_next_dst(&walk);
-			if (!dcur) {
-				out_of_space = true;
-				break;
-			}
 
 			stream->avail_out = dcur;
 			stream->next_out = walk.dst.virt.addr;
+			avail_in = stream->avail_in;
 
 			ret = zlib_inflate(stream, Z_NO_FLUSH);
 
+			if (!dcur && avail_in == stream->avail_in) {
+				out_of_space = true;
+				break;
+			}
+
 			dcur -= stream->avail_out;
 			acomp_walk_done_dst(&walk, dcur);
 		} while (ret == Z_OK && stream->avail_in);
-- 
2.53.0



