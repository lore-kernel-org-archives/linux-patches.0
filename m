Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774867;
	b=49MrSFHGuciEDPBqhfEFI8Z/3WVIQh2saXKgmvuzkWMi92nyhPUPva5+u8fjfidLCbEA
	 ZGMROR4/wBKYeQaODS7Xh7kX/wo7n6eN8evMvuT32EgSDyRkkJjxN+j7WkjPB9ea5CW5L
	 djMUuyCEys8NE+EHCr8UcnYzvWkvEFDrPdyOhsYpt69qWGRu6EHF7kCD+t9ScCe0vUvD7
	 gnJDTao5bB5wg4+4S4lWcf7H54S49Uy2zW874XIFz4fEq/MGv/fh98m4OTT4ckJZID4G6
	 HebHgpzq2ykyzRqVae61t+iOTLYzMQ4UQI4jYuFhgD/ZjFpkFj8pJbplH8isbhCK48w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DiOtchl5mIwTg1LpclHyfbZrzhHuMobO0OEeyaX1LgY=;
	b=xabMMSgxRvVQCEC9tIO8cPrnEK58Lc3/ySlO29n+puF/JOYDCCWUbM2mXrf7RsWhb9FI
	 YQ1fX6VAySFp0CxU/XMBg6kbj9vAsmPfRcXPd8ADbc/Ui5cI5/GLMvpKHU/HXerVxzqoP
	 PnDIxZ5jRt6WZkj07GdUCk1ZCbJABfEmD3Db4I3rpaMLnKT5Q8LsJmgA94XzKFNvJ/ic2
	 EOLKlb1gPwEjAxM5GbZwaPPuPw/NQpRWCEYLPaIaE6xVnFXqou223GMByXDt/bw6xaX1J
	 t0pBHAQU9L4PC+cOAUOGFmS80t0rGALB0/PLLMhDSks1WJdp846t16DlJe+NjU7lPag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zVhL/oBL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A9B606A31A;
	Fri, 23 Oct 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zVhL/oBL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F9E1F01825;
	Fri, 23 Oct 2026 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774867;
	bh=DiOtchl5mIwTg1LpclHyfbZrzhHuMobO0OEeyaX1LgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zVhL/oBLQ5E/CgEEmkDGi7ecT4Vo5ADHCHwzwJbYObgPEurTcCx9bwELOQoUjHGEo
	 oqfCoXGs5lmH2I/Eb7KLapqGIKemv1InOmGjpcpCdUhq7QUK8ZK1250Qtx2FjQPCe0
	 sXheoX+PZBNb8T609U8rUuSexVyqzFJNPQ0/aBD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 186/242] dm-integrity: fix infinite loop on discard with large tag size
Date: Fri, 23 Oct 2026 18:40:28 +0200
Message-ID: <20261023163718.185774233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

From: Ben Cressey <ben@cressey.dev>

commit 18d80c77b4c7dd20699e81cedfbbff4e9d198f28 upstream.

When integrity_metadata handles a discard, it fills a buffer with
DISCARD_FILLER and writes it over the tags, max_blocks blocks at a
time. If the kmalloc fails, the buffer is the on-stack array
checksums_onstack and max_size is set to HASH_MAX_DIGESTSIZE. So if the
tag size is larger than HASH_MAX_DIGESTSIZE, max_blocks is zero, bi_size
is never decremented and the loop never terminates.

Fix this by using sizeof(checksums_onstack) as max_size. The array has
MAX_TAG_SIZE bytes since commit b93b6643e9b5 ("dm integrity: fix a
crash with unusually large tag size"), so max_blocks is at least 1.

Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1980,7 +1980,7 @@ static void integrity_metadata(struct wo
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 


