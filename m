Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17904171B9
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D19EC433D2;
	Mon, 15 May 2023 18:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173811;
	bh=eQeUBEaL5/zW4xe+2292h+XlbbcBEnT82e20PvOmD0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utrCgmZ4YQarZcgznoR4HSYelnzD4CBdI/ct1aJalm+MAUbSvyOi7Ne8q2d9+h1Mn
	 6Y89tEaTpIZmOfWji8lL54Y3XLbTBRc8ni5owOD7tMmN5L7D5trk+qK7tcaNXMT7PO
	 yO+FiXa1g2gyRBN/atEm8H9Qb6NyWivxXFWwVcJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Akilesh Kailash <akailash@google.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/282] dm verity: skip redundant verity_handle_err() on I/O errors
Date: Mon, 15 May 2023 18:29:53 +0200
Message-Id: <20230515161728.683443066@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akilesh Kailash <akailash@google.com>

[ Upstream commit 2c0468e054c0adb660ac055fc396622ec7235df9 ]

Without FEC, dm-verity won't call verity_handle_err() when I/O fails,
but with FEC enabled, it currently does even if an I/O error has
occurred.

If there is an I/O error and FEC correction fails, return the error
instead of calling verity_handle_err() again.

Suggested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Akilesh Kailash <akailash@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Stable-dep-of: e8c5d45f82ce ("dm verity: fix error handling for check_at_most_once on FEC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-target.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 9dcdf34b7e32d..aad0018cc7b2d 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -471,6 +471,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 	struct bvec_iter start;
 	unsigned b;
 	struct crypto_wait wait;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
@@ -525,9 +526,17 @@ static int verity_verify_io(struct dm_verity_io *io)
 		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
 					   cur_block, NULL, &start) == 0)
 			continue;
-		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-					   cur_block))
-			return -EIO;
+		else {
+			if (bio->bi_status) {
+				/*
+				 * Error correction failed; Just return error
+				 */
+				return -EIO;
+			}
+			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
+					      cur_block))
+				return -EIO;
+		}
 	}
 
 	return 0;
-- 
2.39.2



