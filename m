Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02FD1369A8;
	Wed,  5 Feb 2025 13:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763141; cv=none; b=PILyrSt8dvzCvdysoxc7N9qWDStsCha27bvGlJ3labMtIu8ZdJ/G9fD48w81x2rtSQC4eYhxwU1xSkVrOGK4cx7gZUgvTsXyqjGEMKnu36zfx4k2d+jhoNNnjIhvQHt7CJQhi0i0lO57OYpAr4z4mZSHb0RqxO+1Ve+gX3kxUJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763141; c=relaxed/simple;
	bh=EH6WUwYa2rem54PxOT1and4V/tu0WVs8BhNdqyR9U6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5OnkLMsx3u95Ra8Zw1x0iQvWnAQeKeENIOU1vyYGGZcwJUvq5xmZureTItq0Uqs6g2RcapzFbfmZWgT41klyvZF7VYCph+9QY7/UUHxLY2Z5EFCerIMlhwEljjFfxw0cKXqAEoZFR+nxoehlav47eP+xDfxCcuLCXBVUyXKlPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h50NU4Y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h50NU4Y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21BEC4CED1;
	Wed,  5 Feb 2025 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763141;
	bh=EH6WUwYa2rem54PxOT1and4V/tu0WVs8BhNdqyR9U6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h50NU4Y5sYJ5y5pTSUdabmWBjs2jd6Bc0RBCrmQuvs7lQePTsvM0eY1eMMjT/xdyZ
	 K0qhTe+frQQB4+35GfYie3WgtbtX0E9J+rfbmi/XsMaxkK9AadUjVUDw0W21VdGj7m
	 cdA9QX+eI+dDykh5lkbMlgOjewPaDgAkeGkDz4k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/393] afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
Date: Wed,  5 Feb 2025 14:38:42 +0100
Message-ID: <20250205134420.419214709@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit b49194da2aff2c879dec9c59ef8dec0f2b0809ef ]

AFS servers pass back a code indicating EEXIST when they're asked to remove
a directory that is not empty rather than ENOTEMPTY because not all the
systems that an AFS server can run on have the latter error available and
AFS preexisted the addition of that error in general.

Fix afs_rmdir() to translate EEXIST to ENOTEMPTY.

Fixes: 260a980317da ("[AFS]: Add "directory write" support.")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-13-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 897569e1d3a90..cdd2abdc8975d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1458,7 +1458,12 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 		op->file[1].vnode = vnode;
 	}
 
-	return afs_do_sync_operation(op);
+	ret = afs_do_sync_operation(op);
+
+	/* Not all systems that can host afs servers have ENOTEMPTY. */
+	if (ret == -EEXIST)
+		ret = -ENOTEMPTY;
+	return ret;
 
 error:
 	return afs_put_operation(op);
-- 
2.39.5



