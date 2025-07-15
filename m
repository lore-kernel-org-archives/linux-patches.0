Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5326519D09C;
	Tue, 15 Jul 2025 13:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585596; cv=none; b=kbAicDNWkwky6/ajMOhNKmL3goyvDfq1ruE9kZ4XB6lIjptjhsGd+/WwDhNXEkutoFUL2I57GL64H+iToa1hcBJgLGT2jFVCvXgwfrq2Fq0QW2nGjdsYRpjPSB6/xO1GM1F5coB7iH7rST3tNgBuEDD5ceT3tTaqCjTXRxLy7Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585596; c=relaxed/simple;
	bh=gYASytF/SowT5hfTjtOlhmofQnD98sP4Nv3iBZMQR8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTecKTNzwkYFVwb3DUUou2NmQ4IfNPo5DE+48wBTDRh9o8nb6JHBJ9YxbTTRDaNv6mBc5X/R/aXnZGGxCSiocvoRaZ33cm8cT7638dyqAaQ3T0V1EY+jxKCdvR3Mk2itb87a9JXWw2VCTwSd4gzAJBMzHEWtQjAGd3ve0ZMhGUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7yBSPXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7yBSPXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC234C4CEF1;
	Tue, 15 Jul 2025 13:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585596;
	bh=gYASytF/SowT5hfTjtOlhmofQnD98sP4Nv3iBZMQR8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7yBSPXr7GK+EjBOcnsf5YkTsLjvscvQppAF5IfaZTnkDjZJk75JCMYbeEXWV3sJq
	 xIRZIg9Gld9a+ljH90AQJ2A7b+LO5drI5LapKi/qcKJRae2hRQ13QvSlsqFfIGjK+P
	 AchpgXaL5JlFfMIeYnKR55KDhZn+unA+RtXBnID4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 100/163] ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()
Date: Tue, 15 Jul 2025 15:12:48 +0200
Message-ID: <20250715130812.873522720@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 277627b431a0a6401635c416a21b2a0f77a77347 upstream.

If the call of ksmbd_vfs_lock_parent() fails, we drop the parent_path
references and return an error.  We need to drop the write access we
just got on parent_path->mnt before we drop the mount reference - callers
assume that ksmbd_vfs_kern_path_locked() returns with mount write
access grabbed if and only if it has returned 0.

Fixes: 864fb5d37163 ("ksmbd: fix possible deadlock in smb2_open")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1298,6 +1298,7 @@ out1:
 
 		err = ksmbd_vfs_lock_parent(parent_path->dentry, path->dentry);
 		if (err) {
+			mnt_drop_write(parent_path->mnt);
 			path_put(path);
 			path_put(parent_path);
 		}


