Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8866144AB8E;
	Tue, 21 Jul 2026 22:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674280; cv=none; b=p1fNNvnGtir6XTxFIpLC2D9DmdC5ookR28TXzZQkvCuI+TmeEYJ1NsNktDa9DaVKzwmCW9xRIR22IF0gNJIUGPbeCsDBzBlYt7DON+OBBrREgPvtRj3gcaQVdELM7ylU1BBxxGfakS/L4QRWHRmQvsMMH9Lax1SF/ftFVPovfYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674280; c=relaxed/simple;
	bh=M0u2s8j2WDi4EYq59pZHIEvG6r8AfwkM+7vfx+GDmZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=esuC6bICKq+SgxB6L/r/nXqD1wZWOlaYuwOg17ShV3mnvF6pronNq4RWV3KLDC7QiI8s/cfgWmcYKaIn/fhilOScRQ27WdmPFja7Rjw/OPapW21j71YeYHMB3W6e81nUkKsioHs9HKQFthNtDIxywvITMVkbSAnGVoXFjsA+GnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sx/rP8di; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sx/rP8di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76631F000E9;
	Tue, 21 Jul 2026 22:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674279;
	bh=a4ZNJ0stLUHPKVNDtXocAmB/lxAqe1D2DONLM0XRPr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sx/rP8diVaaRiXCY4qa5sPVxb4zAV3Ia3aMjbGzAN3dICv3XWHRemm4+nDoX377ZL
	 BSHHOqytX+swDTrAuJDcxMUgz8QJzb1CE1yFELp7Q0cfw83Ol3BaJDqQ8Ihb/zFtUL
	 s3uGfI7HDXIUMeXSPBJGkEdJT+9hV8hzpX0b1zWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 480/699] proc: only bump parent nlink when registering directories
Date: Tue, 21 Jul 2026 17:23:59 +0200
Message-ID: <20260721152406.529444681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -383,7 +385,6 @@ struct proc_dir_entry *proc_register(str
 		write_unlock(&proc_subdir_lock);
 		goto out_free_inum;
 	}
-	dir->nlink++;
 	write_unlock(&proc_subdir_lock);
 
 	return dp;
@@ -697,6 +698,8 @@ static void pde_erase(struct proc_dir_en
 {
 	rb_erase(&pde->subdir_node, &parent->subdir);
 	RB_CLEAR_NODE(&pde->subdir_node);
+	if (S_ISDIR(pde->mode))
+		parent->nlink--;
 }
 
 /*
@@ -722,8 +725,6 @@ void remove_proc_entry(const char *name,
 			de = NULL;
 		} else {
 			pde_erase(de, parent);
-			if (S_ISDIR(de->mode))
-				parent->nlink--;
 		}
 	}
 	write_unlock(&proc_subdir_lock);
@@ -782,8 +783,6 @@ int remove_proc_subtree(const char *name
 			continue;
 		}
 		next = de->parent;
-		if (S_ISDIR(de->mode))
-			next->nlink--;
 		write_unlock(&proc_subdir_lock);
 
 		proc_entry_rundown(de);


