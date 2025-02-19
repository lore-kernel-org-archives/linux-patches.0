Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2981DED71;
	Wed, 19 Feb 2025 09:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955937; cv=none; b=poslAVCIx9VU3Rc4oTEQJP1WRxBlZH/3vJG1FJuyPXxfVOL6WlOQ/G3/QEJB+C5dsA43MB6bStS3ghUnsI93ldc8fM9I92heDUA4pKP4IQpuVnxuvaK3Zi3rOXELNGPO69eWQ5U0mPObYVjPxB44JRjMoXmB155xRWeJhNLxRH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955937; c=relaxed/simple;
	bh=+cInW37kBGTMY+kQy1gDQ20W3Y2+DcpflFHdrHzMdGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8gBG3Mvkws9rsSinwdv+5OFjcbZQH5/025Lk0vzUukG1JIQWlM26/98u5mb8+kCT0aLsIWqkKvQje28y0vnnIz5kOXiIrNPC09LgEKgz3WPcG5Gd/4wHTIGSgjviTOiuRPUXeK3eF31zK9zC5xdJpsPRwznB3+XEBMBRyJChUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/rCvEAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/rCvEAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE67C4CED1;
	Wed, 19 Feb 2025 09:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955937;
	bh=+cInW37kBGTMY+kQy1gDQ20W3Y2+DcpflFHdrHzMdGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/rCvEAqBhxQCFbVuJIvYIJ/9OYGjth/zLo3NQ4OBEh0T++b6iSwf4kCPFSFKCR9W
	 4xTCp9sB1FKFgsSAkaRsHvIQCS3hbve7wcsPiON+whWFxrabh7UUveq8Ph0xOM8GOi
	 AzHODbrMwWnMNxdT6YUk6hTeM1sDi0NZ57u/vkcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/578] afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
Date: Wed, 19 Feb 2025 09:20:06 +0100
Message-ID: <20250219082652.995466027@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38d5260c4614f..cb537c669a8e8 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1457,7 +1457,12 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
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



