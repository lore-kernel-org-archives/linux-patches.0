Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A24248BB2;
	Wed, 15 Jan 2025 10:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938126; cv=none; b=NfLR5gyq679dJLw2Se13I72vS+MXEGjPkxJNUujonh+ufmg2Y/Bkt5M8whPi1r50AF8UMbWlywUhxdAor3i17HzmhDRDZsVvGAZk2sv+rOcd6fLf4gHouXLTEhWmVY6RPdFoKecDMldnv4f9yxzDAKlH7N4KCLOvOOfKsnq2M0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938126; c=relaxed/simple;
	bh=W7szpo4/fa4TzyIKGIh+mDTdhFs3My+UxKyyCKxe29M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YACnWXD6vXQStIONKddDpEmuSzlq1VLQbCw1c5XxVHpWaJYzwI4aKDukL9zhajA8xhK0jIrxLED1uYRTJW9ZRKR+ULWi5S3HkZeyJg3Qc/ePoKUDOc+2Sed977ce0gX8HfGExB1IBGUWxdOCWspI1M0+s74Z6ZrI2Sx3ikuk1DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eog4+eeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eog4+eeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76889C4CEDF;
	Wed, 15 Jan 2025 10:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938126;
	bh=W7szpo4/fa4TzyIKGIh+mDTdhFs3My+UxKyyCKxe29M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eog4+eehwmG49pD4FmZj15Dfx0D2+V50QJfs9EifeFxmjDD1agRSIEKRjmY/GO0eh
	 Xyd6V9QybURLH3CQR+8GAL8ajtgwJAFG8Cxs4TrU3iRUwR+lkkMW3D6+t9xC7x2hYt
	 i84O+hUsTHzvwsaebCr1gijPx69q0DxkyOodZfbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 089/189] fs: fix is_mnt_ns_file()
Date: Wed, 15 Jan 2025 11:36:25 +0100
Message-ID: <20250115103609.884498482@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit aa21f333c86c8a09d39189de87abb0153d338190 upstream.

Commit 1fa08aece425 ("nsfs: convert to path_from_stashed() helper") reused
nsfs dentry's d_fsdata, which no longer contains a pointer to
proc_ns_operations.

Fix the remaining use in is_mnt_ns_file().

Fixes: 1fa08aece425 ("nsfs: convert to path_from_stashed() helper")
Cc: stable@vger.kernel.org # v6.9
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://lore.kernel.org/r/20241211121118.85268-1-mszeredi@redhat.com
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2055,9 +2055,15 @@ SYSCALL_DEFINE1(oldumount, char __user *
 
 static bool is_mnt_ns_file(struct dentry *dentry)
 {
+	struct ns_common *ns;
+
 	/* Is this a proxy for a mount namespace? */
-	return dentry->d_op == &ns_dentry_operations &&
-	       dentry->d_fsdata == &mntns_operations;
+	if (dentry->d_op != &ns_dentry_operations)
+		return false;
+
+	ns = d_inode(dentry)->i_private;
+
+	return ns->ops == &mntns_operations;
 }
 
 struct ns_common *from_mnt_ns(struct mnt_namespace *mnt)


