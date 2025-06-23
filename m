Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBE821D3DD;
	Mon, 23 Jun 2025 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714723; cv=none; b=JvKHHwG/NBCZXRM6VKhmkB1D9zUvqsGKr/4g3JQ2ch6SXSIvqZkLxoER07+HGVy7UJ1AwNHZ6dxkvIIEXGp9wCHOYS7FkZ6DIrcG/EC0Mej4ufDH6Lwb47IhV+jiEhO+YesDbz/YktHxjdH1kjrtbg9ybKqTqAvKRJijORx6cIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714723; c=relaxed/simple;
	bh=VeFn3t+SmkhrtHvnFi8EyDdQIgSP9soRyvQkbVhzCME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6Tlg0dLkNOUNRCsV2ZBjNyik5WlcsjWIfiLmaz8vTJn6DL5iV9oasWXnknHRAT5rdur591aWOmM2YDhxPgKxyK/gO3t5yZAbW0UWSZI/TVZ43o7oSjBsWcgbmoCRpK0pqYj1lAm7WVXG3AbmJhF3JiB6rRkgiRPItnL5qRw3AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crVEA4Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crVEA4Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256B2C4CEEA;
	Mon, 23 Jun 2025 21:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714723;
	bh=VeFn3t+SmkhrtHvnFi8EyDdQIgSP9soRyvQkbVhzCME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crVEA4FmLnDcP9O1wJpZNKrorbXTV08qRxna5lYtyiccFmcStHzIPi/WxloJGQJFZ
	 YvDdLTd26nYZpQTEZw7BlqXGzmQoTRsUoahl1yV7r4CP8zxXNE7G2Z4OAojhOIRsBQ
	 JDkznn+8vxjWwI+irCoFeP39ebAN/f/zm2ET+u+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 126/414] dm-verity: fix a memory leak if some arguments are specified multiple times
Date: Mon, 23 Jun 2025 15:04:23 +0200
Message-ID: <20250623130645.212639121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -604,6 +604,10 @@ int verity_fec_parse_opt_args(struct dm_
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
@@ -1080,6 +1080,9 @@ static int verity_alloc_most_once(struct
 {
 	struct dm_target *ti = v->ti;
 
+	if (v->validated_blocks)
+		return 0;
+
 	/* the bitset can only handle INT_MAX blocks */
 	if (v->data_blocks > INT_MAX) {
 		ti->error = "device too large to use check_at_most_once";
@@ -1103,6 +1106,9 @@ static int verity_alloc_zero_digest(stru
 	struct dm_verity_io *io;
 	u8 *zero_data;
 
+	if (v->zero_digest)
+		return 0;
+
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
@@ -1537,7 +1543,7 @@ static int verity_ctr(struct dm_target *
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


