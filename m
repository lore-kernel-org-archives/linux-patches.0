Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774116;
	b=vHS+dady9M635cQKF0Vcs5GQ0o1pltbZTcfYjQZ2n4aAN31n1tZ6gO71stFncLsaAdwr
	 LgSXM/+HeP+JZTfSyQCoLDiSpvJMl2EshFMU5xnDpIclCHsOXscMQbABq54rH7gELJeBY
	 jdNV4wUkhghXddWe2PpsBtq5uwynYwyG0LF742IbhvR10sd84nzPl+Tn2zuNCnJBHSDI+
	 AC9WTokIc6wwGumrU4g3PH0tFCPd76OC+cNkBuR8XmrWRSeIIuqhRdjIYKk2PeelC27u6
	 eJ0+Eko/GqlTX92qpDVQyEKYQkEuWKn3wpEAYJOxBrkbtclxfaxO7YoUcTZDEjYt8qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=foIah3SE4jDNXCc7n58XsJa7wejYVi2uBD/gnx4/2Cs=;
	b=R3BPN/0oImRfytDGKwB0iCnJzwHqo3qC+kesUWoL5WZ91MVY59uywYYeZW1PkzeDxS6H
	 aQ6uSL0Kf2eiisklvH086ejPf+Les9QrfdxxufJ8isFI+MbGGdo0PvFCuMHLJ3lv1CutH
	 Y6Txq338LZBTRdyIr7BFto/z0ZGSTPNIdWDnXlbwVJvUZ6MGN0J0THddAmPsXmhPTNkc5
	 e/+iquxILslxwU3X8lEP5wMfuNJa93wsIxvzlxZ5ioDIQ9ynVggHiRogd8BGsUlOIa7hX
	 djXFz0bJCoWd3jUkVvRPzt0gZ0fmjOyz5Gy0h4U7E9SZvCUF18iMhIysaaQav8dfXzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6v0cvSO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC771606A31B;
	Fri, 23 Oct 2026 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6v0cvSO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8FF1F01825;
	Fri, 23 Oct 2026 16:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774115;
	bh=foIah3SE4jDNXCc7n58XsJa7wejYVi2uBD/gnx4/2Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6v0cvSOWiN7cQaAG19CO7eODeQCuv0+8pT5h1dt6x1TygYiaffkYUmNi0t8N+Mw0
	 h7Fi0d+o7DeuVdwRpD/ocRRE2WPRwAIBnqRU0NkA8bZE8peGh2LWQva7OLV3cTsuUW
	 I0/WQS6mbszuf8hmdMQ7j8L7WlNTEIVdhNq65MBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 125/193] dm-integrity: fix infinite loop on discard with large tag size
Date: Fri, 23 Oct 2026 18:36:42 +0200
Message-ID: <20261023163717.163446025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -1979,7 +1979,7 @@ static void integrity_metadata(struct wo
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 


