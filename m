Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777F8371048;
	Wed, 20 May 2026 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301637; cv=none; b=N+QE1TjPsaKslLeKah48kSM3AD1TBI9bB8JRaXhhf/ykcreG65avO1uSgdISVZyzF7r3lauOlrmEE6RxEwJr3SjymVZF/Dz46bPe28OAlkIzfxPwfWbNaXG6enoK/CxIGaqijGuCP/H7Bfd0rg3pnLhutMjgtsY9DcCzKwtqukA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301637; c=relaxed/simple;
	bh=jqpLElEc1/QSFT01qyOcl0qEdgBllX7Jhk2WqUCHp7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYZTtAgLrGXsQwf3qGFkhniSh/XUWJ6xlA46AVa1RZqnhBrcwDb81cesFjx/0Q0Oww7zVgO6xilSbIOwt87055vFTRwmYkc65yYCQmQNOd36u9RUDqBpMoY6T045g+boMzek3X8cYftmuwWLxf6FUW7YnR16axCe+FzzrRkzCiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDvQ7mka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDvQ7mka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46331F000E9;
	Wed, 20 May 2026 18:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301636;
	bh=RPStHpe4x/yHulS2LpKBE+JRFd8UEnQqLlD2oytvHRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDvQ7mka7a8brelXkUm/UaXqY9KbZYZRat/FB2yU2vlTF9YsWQjmeChtBGKlcxbG/
	 i1VPDmjkp84nZ7ACAOWyW0kf9+x4U2fhXHNcpmzWT+3xwbk77PLXuKIqbP7BTK1npB
	 GXdt/hO2jZnNOru8hVx6w/rJhcRsGLZC90CbdVdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 630/666] ceph: fix a buffer leak in __ceph_setxattr()
Date: Wed, 20 May 2026 18:24:01 +0200
Message-ID: <20260520162124.930972193@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

commit 5d3cc36b4e77a27ce7b686b7c59c7072bcb3fa8e upstream.

The old_blob in __ceph_setxattr() can store
ci->i_xattrs.prealloc_blob value during the retry.
However, it is never called the ceph_buffer_put()
for the old_blob object. This patch fixes the issue of
the buffer leak.

Cc: stable@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1296,6 +1296,7 @@ retry:
 
 do_sync:
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 do_sync_unlocked:
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);


