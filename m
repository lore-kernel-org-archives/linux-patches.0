Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CB02877F7;
	Thu, 25 Jun 2026 13:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393175; cv=none; b=LheMwNOaosPCCaLOtzUbrhv2x375bk993Uf98eVW4E614WL7RecHk7PvKEgj6+HTCBE834YFAvwcD487b9SZKoX45DZCxYyWxjVj0YyJLlXQ4OrSG8qt6sAtd26YXtMyiXDnrdBKcq9n6ImUU6nWOA035OSosGtx2dzlPKUqE9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393175; c=relaxed/simple;
	bh=sO4xRROJPsXTiPouAz970NHKHjujKBxmCUP9RfF2FSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vGAFpnG8LASjliid147fq+TauuqLgGnD0I6VotR1HX180DjtVpAEQaXYWHL700ENJdwHdzRkvrXR2yQXTMDAPE7voTtY0PlodtQ+6Y/44m1Pz/3KE+lDipOGFtfeeSXDttAms9aYQgRocLZqqO4ju+rrj3Jep5plBMukx4RmThk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnhMYckg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnhMYckg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABEC1F000E9;
	Thu, 25 Jun 2026 13:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393174;
	bh=D6gsI3bpJ/6iNGIdBwQgeS85oDgQL061L88233Y2UDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnhMYckgCG1AqFHedYzW9xeg+3TO+CtxGMXmanXLGYmDB4j5+VbU+D5eCeEtYNErz
	 0M6qb61ECcbYy5ZhOYSOB5SoE4TCGMc7612hnHrdYvW/gvJfnvSZP/VFBg71V8jiMm
	 CKMXTnoVnVcl6gYWR9UTZPUvSgkJqtLOXK/rIZg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Bombo?= <abombo@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Greg Kurz <gkurz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 21/21] virtiofs: fix UAF on submount umount
Date: Thu, 25 Jun 2026 14:04:13 +0100
Message-ID: <20260625125616.160186728@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 06b41351779e9289e8785694ade9042ae85e41ea upstream.

iput() called from fuse_release_end() can Oops if the super block has
already been destroyed.  Normally this is prevented by waiting for
num_waiting to go down to zero before commencing with super block shutdown.

This only works, however, for the last submount instance, as the wait
counter is per connection, not per superblock.

Revert to using synchronous release requests for the auto_submounts case,
which is virtiofs only at this time.

Reported-by: Aurélien Bombo <abombo@microsoft.com>
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Greg Kurz <gkurz@redhat.com>
Closes: https://github.com/kata-containers/kata-containers/issues/12589
Fixes: 26e5c67deb2e ("fuse: fix livelock in synchronous file put from fuseblk workers")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kurz <gkurz@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -380,8 +380,14 @@ void fuse_file_release(struct inode *ino
 	 * aio and closes the fd before the aio completes.  Since aio takes its
 	 * own ref to the file, the IO completion has to drop the ref, which is
 	 * how the fuse server can end up closing its clients' files.
+	 *
+	 * Exception is virtio-fs, which is not affected by the above (server is
+	 * on host, cannot close open files in guest).  Virtio-fs needs sync
+	 * release, because the num_waiting mechanism to wait for all requests
+	 * before commencing with fs shutdown doesn't work if submounts are
+	 * used.
 	 */
-	fuse_file_put(ff, false);
+	fuse_file_put(ff, ff->fm->fc->auto_submounts);
 }
 
 void fuse_release_common(struct file *file, bool isdir)


