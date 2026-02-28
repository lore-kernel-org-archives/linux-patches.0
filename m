Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DE5379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302054; cv=none; b=GwyoOKk4qlaicEQQKfZ1csUwBGxoesikPzLliIWdzaBwcOT85k91yVtcqePlxIOqmScGks9L7j8kchmg9FBN0+EGKtOAIf9MIzPeLCmbB3F0ZT6u+FTaEGKDdDdgnisVkRokM5LFV9YXF/oBiyhSOD1O+GvGoBnverWL8OxQJWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302054; c=relaxed/simple;
	bh=AFsmHi+SjGZ556fce6bgf+155Mtbq2PSSlyDILLPrjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnUs+mwe3ot9xskkQpY36zt/JxD/aiIPXXruyU6OoV3BSYLKINsQBR/HOK6sYKrkTkfdf2s4lH2iL+C/PvHOlRSHcRq6CbrZHOa0si3oFJ/Q0rhzIzmG/5MSR59t0F4wZUU6bxVR59H9BJRbQHRB/qTh9g7MZfQng0BuLyA05so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thH/xIt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thH/xIt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F18BC19423;
	Sat, 28 Feb 2026 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302054;
	bh=AFsmHi+SjGZ556fce6bgf+155Mtbq2PSSlyDILLPrjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thH/xIt0FN8cxNr2N9cYfJ+zCTFHAeT4EjxQ40s7aEbWtdUUBf0MTmY59eg1Gycfo
	 jmqWO0ETmqfeZ3R41vFDAXGj6fPyYUrn7V8+dvEeZKryi2pxyrN0MzgBhnbcSFu/p2
	 EXoQYtkdZ+TW4/9zJo+V43jKn6ecAiu3+rRT5qAebk73/c7nvvlImRUjkDx6MDC7X7
	 4g0tO03WkJQVs0xbTQAZKugFr6eWL+2VM18sBMsFZp1PS8J3aag/TpNM+3h+3Bx0tK
	 7PViG2YIzJTd1PjKawadYTXCdDI4PC2iTjci5IvA3s+/8ZM0t2t/qUsGSHxBFKBkZA
	 r1uTyC74koxRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/283] iomap: fix submission side handling of completion side errors
Date: Sat, 28 Feb 2026 13:02:51 -0500
Message-ID: <20260228180709.1583486-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 8158ab18e1ae8..ec6b019f087fd 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -381,9 +381,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
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

