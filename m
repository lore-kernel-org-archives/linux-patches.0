Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6D8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD855C4339E;
	Fri, 10 Mar 2023 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460599;
	bh=3+zr4KghSO7/NmLxgCuQa9VerP/h6CsChqcNZQ5Cflw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XH/qMQL+tREnV7ZlD1DlVJdygNELOxQzsKb0H9iZSwlxQVzfPgE1pLuF8Y1ON6pd5
	 Le/R17ePzH3IUqLCexz2rrwuD2LJVZa8pqTE2l/fTK8t1BGbI/syEk5bk+EMxIoUYe
	 OfV8fo+AVd1i+OX8VAyNLaX7cczDFskzgiUvuNBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 389/529] dm flakey: fix logic when corrupting a bio
Date: Fri, 10 Mar 2023 14:38:52 +0100
Message-Id: <20230310133823.028000694@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

commit aa56b9b75996ff4c76a0a4181c2fa0206c3d91cc upstream.

If "corrupt_bio_byte" is set to corrupt reads and corrupt_bio_flags is
used, dm-flakey would erroneously return all writes as errors. Likewise,
if "corrupt_bio_byte" is set to corrupt writes, dm-flakey would return
errors for all reads.

Fix the logic so that if fc->corrupt_bio_byte is non-zero, dm-flakey
will not abort reads on writes with an error.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -359,9 +359,11 @@ static int flakey_map(struct dm_target *
 		/*
 		 * Corrupt matching writes.
 		 */
-		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == WRITE)) {
-			if (all_corrupt_bio_flags_match(bio, fc))
-				corrupt_bio_data(bio, fc);
+		if (fc->corrupt_bio_byte) {
+			if (fc->corrupt_bio_rw == WRITE) {
+				if (all_corrupt_bio_flags_match(bio, fc))
+					corrupt_bio_data(bio, fc);
+			}
 			goto map_bio;
 		}
 
@@ -387,13 +389,14 @@ static int flakey_end_io(struct dm_targe
 		return DM_ENDIO_DONE;
 
 	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
-		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
-		    all_corrupt_bio_flags_match(bio, fc)) {
-			/*
-			 * Corrupt successful matching READs while in down state.
-			 */
-			corrupt_bio_data(bio, fc);
-
+		if (fc->corrupt_bio_byte) {
+			if ((fc->corrupt_bio_rw == READ) &&
+			    all_corrupt_bio_flags_match(bio, fc)) {
+				/*
+				 * Corrupt successful matching READs while in down state.
+				 */
+				corrupt_bio_data(bio, fc);
+			}
 		} else if (!test_bit(DROP_WRITES, &fc->flags) &&
 			   !test_bit(ERROR_WRITES, &fc->flags)) {
 			/*


