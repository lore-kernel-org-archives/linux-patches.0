Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054328;
	b=MdbGWpDofIJn0Epy2tOIzMu+jKeRkCzsNeRw+f5qoYq/lVK0kOaniQLksRlfP97HINBf
	 jf6DmAAmbiv5oGXCMSK+AjCCcLH69iyNbiceTAtNMS2J6BqtBiV8W2RX69MZWf2V6mwdX
	 SlgMFZ4Kd5uzXyW+gRDGtfKcXZcnGoeqfWnDnJuC3/sNeUdgZ5j+GidlBQ0a6LRHEpawC
	 HIW66XzC9Hhhf5bnT3E0/iKZG4QP4CQBAeRUE6XQay6En0+6IBSf0UKiFHsq3bzmdXBNw
	 YoyWcLQCngid6swk5EFKTmlmLlcFLavydy+Niz017zEE/qI7qmIrAL6VDcKO86H4Qkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LEkNvE5UIHhF6zvoaxsCoBY7wXs6ikZMokTR2YAsumE=;
	b=FN9t0NHB9Gdo49li3nblCAHPp5sze/MZC7tlZ6VtmXiHDsSl6XAumWJis/uUgzSk+Atb
	 DdPlCpu3hMRgOkDIOZrbw8BcVXZ7+t7tbMuUxriHSJwk5yqvOqYBSIdwWLTx0x5+WREgf
	 ymZ5inDrhItRDfmxutNYUNRbcMgbDLqeRMcw6tSRaJwswXr1pyaop1IJZ2FL9zXjs/GrW
	 7B4tKdYvfyQ3iVQO88nFIW+cYXV73PUZdo79MKjCk61VodizdqlBBAv7EYhwCCDH7D/tO
	 wkHrJ34kPS+T7v+2EW7cPoHYrlEtDcChdjueA4A4Tj6wDyQRaHAygdM5tzszIGXslzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8S27XAH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C076D606A320;
	Thu, 19 Nov 2026 02:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8S27XAH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF0F1F000C4;
	Thu, 19 Nov 2026 02:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054328;
	bh=LEkNvE5UIHhF6zvoaxsCoBY7wXs6ikZMokTR2YAsumE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8S27XAH4ZAGlhs2k+wJPtehrXFRVUkSSImfQMH1BaAYOkZJ9lVuDyfzBmerebMKR
	 oTMJTtTqycP0MFZHAB0z4fjOb6fAnoIVnawWyknNL13cL7SH9c8YsI6R4Q9zwghYwn
	 ZpqabhXrfRA7TmN2y1kspDUt8xFKs90R/RnQwkLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1235/2214] xfs: dont skip free extents of the longest length in a whole-AG FITRIM
Date: Wed, 18 Nov 2026 15:48:31 +0100
Message-ID: <20261118150101.146354198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99 ]

Since commit a66d636385d6 ("xfs: fix fstrim offset calculations"), the
by-length walk of an AG in FITRIM starts with
xfs_alloc_lookup_ge(cur, 0, pagf_longest) and walks down. The lookup
lands on the longest free extent with the lowest block number. The
other free extents of that length sort after it and are never
discarded.

Start every by-length batch with xfs_alloc_lookup_le() at restart_bno.

Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/r/ZgiJWxVcVwag0fIP@dread.disaster.area
Cc: stable@vger.kernel.org
Fixes: a66d636385d6 ("xfs: fix fstrim offset calculations")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted the change to xfs_trim_extents(), using agf_longest directly instead of the batched trim cursor ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 0191de8ce9ced..0bde81c6bb457 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -53,9 +53,10 @@ xfs_trim_extents(
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
 
 	/*
-	 * Look up the longest btree in the AGF and start with it.
+	 * Start at the last record of the longest length.
 	 */
-	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
+	error = xfs_alloc_lookup_le(cur, NULLAGBLOCK,
+				    be32_to_cpu(agf->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
-- 
2.53.0



