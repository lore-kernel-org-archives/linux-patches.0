Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE717E110;
	Tue, 11 Mar 2025 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706321; cv=none; b=KSVhtOBsg+mruvkQQXXUtMLuo1H8z24LjBaN+KtfeZt19UM/OyMLSaPQX/AUhIL/dVG+pjqpZm0Oaubf7uKHpmhY6mJ8eLyQWW16JGAUjbz4JBEcroJI41Ynjoyoxc3FsR9wgkrahN2QfwrOX5ymGbxNt/A821q+tiWHH8HEMKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706321; c=relaxed/simple;
	bh=J3G3GqLIxTLbnWF86Asm5oZ0tn6ASw8pcs1etpzAH9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE3+MECF1RO2LaaZmiVi/pLsCeFwWwWx7K/BO1aknb7sM15ASEhESS/cFdF0If1OyjjpPn1y8W1IZa8Hzkfn3/wUkoHBywgLfSoKbg0UF3SDQ6ltTrw/OBIW2hiFMhscD8mHtxHIrEexyR1JENDXOgF+Es4IT6DzMWOnDcAgPzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef+bBk9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef+bBk9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18664C4CEE9;
	Tue, 11 Mar 2025 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706321;
	bh=J3G3GqLIxTLbnWF86Asm5oZ0tn6ASw8pcs1etpzAH9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ef+bBk9EBcR80pXmLpX2Wo5JOn3EzK9WtghBykq3cw22rpRUoIdueYOyFFLnJ/xO8
	 5CtfIsp+lZ8oYdOHw8a5gca5vTkNnv9OSl9BbY4CPFOiMZHsdik/dypnnp9pwWiGTs
	 q5dzauChH5JYM8TDpnt5U3ur5T8KOJZCZ2/V70sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/462] afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
Date: Tue, 11 Mar 2025 15:54:27 +0100
Message-ID: <20250311145758.407712659@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a59d6293a32b2..c3c870416f1b7 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1412,7 +1412,12 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
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



