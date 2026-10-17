Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9023BB115;
	Sat, 17 Oct 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258154; cv=none; b=EWBQPpRGXc5HaiadpayziEmZqHmYBRE9a+/aDZV773QFpg17QRcyHFeufFQ1vy9QuWjRoOC3WSmPVigtgnmnvbBN10a5WKzhgws0xgdedFDsCmcLdWLtxG8AGY8Lq8BF6j0e5mry+7/KZYoOUu2WbUNv7o8JpPBLZyyBozCGwOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258154; c=relaxed/simple;
	bh=EdIT2Ji0WEpxQ4mwLOTpp1dAwv45FZZ2J/jpXalQcEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/OjqdIIyn2vMW8ULNtrhxoKPByOCCkBl4PehMYCq93WnEBux8RvubmW8SoRix42TxkwQOTnOzQXrhB1/o4JDJyCQC0BKp0Ajxz4R2UQsVXxy5vuNI8hGXQKmZXY5ZeK3JehL5I3eP1v0iLKzU4l/cyVrzOwbRsLLFJgbrW+22Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjKEvaEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjKEvaEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D901F000C4;
	Sat, 17 Oct 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258153;
	bh=NLIF7UKcvDXUTqmjNm5rMFguRE1z16Y2ZzJ5hXn5IxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjKEvaEPMND5w0GYLr/XAnT0iSFP3ADmElhTmotiUComRBvGXoMyFMAknlJpy3UvE
	 fW0BfzYDVokFRGo8+j+bfsti94hmt0Q+W1Gs8tPA8HSS1hF5Uq6kRCPr3G4Wk06M0m
	 lT8p5MKP0uTSqrb8zPKtmQPc1IxrhEAtzLZJ7U/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0789/1674] dm-verity: provide dma_alignment limit in io_hints
Date: Sat, 17 Oct 2026 17:51:01 +0200
Message-ID: <20261017160451.355790403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 09d1430896e38933470045408d7a350dac7d841b ]

Since Linux v6.1, some filesystems support submitting direct I/O that is
aligned to only dma_alignment instead of the logical_block_size
alignment that was required before.  I/O that is not aligned to the
logical_block_size is difficult to handle in device-mapper targets that
do cryptographic processing of data, as it makes the units of data that
are hashed or encrypted possibly be split across pages, creating rarely
used and rarely tested edge cases.

As such, dm-crypt and dm-integrity have already opted out of this by
setting dma_alignment to 'logical_block_size - 1'.

Although dm-verity does have code that handles these cases (or at least
is intended to do so), supporting direct I/O with such a low amount of
alignment is not really useful on dm-verity devices.  So, opt dm-verity
out of it too so that it's not necessary to handle these edge cases.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Stable-dep-of: 1071d560afb4 ("dm-stripe: fix a possible integer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 7e877c6adb2ea..bfd0e80bb9f3a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -997,6 +997,14 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		limits->physical_block_size = 1 << v->data_dev_block_bits;
 
 	blk_limits_io_min(limits, limits->logical_block_size);
+
+	/*
+	 * Similar to what dm-crypt does, opt dm-verity out of support for
+	 * direct I/O that is aligned to less than the traditional direct I/O
+	 * alignment requirement of logical_block_size.  This prevents dm-verity
+	 * data blocks from crossing pages, eliminating various edge cases.
+	 */
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static void verity_dtr(struct dm_target *ti)
-- 
2.53.0



