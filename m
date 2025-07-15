Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0EB2E6D28;
	Tue, 15 Jul 2025 13:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586631; cv=none; b=ThOTam5rBSrwi/ltQbwPTimbV5YAKZFsaOGUAPrvRTOpDgNaHnNE3yPMNbMjJ0tVPPa2YVhYsJ/bDDR38aP9S3LznzVSxICVWlYfUpQNuuodL2KOP0ufvvJ+fXOdD7jcR7OsWJniNnFQuWVFyaV9H2BVp8t94QsuhJ827xjfRsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586631; c=relaxed/simple;
	bh=AzznSN7rKrjYYSzdfM2IVAzFJuxt8x+LurWCZ/SaPRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKJvNs2Wezm7rtnsEzhb1p3jPWIfzYpTnkaIO8lFkhnqp2qSjhKp63tLoOjy1hIMGUQ3Z20NhzXE5JXIVlcVTo6TbAnOAmRg78tEtcPaF9Dzv0ceEwlit+XHUKXcprbn6dEGtU7Bf8sXZbqDVckwiLg/9uERnDIPEYPHkC9L638=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+aw/ADw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+aw/ADw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C860C4CEE3;
	Tue, 15 Jul 2025 13:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586631;
	bh=AzznSN7rKrjYYSzdfM2IVAzFJuxt8x+LurWCZ/SaPRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+aw/ADwL+yvbVZjY9Xmy+ioKAVNQdG2RkaougWgoyRb/Tvjqsa+jkkiMRy+kDeWq
	 rPl2KadOIlHBGOdRPhX/kppJMyfSXRLS8IUiRp5OJEoApivHliXoKkn6l/bCZNBEg1
	 VrYTH7I3CaNt55QM8kz+EU2fRS7TpLBCQc298qAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/148] proc: Clear the pieces of proc_inode that proc_evict_inode cares about
Date: Tue, 15 Jul 2025 15:13:49 +0200
Message-ID: <20250715130804.595887633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 71448011ea2a1cd36d8f5cbdab0ed716c454d565 ]

This just keeps everything tidier, and allows for using flags like
SLAB_TYPESAFE_BY_RCU where slabs are not always cleared before reuse.
I don't see reuse without reinitializing happening with the proc_inode
but I had a false alarm while reworking flushing of proc dentries and
indoes when a process dies that caused me to tidy this up.

The code is a little easier to follow and reason about this
way so I figured the changes might as well be kept.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Stable-dep-of: b969f9614885 ("fix proc_sys_compare() handling of in-lookup dentries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/inode.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 3f0c89001fcff..a6bb1b5c903e6 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -33,21 +33,27 @@ static void proc_evict_inode(struct inode *inode)
 {
 	struct proc_dir_entry *de;
 	struct ctl_table_header *head;
+	struct proc_inode *ei = PROC_I(inode);
 
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	/* Stop tracking associated processes */
-	put_pid(PROC_I(inode)->pid);
+	if (ei->pid) {
+		put_pid(ei->pid);
+		ei->pid = NULL;
+	}
 
 	/* Let go of any associated proc directory entry */
-	de = PDE(inode);
-	if (de)
+	de = ei->pde;
+	if (de) {
 		pde_put(de);
+		ei->pde = NULL;
+	}
 
-	head = PROC_I(inode)->sysctl;
+	head = ei->sysctl;
 	if (head) {
-		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
+		RCU_INIT_POINTER(ei->sysctl, NULL);
 		proc_sys_evict_inode(inode, head);
 	}
 }
-- 
2.39.5



