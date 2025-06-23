Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688DD13A265;
	Mon, 23 Jun 2025 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684679; cv=none; b=Yhmgfb5ang0JeMcWy04Ab7m9j1I5ParN3phfofFqXP6GxHWxCUEGfHcg1pKYR/F2G6DqRTEvORPyAr4ERy6fXsZ5T829/v6e7izg4WvXar+1sEADxE9mcopCVCibnOyHy3P27XQmpeZgHXUcjX3pEC4fawFkJKVNpsQGM3BHzpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684679; c=relaxed/simple;
	bh=Uhhiow+ZahX8V86N3mS8At6C1FsqEKuT/RgQBJACIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXIfU8saEDRRc00KXqEMwfPt2j98hn1QW+0UHtFY2qarlS3pSRQ6gdvuwr9pv1iswmVyUgWZbdAmwVuXyC9hdT9xVSrintIUn+FCp8PQf00jzO7ut3CdF3Fz4ip4werLwWRBSyeXDiY4In8MfUzmab4q9jWl1CZ6ihPN2XUVJww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEYlq0e/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEYlq0e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9FAC4CEEA;
	Mon, 23 Jun 2025 13:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684679;
	bh=Uhhiow+ZahX8V86N3mS8At6C1FsqEKuT/RgQBJACIdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEYlq0e/DichGoYlbqxRwcI7OA2/k6yIziaGbhkLQTifIpH3UU72hRuV+raA5SAAl
	 qzMqNfdBqp4ahRbR4Roo4WLzO6MGchdSKGHb3iSAsbpWkjD5/7dqgfYiyObhoT8LS+
	 +w0eBqedqAaFDPdDJYCYQowOXd7a1WoubO4jMcx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.15 152/592] dm-verity: fix a memory leak if some arguments are specified multiple times
Date: Mon, 23 Jun 2025 15:01:50 +0200
Message-ID: <20250623130703.899406214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 66be40a14e496689e1f0add50118408e22c96169 upstream.

If some of the arguments "check_at_most_once", "ignore_zero_blocks",
"use_fec_from_device", "root_hash_sig_key_desc" were specified more than
once on the target line, a memory leak would happen.

This commit fixes the memory leak. It also fixes error handling in
verity_verify_sig_parse_opt_args.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c        |    4 ++++
 drivers/md/dm-verity-target.c     |    8 +++++++-
 drivers/md/dm-verity-verify-sig.c |   17 +++++++++++++----
 3 files changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -593,6 +593,10 @@ int verity_fec_parse_opt_args(struct dm_
 	(*argc)--;
 
 	if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_DEV)) {
+		if (v->fec->dev) {
+			ti->error = "FEC device already specified";
+			return -EINVAL;
+		}
 		r = dm_get_device(ti, arg_value, BLK_OPEN_READ, &v->fec->dev);
 		if (r) {
 			ti->error = "FEC device lookup failed";
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1120,6 +1120,9 @@ static int verity_alloc_most_once(struct
 {
 	struct dm_target *ti = v->ti;
 
+	if (v->validated_blocks)
+		return 0;
+
 	/* the bitset can only handle INT_MAX blocks */
 	if (v->data_blocks > INT_MAX) {
 		ti->error = "device too large to use check_at_most_once";
@@ -1143,6 +1146,9 @@ static int verity_alloc_zero_digest(stru
 	struct dm_verity_io *io;
 	u8 *zero_data;
 
+	if (v->zero_digest)
+		return 0;
+
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
@@ -1577,7 +1583,7 @@ static int verity_ctr(struct dm_target *
 			goto bad;
 	}
 
-	/* Root hash signature is  a optional parameter*/
+	/* Root hash signature is an optional parameter */
 	r = verity_verify_root_hash(root_hash_digest_to_validate,
 				    strlen(root_hash_digest_to_validate),
 				    verify_args.sig,
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -71,9 +71,14 @@ int verity_verify_sig_parse_opt_args(str
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
@@ -83,14 +88,18 @@ int verity_verify_sig_parse_opt_args(str
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


