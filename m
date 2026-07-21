Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB39401A18;
	Tue, 21 Jul 2026 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654395; cv=none; b=iN4oDeWsaT9K5Ge7PWSVo9juwMGewjjsrS7h7lQo39xRQ5GjIMlaXftt+bmcHqukD6j2zLo8wUYpG345oMNXqm5QwI7PWv4mV1eTZj7xuVe/xbR7IaFtPfzvzfd0BiH6rSIzHlhI3eoMkHiwRZYaEJrjTdQheCqe4DsdGhJOcbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654395; c=relaxed/simple;
	bh=oSijwTHqiboHpL7Y/wSEGvuw0G8s2W2V5tg6XC/UL5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hca4eu4+cgCgHJU8+yVAEqugGxku3G9SmjgH09HuS7a1A9SoGJtFNLY9+z0aaPyK42qLrEJ/kX0YIHUU6PZAlkVV5Z+qJbrbOmmR9pzVUPOtUygD5Hp6MW0tmOknjf4AQzjn5ySXKz2C/N8I6Qvjne6QtDuFXsdPmMwc7A+ltjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDQGx2h9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDQGx2h9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E002C1F000E9;
	Tue, 21 Jul 2026 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654394;
	bh=lhD++0nh/KGgPAT0Ccynq4hmx5a286DqtbN7n/eEBSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDQGx2h9ey9Zn1eGu72wbLYx07E4a77Z5llru9tR66BM2ORXC3ctkRu5nSet7ZaWK
	 MLb9pvAJsOcKCgzhG1gIK4AeLKdhbIULwLYPOsZPy9FaEMLiHOmrqd7pq2YDlfm6HP
	 IYWdCqcYqFl4yBUKZfmp61/ENmrJH028Eotxze+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1688/2077] ntfs: free volume-wide resources on fill_super failure
Date: Tue, 21 Jul 2026 17:22:41 +0200
Message-ID: <20260721152632.566742851@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit a9523a7d3b24b3a6b25ec1eb668ee6618cacf05e upstream.

ntfs_fill_super()'s err_out_now path frees only the volume struct via
kfree(vol), leaving several vol-owned allocations behind on every mount
failure:

  - vol->nls_map, loaded by ntfs_init_fs_context() via
    load_nls_default() (or replaced by an explicit nls= option in
    ntfs_parse_param()), is never unload_nls()'d.

  - vol->volume_label, allocated by load_system_files() through
    ntfs_ucstonls() once the $Volume name attribute has been parsed, is
    not released by load_system_files()'s own error labels nor by the
    fill_super() inline cleanup that only runs on d_make_root()
    failure.  Any later failure inside load_system_files() leaks it.

  - vol->lcn_empty_bits_per_page was kvfree()'d in
    unl_upcase_iput_tmp_ino_err_out_now without clearing the pointer,
    so it could not be folded into a single common cleanup.

Because the failure paths never call ntfs_volume_free() and never reach
the d_make_root() inline cleanup block (it sits above the label and is
jumped over by the load_system_files() / kvmalloc failure gotos), these
resources accumulate per failed mount attempt with no chance of
recovery short of unloading the module.  This is a silent leak: the
inodes loaded prior to failure remain hashed but generic_shutdown_super()
skips evict_inodes() when sb->s_root is unset, so no CHECK_DATA_CORRUPTION
warning is emitted either.

Move the per-volume frees down to err_out_now and drop the
lcn_empty_bits_per_page kvfree() from the upper label so the cleanup is
performed exactly once on every failure path.  Using unconditional
kvfree() / kfree() / unload_nls() is safe because they all accept NULL
and the upper labels that previously freed nls_map (the d_make_root()
inline cleanup) already clear the pointer.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2536,8 +2536,6 @@ static int ntfs_fill_super(struct super_
 	}
 	/* Error exit code path. */
 unl_upcase_iput_tmp_ino_err_out_now:
-	if (vol->lcn_empty_bits_per_page)
-		kvfree(vol->lcn_empty_bits_per_page);
 	/*
 	 * Decrease the number of upcase users and destroy the global default
 	 * upcase table if necessary.
@@ -2557,6 +2555,9 @@ iput_tmp_ino_err_out_now:
 	/* Errors at this stage are irrelevant. */
 err_out_now:
 	sb->s_fs_info = NULL;
+	kvfree(vol->lcn_empty_bits_per_page);
+	kfree(vol->volume_label);
+	unload_nls(vol->nls_map);
 	kfree(vol);
 	ntfs_debug("Failed, returning -EINVAL.");
 	lockdep_on();


