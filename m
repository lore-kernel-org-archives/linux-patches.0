Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0037E2E9;
	Fri,  9 Oct 2026 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555708; cv=none; b=ewzAmk5mgfnD+NZSA+G3zM4zi445wnw4zOKfBmBotxjpFTrRrCugYwApc4CDXWxP84xHGm7O9wd9eRUQYAn0irql7HlFngpKiAmK2KnPjxvpwuCoc1QTkBA+1s0BSswenl0yyqKOCu+4BDTX0LLBcU9rhb9wjZxIvTpZVfORjpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555708; c=relaxed/simple;
	bh=shavzpn6bgmLk30rouf/8/HlhDORLxi2KK/C8sy1buA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFJCI9kUqGkJ1NJ2bmimeOOZ4zceeR0JS/LBHxV+sgI5vdwh6W8+5mwSkUR334nWX9d3V5Pi8X2gHG1edpp+YyoRos29rr8rEv8fg+fbsY0tf/AaYljyzR0dakQ3/RmfHY8PNOW2jNRmdybP0MoX4loKCpXJIM1z18rP0UliDWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dn0JukJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dn0JukJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ACD1F000FF;
	Fri,  9 Oct 2026 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555707;
	bh=xKGLILVm33E3//7zYme+TPOwY0tg4NQpGQxv6dc3UNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dn0JukJO1zZ1OcWa1n07JepusgwWoFYdM1Z9QxBzhvGeaSB5yG7HB+z01L9yAOctQ
	 i3MzeWBQkbfTV76iBraDCpoCAzeLscGE8tKZY00WhES+W85HoinGyWOKXSOVNGw1/N
	 MZU5VMDsm6eBgyjVgkYLb6QiWAbq/pylCET2fJVs=
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
Subject: [PATCH 7.2 052/428] module: fix lost error code from codetag_load_module()
Date: Fri,  9 Oct 2026 16:06:29 +0200
Message-ID: <20261009140947.264987429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3580,8 +3580,9 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
-	if (codetag_load_module(mod))
-		goto sysfs_cleanup;
+	err = codetag_load_module(mod);
+	if (err)
+		goto livepatch_cleanup;
 
 	/* Get rid of temporary copy. */
 	free_copy(info, flags);
@@ -3591,6 +3592,9 @@ static int load_module(struct load_info
 
 	return do_init_module(mod);
 
+ livepatch_cleanup:
+	if (is_livepatch_module(mod))
+		free_module_elf(mod);
  sysfs_cleanup:
 	mod_sysfs_teardown(mod);
  coming_cleanup:


