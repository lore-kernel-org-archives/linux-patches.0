Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FF325B0AB;
	Tue, 21 Jul 2026 22:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672432; cv=none; b=PPSyr63IDbBUvFLzm6Jeu0Cwk6/UQl2EIQPsRRAIvB8jZBHZ9FEfIKP3VaZ3/POOW2eRgFt5fADoLVmDUSh5SiizzGOlXCRfJIwV+bN9a8V8/Rcu+Xyg4nbu7tq1Bg6HAagA8qAs/gCSC/e5C/K7DVksdaJVWgLdZH295Igrabc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672432; c=relaxed/simple;
	bh=GeJr12G9b5LEnv4uBELRFjDhzG/Npuhfx6emT24UG8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jTOe7M3BY6WXKwQCdi+b0oln+SK7z26F7Xf9qsRTx0g2jdzu5W+lC6fuPHhsJaI4Ca/OCljDjLHBCop0x39x4R05uH0aBCdk6hvis2ZOMEacUk/YhbiLGLdqCO7kRCFXefW1D9KupWRvd6wQnIcR66p7HYaLufDV8XdMNYQDYH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUs6TKMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUs6TKMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82861F000E9;
	Tue, 21 Jul 2026 22:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672431;
	bh=O4uLLCA5dBAyE7kzXYqeM6kqLt3Hv+NKdf2mmEpyKdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUs6TKMbjfArK43WokjAhpGYeYVjEcGDJPr4kQb+wvf8n0XrFSu8oqyJkygLG9maX
	 TtULiVR07+FP8Cb/y+Rw6QG/3l1cUvHVL7/D2/R8R9oe5EsGb75CYIo0eTLlmdD1BJ
	 KLIN+oKthAvH78AkCqmkNXe4+AJYEEEfJl2Mr4cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 621/843] proc: only bump parent nlink when registering directories
Date: Tue, 21 Jul 2026 17:24:16 +0200
Message-ID: <20260721152420.029211767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

commit 16b02eb4b9b272c221255c20d34ccd5db53a3ed3 upstream.

proc_register() increments the parent directory's link count for every
entry it registers, while remove_proc_entry() and remove_proc_subtree()
decrement it only when the removed entry is a directory.  Regular files
thus inflate the parent's count while they exist, and leak one link
permanently on every create and remove cycle.

For example, /proc/bus/pci/00 with twenty-two device files and no
subdirectories reports nlink 24 instead of 2, and SR-IOV VF enable
and disable cycles, each creating and removing the VF config space
entries under /proc/bus/pci/<bus>, inflate the link count of that
directory without bound.

Before commit e06689bf5701 ("proc: change ->nlink under
proc_subdir_lock"), the increment lived in proc_mkdir_data() and
proc_create_mount_point(), and was therefore applied only to
directories.  Moving it into proc_register() to bring it under
proc_subdir_lock dropped the S_ISDIR check.

Thus, move the nlink accounting into pde_subdir_insert() and
pde_erase(), only updating it for directories in both, so the link
count is always changed together with the directory entry itself.

Fixes: e06689bf5701 ("proc: change ->nlink under proc_subdir_lock")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://patch.msgid.link/20260613211005.921692-1-kwilczynski@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/generic.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -112,6 +112,8 @@ static bool pde_subdir_insert(struct pro
 	/* Add new node and rebalance tree. */
 	rb_link_node(&de->subdir_node, parent, new);
 	rb_insert_color(&de->subdir_node, root);
+	if (S_ISDIR(de->mode))
+		dir->nlink++;
 	return true;
 }
 
@@ -378,7 +380,6 @@ struct proc_dir_entry *proc_register(str
 		write_unlock(&proc_subdir_lock);
 		goto out_free_inum;
 	}
-	dir->nlink++;
 	write_unlock(&proc_subdir_lock);
 
 	return dp;
@@ -692,6 +693,8 @@ static void pde_erase(struct proc_dir_en
 {
 	rb_erase(&pde->subdir_node, &parent->subdir);
 	RB_CLEAR_NODE(&pde->subdir_node);
+	if (S_ISDIR(pde->mode))
+		parent->nlink--;
 }
 
 /*
@@ -717,8 +720,6 @@ void remove_proc_entry(const char *name,
 			de = NULL;
 		} else {
 			pde_erase(de, parent);
-			if (S_ISDIR(de->mode))
-				parent->nlink--;
 		}
 	}
 	write_unlock(&proc_subdir_lock);
@@ -777,8 +778,6 @@ int remove_proc_subtree(const char *name
 			continue;
 		}
 		next = de->parent;
-		if (S_ISDIR(de->mode))
-			next->nlink--;
 		write_unlock(&proc_subdir_lock);
 
 		proc_entry_rundown(de);


