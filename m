Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209515;
	b=s6gvfL6UZfWXocKWVDOQyhNlAW4z/Y2ucHJtKPDzVj1Ptdss3PYuH1FhaKQHqKKdkJAa
	 fb1dGyOF/XsT+SloQj1qSsWBb6TqQGImuFwRUISGN4fk7Y+neeQqScTQbvsul1Q7npzSu
	 4WyCllSWJ5q9F6quPhZkmtP/7krU1K2GZwrCNcbzW6+BULroOGcbexSzSt6XKlUz1cvNm
	 0NnOatK51KChMfArgSJ9wCNYZV2LPb0FGGyW2R8B2BdVXAyfh/D8py1CJQs5a+JOpqQLV
	 U5lgJc5AWjhfzA903eQexw1cxVSjOxjNltcuYMzxevMbfuVMH9rUKpn8JPWQB2TPOOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=92+cOIIH9UuOypu1QIOrGJKraHwVWFmXB2HaQORaKcs=;
	b=kagqiUETWfILYv+TyH09t6v9BG9ScPWyO8FWCtd0FIoii0AhkyBls1EXvhWHofGdUaSz
	 jTpXdsI0IPuBsSNyKCH1NpddYHL5/a5EyKXgVdxHGBkNleUWyJ/+8siuVCJ8/bav7klvw
	 XWwUIhw5BDdYJ/32Ey+kTclVHHBeKxPn76tbIoDiJYJZujtZzowMHLbEUjr/vYYYUfdFa
	 rO5MoSwTFkFfEtXP5QS+ELnuAw1KB6yOJV5DF2Vdix5DCPKn/qzrPlwlEVEiZ9l+CsdNn
	 gXI4BIobH/+0r4GX4u4RL48plnsQEIiQQ+khaEvO0jpMEtHUunsOBbc+uxpoa6R8odQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlUNpgZ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF11606A31F;
	Wed, 28 Oct 2026 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlUNpgZ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A09E1F01825;
	Wed, 28 Oct 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209514;
	bh=92+cOIIH9UuOypu1QIOrGJKraHwVWFmXB2HaQORaKcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlUNpgZ9dCfx2/30ncsEIEIGmMFWrH1Su8nzPSAyCFHB2vHtx4sTiSk5HsyDbezZx
	 JaO2M2lx9ZbmzhZQli5zx+YaoiVGmUO/OtdZ2Mx9ctewnBgWPUE7cwH+TS+cT2lkUg
	 O20Dg6nod79fn+00oyYafweufolK7sYOhDO0w8CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 497/516] dm-integrity: fix infinite loop on discard with large tag size
Date: Wed, 28 Oct 2026 18:00:49 +0100
Message-ID: <20261028170015.252807478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context to match the discard handler without extra_space accounting ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c889457c3b330..c3801dc41d545 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1620,7 +1620,7 @@ static void integrity_metadata(struct work_struct *w)
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			sector_t bi_sector = dio->bio_details.bi_iter.bi_sector;
 			unsigned bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned max_blocks = max_size / ic->tag_size;
 			memset(checksums, DISCARD_FILLER, max_size);
 
-- 
2.53.0



