Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B851CF7E;
	Wed, 30 Sep 2026 18:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793337; cv=none; b=FAzlUKiDi0bJjnt7JGqkODVtmEuDGIfHe30X8jqGZH6uu3Mi/O3XzozYI1cd3er9vAcEtX2ZiaTUPCGBKxTG8N9idYCSgJrC7EV6dOLPr10Y6CW2ZEPViscYEkTDHgKLSi2q++8+GrtkURKGb+Fr1ebKaqbdsfEUIE717Jx9zcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793337; c=relaxed/simple;
	bh=aJzZS42l3qn9p5ScrYDR+7LqWtvvrfq2UVMqY6eBLnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rndgO2y/hYlNXthFVIcEa2MnJNg4V/O9Vh+Sk9oQQZZNw3A5a+N5UOsQhGggr8qvOqVGxuoZu0EinhVWAH9BCUOCnZMQ6BZHO2naoHvWupu/Gl27q0KhQXFAvO8pZWxSIfBAQWghXqhKjgRQSEuGW9Abe/d53DQsQTtDpdbc7Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+XTu6UC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+XTu6UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F25E1F000FF;
	Wed, 30 Sep 2026 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793336;
	bh=TvPSU1suW9lfK9QfHQRhJAQAxe+eDoRb9DsWVcyVWdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+XTu6UCGHlgw9y2f52ZzNEQlsbTqPQeTFehtUEvDO/KBnpMlAGM4EJWizDi2mbWg
	 +Dg8K+CRc0NVSlBMAj5CDjdRXFUWjmtb6w5l8ConM9Rsg/Q5cHcdRKiqBco5pv1qkd
	 oXdhZDB7n2LOLFQ9yfkVDFl5xrTMYZBjodO1syfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 217/395] bpf: fs/xattr: dont assume the inode is locked in path_unlink/path_rmdir
Date: Wed, 30 Sep 2026 17:27:59 +0200
Message-ID: <20260930152345.368951884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,10 +403,6 @@ BTF_ID(func, bpf_lsm_inode_rmdir)
 BTF_ID(func, bpf_lsm_inode_setattr)
 BTF_ID(func, bpf_lsm_inode_setxattr)
 BTF_ID(func, bpf_lsm_inode_unlink)
-#ifdef CONFIG_SECURITY_PATH
-BTF_ID(func, bpf_lsm_path_unlink)
-BTF_ID(func, bpf_lsm_path_rmdir)
-#endif /* CONFIG_SECURITY_PATH */
 BTF_SET_END(d_inode_locked_hooks)
 
 bool bpf_lsm_has_d_inode_locked(const struct bpf_prog *prog)


