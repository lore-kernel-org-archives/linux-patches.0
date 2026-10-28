Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208095;
	b=FdyF8UJJrQz13cl6/xzr4tvXpyxqYJQmGRRg1tLGKOlHW2k3NwjiY+W8EhK/GHTyDnWl
	 VUK4XBgwC2dC13Y8k/8cD9Fh686LWcU/Ax0rIUSRZCm1bbsua0EvwuEy371aU5tVfkPDB
	 kQvPriUnQOWl2o/RKUVReGwvq4axSYWJnmpGWbBaZRn9DKhpRyDweAnl3eFtmSHDV0EK0
	 4kQy0ViMg0knGloU7a6UyImmSKW8tuy7CK7a8AcZ80u7q8jkgELkPb5XQp2YUpX1NgxSV
	 BNoom6GWN6Nj1FvtNYt0ZjTI1vGM9mjctIJ4lCgfwTlV4cf+r/+5nSIvCRZPLD79wTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TThgyk6fNDk8N8lOx+bItTcYkC4oL1Ud6BHMLVAXg8A=;
	b=OK+my4PJyr3TBy21OsM6T0BnPnAedc1I5z8MizPuq+0aSz+m2Cj2lm3A/+PdxSELqSFc
	 Gc8ET2A/dVayb74c/gkFEFTYzPQTi3BE+xwmiNjndjzmy6StB+NhyQcniwUbJYyFkbbgv
	 KblF/SWrMyk0Oq0DQLH0HvYRO+51VTy624+o6aS9eVgFIvVzr3jWFt5/xQUaC4NpZaTFV
	 OpzM+B2oDt7CxbUhRGL9bb/XZxE/UraJZu/P+BwcYSE7C6qVa9Ty0NWJs77ekL7VEMNrV
	 yAuy906mOOhakHyoVYF4nA6xH/Swnet+WTP9IUVDBlMAJbBU4e/7k9GxX/joCDfxDKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n7jSyX4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3278D606A31A;
	Wed, 28 Oct 2026 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n7jSyX4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4822D1F01825;
	Wed, 28 Oct 2026 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208094;
	bh=TThgyk6fNDk8N8lOx+bItTcYkC4oL1Ud6BHMLVAXg8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7jSyX4ssTHpMFIHQaevxKJmx8HSudYXlc0VabTUDYYGlzv94vMLgmCo7hXBhzCme
	 7O9VFFklfExj795R53Y48RjOJxKK6ccKl/X11yHkcJYQjVJmFxmlgKdzkUIjs4ZfWs
	 XWD87BX3qJkT/K253tTecSyjjK1IP/0ToC6WZKv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6a3aa63412255587b21b@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 247/247] fanotify: Fix crash in fanotify_init(2)
Date: Wed, 28 Oct 2026 18:00:50 +0100
Message-ID: <20261028165953.270715552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 0c0214df28f0dba8de084cb4dedc0c459dfbc083 upstream.

The rrror handling in fanotify_init(2) is buggy and overwrites 'fd'
before calling put_unused_fd() leading to possible access beyond the end
of fd bitmap. Fix it.

Reported-by: syzbot+6a3aa63412255587b21b@syzkaller.appspotmail.com
Fixes: ebe559609d78 ("fs: get rid of __FMODE_NONOTIFY kludge")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1552,8 +1552,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned
 	file = anon_inode_getfile_fmode("[fanotify]", &fanotify_fops, group,
 					f_flags, FMODE_NONOTIFY);
 	if (IS_ERR(file)) {
-		fd = PTR_ERR(file);
 		put_unused_fd(fd);
+		fd = PTR_ERR(file);
 		goto out_destroy_group;
 	}
 	fd_install(fd, file);


