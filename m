Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211918;
	b=cjHUCMm0mI7syklIoZJEcnHx1i+6d0pSIF+im3ADB4kx7RJMFJxTPDtlk/BHpZQDGvU8
	 JtElmu3nicUKJsyRkJD0wwY52p33ELDMgKftAUeNTGVVbF80kSOkvGff2AKWorOdHpRq6
	 ONpiuiilQOd9CMyXpiHDuFyhkA7u6T7lzYAyljl2yNSFXZgk0kAYi/FD169GooioEOyPe
	 T7WRZSohJhJQRhDZaUDDR7Kj2BWHUw87fmZArq49dLfExaumJwBSqw+UHV+PxrqenhBH3
	 RSdlX7O7y000Hn28z3cf81Rhi7Vkq10lC/ZDnVGdY6mIhFRx6mGFQULMAavEVsEU6pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xXQ1BpXiHaBe3LLraCrbv6zdtvQO/3Bo6OGUoATtRTk=;
	b=CRSBcp57z38BYhWS78x104kNhPumy5BzDSJgUzT4RTST8Hra74Ggi2GAAzcqU3ZuKcLR
	 LXyVO4+ICe/dOC0RyBKq4T3J5Xq4iwv3lNVhc3CcQ3R50lIldHpyW9Wz57rXE1qqFCgVG
	 gdDtXLR4jwvjrfAu//RYy1VOE0i3LgXW9g9odg1YVDkC6t353v3oBMpKlmSWz1pv2qlHN
	 7sFxLwZHmUZuJeQ3XzakZg8GQPb9b8IGLTRNEW0YaZPtO7JN3n8nSCEib5PMUczzyvWap
	 fZ6/Jrd7rvYq/ProN+bVv1QN+afYD3XnFvaSXokmEAycMssNWC0z58PdEdNSj7fbXuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=edilgnln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B72606A31E;
	Wed, 28 Oct 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=edilgnln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F551F01825;
	Wed, 28 Oct 2026 18:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211917;
	bh=xXQ1BpXiHaBe3LLraCrbv6zdtvQO/3Bo6OGUoATtRTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edilgnlndoXF3LemxWTGyjjz9l6X+Ky8zqHDXCFPLsiBugjvXHfPz5648Qw4IpHmz
	 OhRT7dqZIjMXjJb3H2rrU8Z4oXS1Un2nvB4rO3g46OT+3yp7CebSxWtCb4bAjE2ACF
	 aPGhpo7MzTunJUEXQTYzCRQadmT+LtO2kMqnDXxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 545/571] dm-integrity: fix infinite loop on discard with large tag size
Date: Wed, 28 Oct 2026 18:01:32 +0100
Message-ID: <20261028170020.968536883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

[ Upstream commit 18d80c77b4c7dd20699e81cedfbbff4e9d198f28 ]

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
[ sashal: Adjusted context for filler-only discard handling that calculates max_blocks without subtracting extra_space. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 7e8b5361c64c6..a3a223f096a3f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1725,7 +1725,7 @@ static void integrity_metadata(struct work_struct *w)
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			sector_t bi_sector = dio->bio_details.bi_iter.bi_sector;
 			unsigned bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned max_blocks = max_size / ic->tag_size;
 			memset(checksums, DISCARD_FILLER, max_size);
 
-- 
2.53.0



