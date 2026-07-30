Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D84449B26;
	Thu, 30 Jul 2026 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428235; cv=none; b=gf2Bq8NbuX7ZmzdfX8WqMfq7nAcXqTKvsRJKBlF/PpzmhnnUryO0vO9gjF62kxFz4JU2pXl7lGcoH5xVehvdWr9TiUBdOr2lgxNotm689zG0m6ph707zpIMdnHODVVjvjcy0xt3XxYxGT6ChleUobpHucaYmoEII4JsYn3Om+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428235; c=relaxed/simple;
	bh=H7VBrz9SiJchAITvS+Y8WPwNq8cD+ksepD4DDu7MRm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cyu2HM9cMynG34aviA4+BMoWPjc076IQlzMzA2/SJTOlfOHHuZPi0fagAscKaZOCCjYvHQpvwiKl20OgjAs5z1VX+gxFP1gzfZBXw+v1m5FIF1+XsAOFiSV36MTnIMVy5aO40Kk3x7xcQwADGx8wDt0o4JTH6/dio4eHONWYPE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDs8JiOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDs8JiOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F201F000E9;
	Thu, 30 Jul 2026 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428233;
	bh=Yg8kXbycOc/6I+F1lBqXIrIA3JJOff4IjRZCaVc4On0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDs8JiOO0y+C/K+hNG6t+u34k11VKyhYho3Fe+El9fYVqpLezk+bUkf9zwS3K1dEk
	 Yu5R6RXzNDz9P3QkJzE4xamc6h+6sZ9oyYQT73gORe6YXCwTmuO3lbA4wAcS4KhvwP
	 Gbb6ErtEVQdTTnnidn8LN95d32zJObz+ZnP1Kg6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 449/484] dm-verity: make error counter atomic
Date: Thu, 30 Jul 2026 16:15:46 +0200
Message-ID: <20260730141433.236283766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8ec4d9c5a5cf4b61fc087f871465b1f79b393325 ]

The error counter "v->corrupted_errs" was not atomic, thus it could be
subject to race conditions. The call to
dm_audit_log_target("max-corrupted-errors") may be skipped due to the
races.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 65ff5b7ddf05 ("dm verity: add error handling modes for corrupted blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   12 +++++++-----
 drivers/md/dm-verity.h        |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -227,14 +227,16 @@ static int verity_handle_err(struct dm_v
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
@@ -250,7 +252,7 @@ static int verity_handle_err(struct dm_v
 	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
 		    type_str, block);
 
-	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS) {
+	if (ce + 1 == DM_VERITY_MAX_CORRUPTED_ERRS) {
 		DMERR("%s: reached maximum errors", v->data_dev->name);
 		dm_audit_log_target(DM_MSG_PREFIX, "max-corrupted-errors", v->ti, 0);
 	}
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -58,7 +58,7 @@ struct dm_verity {
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
-	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
+	atomic_t corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
 


