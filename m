Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AB23BADA3;
	Fri,  9 Oct 2026 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555396; cv=none; b=fnZi35jCX+7pyV/+HVdzdyJDrHdtIjD074z/pjqgS2IEFOuuDOwEnNVLjqlfoNk9UKU3xIvnz1+JnfNfd0BLmep4dKO+pBtU5rKqEk6/6dHmwLfd7g6e9hDqkQwHJmY9wm/dGTiFzEdcnYR0lyKKUXrJWAEEyDRC820qFTWUQ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555396; c=relaxed/simple;
	bh=fkOjvCZaRUvmU1mS2ufNc1csX97L0i/Rz21B6cPvSVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6/lDQArDDRDhXSxyillQZvTi5zXtpKz58bqHre6kyLKpesvOAJi26DjapCBdlYvVXWCN9+vg+1MkNuRgFK6TPJBw6oi4jaIR0e+vPisuZvPu9NXHFrxBdHR0rXBWk9feviV81uWDITQ0G5B89lDXUOPU+MjQt5vfFneP0TBj+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZgHCqyC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZgHCqyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871C71F00898;
	Fri,  9 Oct 2026 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555393;
	bh=yI9lDvIFNXvGhFUV1F/lqlP8J6b7SJO717pNLMZ+xus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZgHCqyC2XLU3bZ9/e92XjZawkbQiMORcKu6xqYDz4RPwxqvUCf0Fe3zneYwRaSSC
	 zDqj2UEvuv11cT55SWMXA+gLlVzh4cF9GIgU2gxfdZ2pzrljbds0HP3mOWOwkO8wvw
	 GTuPG21A3hC0z36pZJACshdBExUPBTqAhk8HPHdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Bradley Morgan <brads@mainlining.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 6.18 042/403] module: fix lost error code from codetag_load_module()
Date: Fri,  9 Oct 2026 16:06:43 +0200
Message-ID: <20261009140953.090316748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Hao Ge <hao.ge@linux.dev>

commit c79cf15eb35a4c703bf18f8c33c47e80dd660f8e upstream.

If codetag_load_module() fails, err is not set to reflect the failure
and load_module() returns 0 after the module has been torn down.

Also, if the module is a livepatch, mod->klp_info allocated by
copy_module_elf() leaks on this error path.  Free it via a new
livepatch_cleanup label.

Link: https://lore.kernel.org/20260827030503.49171-1-hao.ge@linux.dev
Fixes: 044d2aee6c57 ("alloc_tag: handle module codetag load errors as module load failures")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3516,8 +3516,9 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
-	if (codetag_load_module(mod))
-		goto sysfs_cleanup;
+	err = codetag_load_module(mod);
+	if (err)
+		goto livepatch_cleanup;
 
 	/* Get rid of temporary copy. */
 	free_copy(info, flags);
@@ -3527,6 +3528,9 @@ static int load_module(struct load_info
 
 	return do_init_module(mod);
 
+ livepatch_cleanup:
+	if (is_livepatch_module(mod))
+		free_module_elf(mod);
  sysfs_cleanup:
 	mod_sysfs_teardown(mod);
  coming_cleanup:


