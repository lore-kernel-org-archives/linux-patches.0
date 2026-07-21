Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866F730EF7E;
	Tue, 21 Jul 2026 19:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663730; cv=none; b=CUcmiiB+Ixq3UXCpMUcBbOMQ3xvzwtHekh5eBP3MElB51EpgHUghkPj5B27yARB1SBEaqd7zzIq5ZCKV3G8Wcjo7HZhr15CpIOG8zsQOWs26GtnAwG0ha9A83qTbmVEg04ic8NYjGtoMATOjsCfJl61LAL5nk85rcsROKYGnhT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663730; c=relaxed/simple;
	bh=JyfWu3yHOhC2mwKVUdGVg+zu2D/RAhR1Bxb8G5QlWvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=furNeOPcR61vdZmBCZvP0+UG2abzCHXSD+YBjEn3Gxw40qJIEGlb4P2p94M9Cr4b+X09RbKjB+namUoGSU6njM5qzQYkZdGk/Wf/xvpgXOCmzub+E92tCd26FBgE9s+LoseaPkjc/ue/tpWqx2EIypOHHOooZeeQHlVptRniP60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQP5E+mM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQP5E+mM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB521F00A3A;
	Tue, 21 Jul 2026 19:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663729;
	bh=MyePDhSn9myUvcsRgmgttaZ5Crnf/lG0TTQ5SUIMSM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQP5E+mMeYjT/eaK2Na2hpdRcFUs+7HFsLvrLilDxEssIuP9mZy8KCVB8+IA6CQx3
	 AiJc+R0qZTXilHouceVEsTk3GQeMPr4jpgoCHMSVxFWAARI7zna/+/ypqtpsiOjxFb
	 nJfhA5BjLYWLmsJEgro9FU/VFapAPJb2GlCJRPdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 0934/1276] proc: only bump parent nlink when registering directories
Date: Tue, 21 Jul 2026 17:22:57 +0200
Message-ID: <20260721152506.933502186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -399,7 +401,6 @@ struct proc_dir_entry *proc_register(str
 		write_unlock(&proc_subdir_lock);
 		goto out_free_inum;
 	}
-	dir->nlink++;
 	write_unlock(&proc_subdir_lock);
 
 	return dp;
@@ -698,6 +699,8 @@ static void pde_erase(struct proc_dir_en
 {
 	rb_erase(&pde->subdir_node, &parent->subdir);
 	RB_CLEAR_NODE(&pde->subdir_node);
+	if (S_ISDIR(pde->mode))
+		parent->nlink--;
 }
 
 /*
@@ -723,8 +726,6 @@ void remove_proc_entry(const char *name,
 			de = NULL;
 		} else {
 			pde_erase(de, parent);
-			if (S_ISDIR(de->mode))
-				parent->nlink--;
 		}
 	}
 	write_unlock(&proc_subdir_lock);
@@ -783,8 +784,6 @@ int remove_proc_subtree(const char *name
 			continue;
 		}
 		next = de->parent;
-		if (S_ISDIR(de->mode))
-			next->nlink--;
 		write_unlock(&proc_subdir_lock);
 
 		proc_entry_rundown(de);


