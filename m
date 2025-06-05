Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D6F1FE44B;
	Thu,  5 Jun 2025 20:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749154337; cv=none; b=iQ9wS8X03w8zK1hNVQ7QOD91rcuFSnXlW1+w06/QbwAfln7tIyNm3EStQPFYTKH8S+pLkE2qZZLx1lpJIxltcseEkt9ZSP28AW7kG4xEUhPCm40o/9l5E5TFa/AIg2oQTCmrfxd31UiplK86ZhJNNay3ICpIXw8Ih0Gclh+1uxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749154337; c=relaxed/simple;
	bh=Y6Q7BuFQMf3YmlCaooTk1n7+rZt5p8d1d1qhs4uciwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P1YdLL8+QLWoAXAhAuwKZJffyPRmRN8ysVNGAsDC5LvrNjVdqBYCnRQZEtDzYN2+47aARW8RMUUGc8VDe1upe3F/yPKvg5n+QTN5Zsz+0rDxkAPZIPaR1yQBM5/8Xg0H7tLtSn8rGdiVKYOclxYqwzrI+t+bPtnf9bxMLFYoOLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=listout.xyz; spf=pass smtp.mailfrom=listout.xyz; dkim=pass (2048-bit key) header.d=listout.xyz header.i=@listout.xyz header.b=kqZ87fSQ; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=listout.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=listout.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=listout.xyz header.i=@listout.xyz header.b="kqZ87fSQ"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bCwb91d9jz9tmW;
	Thu,  5 Jun 2025 22:12:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=listout.xyz; s=MBO0001;
	t=1749154325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sdJ+N/GZxqBNyTDfTK6U6akNeML/Biqg6TNGDf4GHM4=;
	b=kqZ87fSQtTHGyKqZRdClJQPsmr92jnlAgKVjmUVGI4prLd5JYpcL/fafiulyWCzaV81XoV
	wNcuLKyrMG0sM7RkCfFNcEK1mslkoCpxYycMviZZQh9c7MDKjryux5W7YuOd4i9ci9OAfP
	YP6hjRcXGxggkhYUGQv8jkU4yT/QCAu1EsLN53DYH2rJJfpu2SVFIvYc7Xz+wn0E8JXIKV
	PG7qGjVeUUHdjISEACOODb+qiFvJZ2E4cyTRzAxO5Hn2LYtpgajl05PPGMzY22DYcIibAe
	IvmJIELJZetPH36hf9mP9FsKlaEofhCNFeG0juXfDhr1f4MpytBCGwWoXul+9g==
From: Brahmajit Das <listout@listout.xyz>
To: stable@kernel.org,
	patches@lists.linux.dev
Cc: linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	mpatocka@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH 1/1] dm-verity: fix a memory leak if some arguments are specified multiple times
Date: Fri,  6 Jun 2025 01:41:16 +0530
Message-ID: <20250605201116.24492-1-listout@listout.xyz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4bCwb91d9jz9tmW

From: Mikulas Patocka <mpatocka@redhat.com>

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 66be40a14e496689e1f0add50118408e22c96169 ]

If some of the arguments "check_at_most_once", "ignore_zero_blocks",
"use_fec_from_device", "root_hash_sig_key_desc" were specified more than
once on the target line, a memory leak would happen.

This commit fixes the memory leak. It also fixes error handling in
verity_verify_sig_parse_opt_args.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Brahmajit Das <listout@listout.xyz>
---
 drivers/md/dm-verity-fec.c        |  4 ++++
 drivers/md/dm-verity-target.c     |  8 +++++++-
 drivers/md/dm-verity-verify-sig.c | 17 +++++++++++++----
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 0c41949db784..631a887b487c 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -593,6 +593,10 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 	(*argc)--;
 
 	if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_DEV)) {
+		if (v->fec->dev) {
+			ti->error = "FEC device already specified";
+			return -EINVAL;
+		}
 		r = dm_get_device(ti, arg_value, BLK_OPEN_READ, &v->fec->dev);
 		if (r) {
 			ti->error = "FEC device lookup failed";
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 3c427f18a04b..ed49bcbd224f 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1120,6 +1120,9 @@ static int verity_alloc_most_once(struct dm_verity *v)
 {
 	struct dm_target *ti = v->ti;
 
+	if (v->validated_blocks)
+		return 0;
+
 	/* the bitset can only handle INT_MAX blocks */
 	if (v->data_blocks > INT_MAX) {
 		ti->error = "device too large to use check_at_most_once";
@@ -1143,6 +1146,9 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	struct dm_verity_io *io;
 	u8 *zero_data;
 
+	if (v->zero_digest)
+		return 0;
+
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
@@ -1577,7 +1583,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			goto bad;
 	}
 
-	/* Root hash signature is  a optional parameter*/
+	/* Root hash signature is an optional parameter */
 	r = verity_verify_root_hash(root_hash_digest_to_validate,
 				    strlen(root_hash_digest_to_validate),
 				    verify_args.sig,
diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index a9e2c6c0a33c..d5261a0e4232 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -71,9 +71,14 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
 				     const char *arg_name)
 {
 	struct dm_target *ti = v->ti;
-	int ret = 0;
+	int ret;
 	const char *sig_key = NULL;
 
+	if (v->signature_key_desc) {
+		ti->error = DM_VERITY_VERIFY_ERR("root_hash_sig_key_desc already specified");
+		return -EINVAL;
+	}
+
 	if (!*argc) {
 		ti->error = DM_VERITY_VERIFY_ERR("Signature key not specified");
 		return -EINVAL;
@@ -83,14 +88,18 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
 	(*argc)--;
 
 	ret = verity_verify_get_sig_from_key(sig_key, sig_opts);
-	if (ret < 0)
+	if (ret < 0) {
 		ti->error = DM_VERITY_VERIFY_ERR("Invalid key specified");
+		return ret;
+	}
 
 	v->signature_key_desc = kstrdup(sig_key, GFP_KERNEL);
-	if (!v->signature_key_desc)
+	if (!v->signature_key_desc) {
+		ti->error = DM_VERITY_VERIFY_ERR("Could not allocate memory for signature key");
 		return -ENOMEM;
+	}
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
2.49.0

