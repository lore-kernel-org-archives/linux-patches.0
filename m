Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D083F2737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302307; cv=none; b=Ez5xVaWYgIG0fo1Zsf2qrU4/eRdGZf9LMgw4S3M/U0AE7V/UyHDS+zJ3l88m1u6GCnuSMSUSGvIR1KhxluU+Klo9thV0i/gkctq9+NgP6yYCrSuieKOcvSTOeCJTG89FJddjFedHmCQ0Gw2phRYul8xDx9K8ki360ZmFnEnz1YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302307; c=relaxed/simple;
	bh=eW4o98I7sEN89aJq4gHG8xMM3IjVoD4XtMqZCLvOH84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elEGU41ElTnUgrzwZFCKjAq6beHYgsTXEyrIFkdHv1DqOOjQj3vwVd2i+i0/GuFLzPn7a5Pkt/O10Fo8k9bJrSUDVi0u1sICyln3WFtYfpa1/uUFet8kWqw10C4hDLA0T9iVHLZkM20A+JOlNyuzAmi2O4joxPzfeEfBndW6n1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIk2y3yO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIk2y3yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136F9C19423;
	Sat, 28 Feb 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302307;
	bh=eW4o98I7sEN89aJq4gHG8xMM3IjVoD4XtMqZCLvOH84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIk2y3yOa/Pq4xd8elaw25020h1vtVD3T6IkliLw8rMsLhwXPxTMXv14oMpBH4OFI
	 ujBXmN4MyjFqaYyiJ9SMpYSpY2gtGsfGTormNYOayJGxanKkaIiuwtGmumo4yKNlST
	 8NLtGdT3t4P55S/+Cko49HJfPO696WJumoMlf9RaGGWc/vE730zoDhT0ec78XvA4sA
	 ffa56poNwGgFK1G/l22bts9rYQvz5Mo5skSSxuiENEQJoPpQYIRdBQB7q2ih91jNqz
	 b/KspUgoLswIK7L4JOPZJNQDjob60QRJz9vqPfoYCXA6cSsveaZVKmH3i97G61tkzu
	 AEwcgTwNIuYYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/232] iomap: fix submission side handling of completion side errors
Date: Sat, 28 Feb 2026 13:07:56 -0500
Message-ID: <20260228181127.1592657-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4ad357e39b2ecd5da7bcc7e840ee24d179593cd5 ]

The "if (dio->error)" in iomap_dio_bio_iter exists to stop submitting
more bios when a completion already return an error.  Commit cfe057f7db1f
("iomap_dio_actor(): fix iov_iter bugs") made it revert the iov by
"copied", which is very wrong given that we've already consumed that
range and submitted a bio for it.

Fixes: cfe057f7db1f ("iomap_dio_actor(): fix iov_iter bugs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 9acfc9e847cdc..69347b08116fd 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -306,9 +306,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS);
 	do {
 		size_t n;
-		if (dio->error) {
-			iov_iter_revert(dio->submit.iter, copied);
-			copied = ret = 0;
+
+		/*
+		 * If completions already occurred and reported errors, give up now and
+		 * don't bother submitting more bios.
+		 */
+		if (unlikely(data_race(dio->error))) {
+			ret = 0;
 			goto out;
 		}
 
-- 
2.51.0

