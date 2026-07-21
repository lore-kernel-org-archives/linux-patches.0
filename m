Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE5A46A5FD;
	Tue, 21 Jul 2026 17:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654848; cv=none; b=BSPmrdCLK3dMMKR3KoX3XobKJpBey56LXdXYJps/MT1evzLf3Kal2V/SLmqz5nGfQAD165/WbMg/yinl5NsEr0kR/Ap6Yw/K8bIigWvou3lTMgUVQSHnu/ewNLAkjeS5SZoDL3672d9VtpNIUpopzRr3qC7Er8uTckIVnNRN6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654848; c=relaxed/simple;
	bh=UL4o5Sd0SgJJ5OZ9BoldWAHOBbGQuQtFmWz9Ed635lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwaJVl8HuT0vPoDUZOgf6MpnFcQqOiUYm9kFKlCAZDPwNsnPooqznkk8J7p/LVd3H33iYoEAQF27JpVsHM00fM6NO842WZMMWR/Q9wduG4PGJZUiV1xhlmhBwAEUO38Q+HT5b87RcQVWrD9KQNqlpy5CLyK7gAcAGchxSrh2I+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU8+ETjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU8+ETjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB911F00A3A;
	Tue, 21 Jul 2026 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654846;
	bh=9aSR9jiekKJdK3WX95b/dL3aMdyZXHQhDn55WbABqaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UU8+ETjMI1t8UvFbh7vqKeVe4MEA1+Sqxm9i3kGGwEvI3g9zWL/aUWxKUEIwA6unp
	 i3TpAqJydRAm3VRq00+6Zg9ZMwlhtDTK8aGeVavmxNOdmFfFYJPrZbjVfsJyYUcl6f
	 o/9soUDi+Dn8G5BQ8+ra48wV+o412dEin1vQnwKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1861/2077] dm-verity: make error counter atomic
Date: Tue, 21 Jul 2026 17:25:34 +0200
Message-ID: <20260721152636.627574876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 8ec4d9c5a5cf4b61fc087f871465b1f79b393325 upstream.

The error counter "v->corrupted_errs" was not atomic, thus it could be
subject to race conditions. The call to
dm_audit_log_target("max-corrupted-errors") may be skipped due to the
races.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 65ff5b7ddf05 ("dm verity: add error handling modes for corrupted blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   12 +++++++-----
 drivers/md/dm-verity.h        |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -180,14 +180,16 @@ static int verity_handle_err(struct dm_v
 	char *envp[] = { verity_env, NULL };
 	const char *type_str = "";
 	struct mapped_device *md = dm_table_get_md(v->ti->table);
+	int ce;
 
 	/* Corruption should be visible in device status in all modes */
 	v->hash_failed = true;
 
-	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
-		goto out;
-
-	v->corrupted_errs++;
+	ce = atomic_read(&v->corrupted_errs);
+	do {
+		if (ce >= DM_VERITY_MAX_CORRUPTED_ERRS)
+			goto out;
+	} while (!atomic_try_cmpxchg(&v->corrupted_errs, &ce, ce + 1));
 
 	switch (type) {
 	case DM_VERITY_BLOCK_TYPE_DATA:
@@ -203,7 +205,7 @@ static int verity_handle_err(struct dm_v
 	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
 		    type_str, block);
 
-	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS) {
+	if (ce + 1 == DM_VERITY_MAX_CORRUPTED_ERRS) {
 		DMERR("%s: reached maximum errors", v->data_dev->name);
 		dm_audit_log_target(DM_MSG_PREFIX, "max-corrupted-errors", v->ti, 0);
 	}
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -68,7 +68,7 @@ struct dm_verity {
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	enum verity_mode error_mode;/* mode for handling I/O errors */
-	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
+	atomic_t corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
 


