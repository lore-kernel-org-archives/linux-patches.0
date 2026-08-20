Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4178C40F754;
	Thu, 20 Aug 2026 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244275; cv=none; b=u70FREP7YWKuZVEZpMgS1rNLHlGBFoE0gnR5Fyl6GaFH73RrR1HbzZLp6tybx3XHnOXCEiBMqcmmt8/B/MqF362lvFsw1WN3pK4cajDSpuUupKwjFTDodhgcJ8ab++9KcYq0mvui9GnDzLFJ2iq5dR1lm6O6GZzlMSAC6xkDH1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244275; c=relaxed/simple;
	bh=twI1ejmJXonc7GeBgdzo2AG+Zc8h7KgCtai0ovC81eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijFIq1w58YN/DC7TLpzE8CqI7ZstdziqwjfAmmDZfGE5KGC3BsH5UxdVUbm/6wwnfrECUxgBxO74m+uRLMs6ZVnilT9k3nT84TEpkYDswR0EjqieLuPTyCFJvhnfXIbJE8AXZqtcC3gP6f+93dIJdHvETLce5oSzHn+aXZB5X8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lK2nHdW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lK2nHdW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EAB1F000E9;
	Thu, 20 Aug 2026 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244274;
	bh=dg886dHpxt/+VAR5tA0Jc4a3UrN03AiQnS7e7dkiK38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK2nHdW58v42YaaSyyHL7GxQDJ3qzQbDB8Uv5R7z75aXOTRzFBj0X+fNBwYQC8Gwi
	 OASQc1TsCl9kweL/zi+PtJ0s8exUI1v5IqCRhOMGF1dqovPzTO+2qfa4VPlu5Xwl4M
	 T32AePDNkit+dK9LaK1Ep4RLsSAL2N3ru5+7qthQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/235] dm-verity: make error counter atomic
Date: Thu, 20 Aug 2026 16:55:49 +0200
Message-ID: <20260820145219.879876660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ kept 5.15's braceless single-statement DMERR body instead of upstream's braced block containing the absent dm_audit_log_target() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   12 +++++++-----
 drivers/md/dm-verity.h        |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -217,14 +217,16 @@ static int verity_handle_err(struct dm_v
 	char *envp[] = { verity_env, NULL };
 	const char *type_str = "";
 	struct mapped_device *md = dm_table_get_md(v->ti->table);
+	int ce;
 
 	/* Corruption should be visible in device status in all modes */
 	v->hash_failed = 1;
 
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
@@ -240,7 +242,7 @@ static int verity_handle_err(struct dm_v
 	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
 		    type_str, block);
 
-	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS)
+	if (ce + 1 == DM_VERITY_MAX_CORRUPTED_ERRS)
 		DMERR("%s: reached maximum errors", v->data_dev->name);
 
 	snprintf(verity_env, DM_VERITY_ENV_LENGTH, "%s=%d,%llu",
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -55,7 +55,7 @@ struct dm_verity {
 	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
 	int hash_failed;	/* set to 1 if hash of any block failed */
 	enum verity_mode mode;	/* mode for handling verification errors */
-	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
+	atomic_t corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
 


