Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76653AA187;
	Thu, 30 Jul 2026 15:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425015; cv=none; b=XgxYejiR1GrHxa5ovE8G4yI84FxNFzS4hVOXzKp9omtFvzp0C3At8lg6qLr8PbR+miy2jKdAW4O5eUac9/pv3IFDiljf0NUZETww5OhuKbRhironpC6egTsJgBceVGz3Pt3o2aJxjmRHITnb/Unm76WgqTBrmT3v6PRSWrshBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425015; c=relaxed/simple;
	bh=vzjib6qZHptAWAZC+PljQT6O/Ax9hU0oZGjAkKCH5UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr1qs/nwhDa3GRA1K2RdfYPOUII1NUVofnuwMCJ6EbKcGiTQDtQZVvnGPyw3L4TLFoUqEZJ+zD8gZXIYvavkymA70sgZhj3QQLf63aWPEHgzeuarApwvktiU4mBg+tk8/3NuY9Lhgmyk6jqw+N/rqbpfmzDBgPjvBtfkll+SA+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXShxozY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXShxozY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8BA1F000E9;
	Thu, 30 Jul 2026 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425013;
	bh=rGuWM9sIw/Zxo71hPtTYexow90XAed1GhAazsrRT6Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXShxozY6L/HJuAmfhIrNTJR2wkEi3CDEFx3ROrFhaaUR+91EypQP2Gq4SOSn0wow
	 bhpFgcOmff7msVQBZEUiYc1+fMiqYYXeDBWOmlLnEWoA3/AvT+uZvH8FCRHuYfwaQc
	 ysDdLHJpCVPQhbbUf/oR9uEgMV9EiiaGx0Z4uQOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 594/675] dm-verity-fec: replace {MAX,MIN}_RSN with {MIN,MAX}_ROOTS
Date: Thu, 30 Jul 2026 16:15:24 +0200
Message-ID: <20260730141457.745434527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 82fbd6a3e29a329d439690cd7ccc4162c9cd8db6 upstream.

Every time DM_VERITY_FEC_{MAX,MIN}_RSN are used, they are subtracted
from DM_VERITY_FEC_RSM to get the bounds on the number of roots.
Therefore, replace these with {MIN,MAX}_ROOTS constants which are more
directly useful.  (Note the inversion, where MAX_RSN maps to MIN_ROOTS
and MIN_RSN maps to MAX_ROOTS.)  No functional change.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.c | 6 +++---
 drivers/md/dm-verity-fec.h | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index a8fbf97b97517f..cebcc8fd25d700 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -87,7 +87,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
-	uint16_t par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
 	u8 *par, *block;
 	u64 parity_block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
@@ -605,8 +605,8 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 
 	} else if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_ROOTS)) {
 		if (sscanf(arg_value, "%hhu%c", &num_c, &dummy) != 1 || !num_c ||
-		    num_c < (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MAX_RSN) ||
-		    num_c > (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN)) {
+		    num_c < DM_VERITY_FEC_MIN_ROOTS ||
+		    num_c > DM_VERITY_FEC_MAX_ROOTS) {
 			ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
 			return -EINVAL;
 		}
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 90a0af3f35d31a..b3460103e0e109 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -13,8 +13,8 @@
 
 /* Reed-Solomon(M, N) parameters */
 #define DM_VERITY_FEC_RSM		255
-#define DM_VERITY_FEC_MAX_RSN		253
-#define DM_VERITY_FEC_MIN_RSN		231	/* ~10% space overhead */
+#define DM_VERITY_FEC_MIN_ROOTS	2	/* RS(255, 253): ~0.8% space overhead */
+#define DM_VERITY_FEC_MAX_ROOTS	24	/* RS(255, 231): ~10% space overhead */
 
 /* buffers for deinterleaving and decoding */
 #define DM_VERITY_FEC_BUF_PREALLOC	1	/* buffers to preallocate */
@@ -50,8 +50,7 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	/* erasures for decode_rs8 */
-	int erasures[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN + 1];
+	int erasures[DM_VERITY_FEC_MAX_ROOTS + 1]; /* erasures for decode_rs8 */
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
 	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
-- 
2.53.0



