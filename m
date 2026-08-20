Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1264F47D46D;
	Thu, 20 Aug 2026 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243563; cv=none; b=Ae0aNuWJOFT75zCoqkqA16uAx6enmTcCgH8TbIok+RtIAi6WgVpjzYWgDhxCtKkOwGGQ4q9D3v4CSeu+2QMiElJG5Y4SdXGpHCsalm1CR2rt//Gp+9x9zc+FdnvTJ5Rc78gbbS670Z+SDuQu7XcED7VxHTmk9JTEaNELkS8WwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243563; c=relaxed/simple;
	bh=wk59odqggzblECDqg+1svucThjYbvcU1z2GBn7y7T54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGJ8bPPbbtrAWQo6LZ0Y3gacAHj5Kg9mLnpDuXW+MHAAkOTD1+y354Io06yua82kMwlaZ+041mxFTa3pNOakKPfHAhnAGFVi8mvs1KMj9NKhSGqxLk1Nshn4uS0fuKvfJxKv0LEbnDTth/M6ups+8Hcygu2Wji81essJqn4wjgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkTPhQhO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkTPhQhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8A61F000E9;
	Thu, 20 Aug 2026 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243562;
	bh=vjVK46VpHGW9hOGdYfBJWvq02FIxYrlie2ICTOrHV3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkTPhQhOi7pAYBX2Owrvo2JVLmLha/5BAeFjCmfMxz3OvXymI6wXjKKg0S84qETww
	 Gosw4ywRhGeo5khdZsNBDKdxiLGSOE3fIuUs+vS/AZkRTd+EXYXA0p41euJTvlODRe
	 pXshfXWN2F4gw0jW+sSaN2crtE4KXysqE+Kf/Xi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/272] dm-verity: make error counter atomic
Date: Thu, 20 Aug 2026 16:55:21 +0200
Message-ID: <20260820145235.389828892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


