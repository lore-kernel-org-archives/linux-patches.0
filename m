Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F23357CEB;
	Tue, 21 Jul 2026 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669744; cv=none; b=JpwuZ6Y4XRjKbVyJ3AoyXjcPZYplXxooNrwBiWcpEfrrlWfoALvy9W/u3w6mKiAvxQM0wWhVbuuYqa1VdIvfocakH1uMdDWmAI0KTa3PC5wYCh48eBr0CCuloLkbirHuzKf5w8RAFDiyIbgdPV5lsWLExwtb4KUsjVM8pj2Yrps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669744; c=relaxed/simple;
	bh=wS3K+o5euoyf8oTsxi5/94JxQ5Q+sC1nFXT847M4DPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkYWJi88ZSfcItuiZutdMb1wrjBX/CQxTkxenmcuc7o5tAA2elV3QMOgz9cACtqu5n+bCXxW2k6yg6q7BKpSIcJwKPyargYXjhZvrJwDNduiH7KUvVckz0NVUoswU4C7j3OrHAz2JZdTSItil8yJicObIT2NuKPzN50wsmYINq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QS9qPAyh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QS9qPAyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0561F000E9;
	Tue, 21 Jul 2026 21:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669743;
	bh=WGqAjNmLSrn3PRyPvja+NKbtbW3DBVWZ/iMWVar50M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS9qPAyhsxtkaBhyw6jaFU8+ZqMsPDaAF2IysX+nwLLz0gaoZkiEVQYBH0xXh24xW
	 qRfyqi1sBzD4RlbaA+9lUcwG6Zxiag8KUm+XNSvL7Eb2hXemav83a2PmmNwYKz8o1H
	 MOS9rb5LHGoF4YBTeJoZwMXtNPHKa24mdbgmlJRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0671/1067] afs: use kvfree() to free memory allocated by kvcalloc()
Date: Tue, 21 Jul 2026 17:21:12 +0200
Message-ID: <20260721152439.607165038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit cb39654926f8e7a08ecc1dcb3941628855275940 ]

op->more_files is allocated with kvcalloc() but released via
afs_put_operation(), which uses kfree() internally. This mismach prevents
the resource from being released properly and may lead to undefined
behavior.

Fix this by using kvfree() to free op->more_files to match its allocation
method.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-8-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_operation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index 7a3803ce3a2297..4316cce855cd7c 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -240,7 +240,7 @@ int afs_put_operation(struct afs_operation *op)
 		for (i = 0; i < op->nr_files - 2; i++)
 			if (op->more_files[i].put_vnode)
 				iput(&op->more_files[i].vnode->netfs.inode);
-		kfree(op->more_files);
+		kvfree(op->more_files);
 	}
 
 	afs_end_cursor(&op->ac);
-- 
2.53.0



