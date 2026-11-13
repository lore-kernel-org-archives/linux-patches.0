Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585784;
	b=V+rkPwwZj9k0YYbYOp45NyY9v5i2pSi1ToY8a0whnC4QvNWO5u+9SvMu1vy/CztdUK3D
	 23nB32WhEGkQVTtgS8zdWPU/5Qta6o0tMxdczVLcfBfEFB62CdcnklK4fP+zZRg8nyHGm
	 U5w3yh8AnTHePl/QVK4NsxS76VECO/bRaf00EdwjZ+0iKXvA65PZt+8PMEJQGLE6mFxeC
	 uka8U4M4l16F5EoLv1t8I6RJWN13NI+Ku6+m+Oac2mGbdWNX0orMEv9CJHJwCl9Rmxggf
	 nZ7akqyUp3SvyrMe2A0EI4K42tPZ0CkkPd6k+a9Nc/yjG8tPsABPZ7qy+pUtxjilGOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NMmkDUvh6R7Otp8J9cLOTMQVIv7DZcckspsq4LbAoZk=;
	b=x282Tfb8yLbkXaDAmLjb6kZNqjWGi4ZvJ4S3Y9Tg9QAsDMyCHgxmNyRuMpLAnlaPpC+I
	 6zFPN0C99aqgwNrsLyxuWtY4TJpi1sWA0dgC26/hhYAyxTxrJ82Tm8bjwJPaf8zyE5ETb
	 3vehBoPA4Qjc1Pmkc948Nl2tfqkGGqZXiZ95jRImyqIo/iSpzkvdE59QjCIYEUFwDejpH
	 IcLGplndthJ/ynXAtrNku4aqOsma7FbVVDERQ3zg9ubqNowxyfdTxVgebsNdC9VdUTdTI
	 oVdPS63h8ilvYWyd5Aq9VD5e/iDhuUUD+o2NXihSYmdKqqim7KU3w/6GauWk50UzP/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyFxDQkD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402F5606BA81;
	Fri, 13 Nov 2026 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyFxDQkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63D71F000C4;
	Fri, 13 Nov 2026 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585784;
	bh=NMmkDUvh6R7Otp8J9cLOTMQVIv7DZcckspsq4LbAoZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyFxDQkDkoUlVnYsSWqMf09kMT3/zJCtFFcVgZoqzdN/8HOWEoQhYPcit+89vaWUY
	 lzT/4VmH8+y50YML778orWIm5ydOfs3UHbLZRA6RSIKPLdGXWb+Dekatf2Q5EXIfnC
	 jGZRf6fddvzIaJIKExOgdtL782f6+9+mr2p/7JHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 321/507] mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
Date: Fri, 13 Nov 2026 10:50:25 -0500
Message-ID: <20261113153806.277541173@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7a81bc23dade8082187be6d9cc36e4be4b7207e2 ]

Commit 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
made holebegin and holelen unsigned before they are shifted, by casting
them to pgoff_t. That is an unsigned long: on a 32-bit kernel the cast
cuts off the upper half of the two loff_t values, so a hole which begins
at 4 GiB or beyond is taken for one in the first 4 GiB of the file.

truncate_pagecache() passes the new size of the file and asks for private
COWed pages to be unmapped as well. If a file of 6 GiB is truncated to
5 GiB, everything from 1 GiB on is unmapped, and what a process has
written to a private mapping of the range between 1 GiB and 5 GiB is
lost: it reads the contents of the file again.

Where the range has an end, the wrong range is unmapped instead of the
right one. The page cache copes with that, as it unmaps every folio that
it removes. The callers which only have unmap_mapping_range() to get
rid of user mappings do not, for example drm_vma_node_unmap(), whose fake
offsets reach beyond 4 GiB on 32-bit, and revoke_iomem() with physical
addresses of more than 32 bits.

Cast to u64 instead. Nothing changes for 64-bit kernels.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-36-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c2d3d8d94346d..e773d51f0d6fc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4594,8 +4594,8 @@ EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	pgoff_t hba = (pgoff_t)(holebegin) >> PAGE_SHIFT;
-	pgoff_t hlen = ((pgoff_t)(holelen) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hba = (u64)holebegin >> PAGE_SHIFT;
+	pgoff_t hlen = ((u64)holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {
-- 
2.53.0



