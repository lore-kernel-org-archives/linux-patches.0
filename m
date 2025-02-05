Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67552126C18;
	Wed,  5 Feb 2025 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763375; cv=none; b=d3w1pB3fRGKGGNAOIb/j/zu9RAesxqaKK/EwWIPvf9vHIplmWaJcywLpnKYR0dXcrBISH3I/w52BVsvWeIij4OeyfKwNusWjshKaLoBa9gFqo0BLbjBGvIjeLeda8e+i4ja/JIs49XmK2IfMkjtC3jYecwoyfATtM0dzTXqdxJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763375; c=relaxed/simple;
	bh=JKuSDp59z/buIH6tB14FdIE9pTKl6cdF14lY7BH2UOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW2NW5rz99F6hOignTsv03R0gsNcazWu8nv9/JX/LrXnWoAb4rb93khUtIjSkbcDY2wIK3UvWGLAhw5l7uJH7UFUX8viuT5qIgcjICYMQ3S9200H8JoKr/VDmHxj11/f94Te6dC2chZriKwURXG0lLMdfIFc3MmZ+LYwICt6kFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bENbw3Rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bENbw3Rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAB3C4CED1;
	Wed,  5 Feb 2025 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763375;
	bh=JKuSDp59z/buIH6tB14FdIE9pTKl6cdF14lY7BH2UOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bENbw3RcJ6ihvfPoql3mQB/FsjMlSpPaEruNWGZioDUArLTYfnF382mXsfk8F8dCT
	 peotuoAwqHcvdgcHp7AaBCkfnoOi9+IItU4p2PXdEjayoC6ToAPVj73e/H/3+GgAsc
	 QdwK6Yw5UNFhzLHeZjTWhsMTDs9Gi4bp7/2Fk1XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/590] afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
Date: Wed,  5 Feb 2025 14:36:00 +0100
Message-ID: <20250205134455.435997502@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ada363af5aab8..50edd1cae28ac 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1472,7 +1472,12 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
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



