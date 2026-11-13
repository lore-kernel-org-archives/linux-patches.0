Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585919;
	b=i3FeaodALGeG8pz6l1kMAS6JLSf58Gpmftu+hvZZMm0XovKGlay5h3xAPD4YCkLptPng
	 DbAbk9LZh3xvpxPlntnGPNu+hOmwZ7qjl7Gy1v5AzUx56SI35s+tcWAGNZog0lPrv6Amc
	 v4LdQxRv9l/ccnIWogC/+vc/h5Bo82UfhaJ0t5+CXQQNFghhF2hvl89KBIBvSDpFHskpi
	 H6EtGUkL/Igq/H3Mh1ohFLOem5tZXcg0bp2PUtILN9o+YCeQexQfMggq+U54okgXSJAGV
	 yZtkXTFNCL/KP1f8RJp8OKNundf1MWomy/YGyfUCh72NGN/3oYxm5HA/UlUVQagTriA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UmxsZmBGJTYng4JOUf67p0MipAU3hwoyqlT26WA8cs4=;
	b=4rooEsJBUaP3wcMXEsJCPI6Lrt6Jeoo+fYpZA8fNC+I1zebphem7fWbJ7Ax8Ch3RVRpQ
	 WVye9dNnnVLqvSL6CXQdXOyXwBmEhjR49f6xAGtjgq4iW7tP94KWthknJgdY9c/Re+qfA
	 74eIldAw1f27jFtmsxmkF+pmNloaouR5WSuOXJl0Dza4EQ3TkZ27+FenMKNQU1VJk76Yk
	 +YArdbHU3kU8RAW+AVmd2vy3EOilu6hggU8pZLOj/NYjMnZ6YqKSv+YIeWc66QsDr4SnQ
	 1MQa70o1TSXSd9giluw//J6orGsPGlGiFcRU3kW5A5pLJhc82ocATbyH6Fp8Tb+gSaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBQ85y+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6288C6070225;
	Fri, 13 Nov 2026 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBQ85y+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FC31F000C4;
	Fri, 13 Nov 2026 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585918;
	bh=UmxsZmBGJTYng4JOUf67p0MipAU3hwoyqlT26WA8cs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBQ85y+LHSAXAL2MfzlMjpQ0rHtJSJ1LO/Dm955TnrBm+pPNQSdDqrxnMgsTpdTvS
	 S2XuP7wJHBsz7e54Hu1OeZ/gRUEpyG2iVjqdGlLwA3w/B9YPol10gSGLROX/nDX4mj
	 rMWwnHLDZSG4C7oULv0n61bvGdLTxg3pHFdlQG/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 480/507] f2fs: fix to avoid potential reference count leak in do_garbage_collect()
Date: Fri, 13 Nov 2026 10:53:04 -0500
Message-ID: <20261113153813.290894097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 894ca8b856668a82426dbd0a0042b61541a1a9ec ]

In do_garbage_collect(), we have reserved reference counts on summary cache
of all segments, once gc_thread encounter freezing, we need to release all
reference counts.

Cc: stable@kernel.org
Cc: Daeho Jeong <daehojeong@google.com>
Fixes: 02d91398a602 ("f2fs: fix to freeze GC and discard threads quickly")
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Used folio_put_refs(sum_folio, 2) instead of two f2fs_put_cache() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 738a5543f086a..6220d55709e9c 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1857,6 +1857,9 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 		if (block_end_segno > end_segno)
 			block_end_segno = end_segno;
 
+		if (unlikely(freezing(current)))
+			goto next_block;
+
 		if (is_cursec(sbi, GET_SEC_FROM_SEG(sbi, segno))) {
 			f2fs_err(sbi, "%s: segment %u is used by log",
 							__func__, segno);
@@ -1924,18 +1927,12 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 				sbi->next_victim_seg[gc_type] =
 					(cur_segno + 1 < sec_end_segno) ?
 					cur_segno + 1 : NULL_SEGNO;
-
-			if (unlikely(freezing(current))) {
-				folio_put_refs(sum_folio, 2);
-				goto stop;
-			}
 		}
 next_block:
 		folio_put_refs(sum_folio, 2);
 		segno = block_end_segno;
 	}
 
-stop:
 	if (submitted)
 		f2fs_submit_merged_write(sbi, data_type);
 
-- 
2.53.0



