Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEC8509EF3;
	Wed, 30 Sep 2026 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787577; cv=none; b=Ew+1URQoVLnOQr0GoGk0W+tVQBOW6W6OJ07d81qvZRs6tYtXMG5p4SGusb6d4VOzOne4AuT2P8C2nieJilc5iqMV+HkuIhnUuGqPgHqIGLAxv836mEoaNLr8fBxeMQFpGZP5oeGNsEm0oCkDSb82W4jivpDMT4gxpLmH1DgALp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787577; c=relaxed/simple;
	bh=q8BcKw07QOzfz0nuYLeq8vu4ZVKgj0iLhoUjFFf6l0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni0u0f/VWLcDjA8A65uB1jdK75aalTIIxkpp8MvfF8F9pcGrUbzKN3Av+Q3sOkDkxRJ7bHJMCc8xLa/EVVUTenLZjmEmpYVANJoW6nyt4zIAP6IQ2KYYelIdNc/4MFD76fAz07yrTxJvMFUliZGdNVTYck5ZmlqpNo1HKpo0noY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcfzOAEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcfzOAEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E162B1F000FF;
	Wed, 30 Sep 2026 16:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787576;
	bh=VT62D1edVGAxrVA5bFl4T73QeBLl69Yl+rXRSwh7gx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcfzOAEIjvhtIpQRU/bSsMYGZkr9EYj8LZlXortOeA3pDMpi8cnYzyceNTDw+lLGR
	 U029/NgTUvjKgA9IEbvkZqCsIajXd0GGcImalOEd7REw6N4EQGV2lHvlcMDFVfmpFE
	 2itPLjFWfgzChsxzZLQfrIOc7IE3mjirkrVWAj/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 252/457] bpf: fs/xattr: dont assume the inode is locked in path_unlink/path_rmdir
Date: Wed, 30 Sep 2026 17:25:57 +0200
Message-ID: <20260930152351.488246050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit 35d442ed1f86465e49df3119fb898f985186db13 upstream.

bpf_lsm_has_d_inode_locked() makes the verifier rewrite
bpf_[set|remove]_dentry_xattr() to the _locked variants, which assume
that the caller already holds the inode's i_rwsem.  The path_unlink and
path_rmdir hooks are listed, but security_path_unlink() and
security_path_rmdir() run before vfs_unlink()/vfs_rmdir() take the
victim inode's i_rwsem, so a sleepable BPF LSM program attached to
either hook mutates the victim's xattrs without the lock held.

Drop the two path hooks from d_inode_locked_hooks so that the verifier
keeps the locking bpf_[set|remove]_dentry_xattr() variants, which take
the lock themselves.

Fixes: 56467292794b8 ("bpf: fs/xattr: Add BPF kfuncs to set and remove xattrs")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260922145530.369775-1-parri.andrea@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bpf_fs_kfuncs.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -419,10 +419,6 @@ BTF_ID(func, bpf_lsm_inode_rmdir)
 BTF_ID(func, bpf_lsm_inode_setattr)
 BTF_ID(func, bpf_lsm_inode_setxattr)
 BTF_ID(func, bpf_lsm_inode_unlink)
-#ifdef CONFIG_SECURITY_PATH
-BTF_ID(func, bpf_lsm_path_unlink)
-BTF_ID(func, bpf_lsm_path_rmdir)
-#endif /* CONFIG_SECURITY_PATH */
 BTF_SET_END(d_inode_locked_hooks)
 
 bool bpf_lsm_has_d_inode_locked(const struct bpf_prog *prog)


