Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488F24A06B;
	Mon, 23 Jun 2025 13:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684345; cv=none; b=DleIRK2V33GrdYNmvT7jErJTfOqcYpuXZQqY+L256p9UQLHSnPqCaxP3C2H3rSpH/RSJpab7wKk3LsVlN47q2s+jWY6Rpb08p0qUfWWADrmQJBz+92ZRSE4hK/0AGj31HFgndyudoZ/MptTLvxm/Ag+rxuiEIA4YWnyRJrBIbew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684345; c=relaxed/simple;
	bh=+zP92qvLNu4nOcrbqZ4U9ZKlVFM2dLdM7sShbH0ra00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLphs0NPQGplJDC2C3ycIedWT8G9LzkIJ3FM5w98VDFO/g/eyCe0cElDu7/VmRh7fIK04qzXVXFsdfERABXpX49Pmfw5JynauhdA+9iwuwIeAXFPAoooSiSI72dT52jLIE5zxk6TpH87dUBFOuzlCuWhl8UkIPtz6Xk63yTxJ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWId+V7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWId+V7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6DEC4CEEA;
	Mon, 23 Jun 2025 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684345;
	bh=+zP92qvLNu4nOcrbqZ4U9ZKlVFM2dLdM7sShbH0ra00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWId+V7e3l+5qyuV5ymaXLiTDnxt85/ntzkuq37+fndUFUoraWiR9Fug9h2T63/oY
	 SrtWaS4oiyd/DiRy8bmrnJVc5BHZsjifJ93JazYcWxGZOhuidwfp7ni91d5nQMhHxn
	 O9a4Cn8vLvAtziF3u4CyD/1NA/9EVEZRe1M5h2gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 034/592] anon_inode: explicitly block ->setattr()
Date: Mon, 23 Jun 2025 14:59:52 +0200
Message-ID: <20250623130701.058806592@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 22bdf3d6581af6d06ed8a46c6835648421cca0ea upstream.

It is currently possible to change the mode and owner of the single
anonymous inode in the kernel:

int main(int argc, char *argv[])
{
        int ret, sfd;
        sigset_t mask;
        struct signalfd_siginfo fdsi;

        sigemptyset(&mask);
        sigaddset(&mask, SIGINT);
        sigaddset(&mask, SIGQUIT);

        ret = sigprocmask(SIG_BLOCK, &mask, NULL);
        if (ret < 0)
                _exit(1);

        sfd = signalfd(-1, &mask, 0);
        if (sfd < 0)
                _exit(2);

        ret = fchown(sfd, 5555, 5555);
        if (ret < 0)
                _exit(3);

        ret = fchmod(sfd, 0777);
        if (ret < 0)
                _exit(3);

        _exit(4);
}

This is a bug. It's not really a meaningful one because anonymous inodes
don't really figure into path lookup and they cannot be reopened via
/proc/<pid>/fd/<nr> and can't be used for lookup itself. So they can
only ever serve as direct references.

But it is still completely bogus to allow the mode and ownership or any
of the properties of the anonymous inode to be changed. Block this!

Link: https://lore.kernel.org/20250407-work-anon_inode-v1-3-53a44c20d44e@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org # all LTS kernels
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/anon_inodes.c |    7 +++++++
 fs/internal.h    |    2 ++
 2 files changed, 9 insertions(+)

--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -57,8 +57,15 @@ int anon_inode_getattr(struct mnt_idmap
 	return 0;
 }
 
+int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+		       struct iattr *attr)
+{
+	return -EOPNOTSUPP;
+}
+
 static const struct inode_operations anon_inode_operations = {
 	.getattr = anon_inode_getattr,
+	.setattr = anon_inode_setattr,
 };
 
 /*
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -346,3 +346,5 @@ int statmount_mnt_idmap(struct mnt_idmap
 int anon_inode_getattr(struct mnt_idmap *idmap, const struct path *path,
 		       struct kstat *stat, u32 request_mask,
 		       unsigned int query_flags);
+int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+		       struct iattr *attr);


