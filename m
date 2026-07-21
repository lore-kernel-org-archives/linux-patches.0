Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A0E471268;
	Tue, 21 Jul 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664587; cv=none; b=qF3JDunuM7iGDvAz6FVd9k9B90QTGgCH0liS5+UYD+FZq3jsoACkJQh5pCdlKx03a5jM/E9MQsgspmvr9PNKH480BnMuRhg8PegkB54OSQ10uTN9TzZPYnxFq7KUgGXdlGK8x+/6pNWyZPs1Ext9pcbXtjd8x8hyONq78Nzxufc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664587; c=relaxed/simple;
	bh=oE4xM51dpquhYf5Tt7jI2hRszKzI00kTmIPZIzHkITY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoD3FMY/r3a9XdGuEpQPOku2lZDHRE++xBKZAmk9wAs55b6MWYNWMbilnNkZoP2EGi6qZWWYx1QaGwKh2bLoASfpym4eeF3k9XVkJOrjtHmkqFp5KNzxEYirrEPoPDkJKqF0lWS9TaD3jHHIfFRRf3gBuUglgP0jyEGT8Mvt0pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T04Gok+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T04Gok+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B60D1F000E9;
	Tue, 21 Jul 2026 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664585;
	bh=fgkfuVfAGHHWrLq+u0fYmC4RHHSij+BV/8BaRpLZID4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T04Gok+z5d26Mt1+tgFHDbKKAth/BpBj98PLvr2SuLn5iTTPDz6C/2Tro7GA1fWfB
	 BXS5eGHvQKcoZjuYxJFfPoCb779uhPortwbajHwjd6xTa9npIGrZzxN9NYHPXuXOWe
	 for6D0E8b0Uu4CQom2o+Aov8DzAiDIVFDBK40ohs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+76a6f18e3af82e84f264@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 1257/1276] afs: Fix afs_atcell_get_link() to check if ws_cell is unset first
Date: Tue, 21 Jul 2026 17:28:20 +0200
Message-ID: <20260721152514.222094098@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 0307d16f3610eb29ad0b7529846de7d62fed60ca upstream.

Fix afs_atcell_get_link() to check if the workstation cell is unset before
doing the RCU pathwalk bit where we dereference that.

Fixes: 823869e1e616 ("afs: Fix afs_atcell_get_link() to handle RCU pathwalk")
Reported-by: syzbot+76a6f18e3af82e84f264@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/2481796.1742296819@warthog.procyon.org.uk
Tested-by: syzbot+76a6f18e3af82e84f264@syzkaller.appspotmail.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dynroot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -209,6 +209,9 @@ static const char *afs_atcell_get_link(s
 	const char *name;
 	bool dotted = vnode->fid.vnode == 3;
 
+	if (!rcu_access_pointer(net->ws_cell))
+		return ERR_PTR(-ENOENT);
+
 	if (!dentry) {
 		/* We're in RCU-pathwalk. */
 		cell = rcu_dereference(net->ws_cell);
@@ -220,9 +223,6 @@ static const char *afs_atcell_get_link(s
 		return name;
 	}
 
-	if (!rcu_access_pointer(net->ws_cell))
-		return ERR_PTR(-ENOENT);
-
 	down_read(&net->cells_lock);
 
 	cell = rcu_dereference_protected(net->ws_cell, lockdep_is_held(&net->cells_lock));


