Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B7F4F5E0;
	Wed, 20 May 2026 17:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299871; cv=none; b=dpRRWjB7KhwnDa8Za5pd4N7LGBOxHKRcRl49bV0FqVAJDXTjhWV60E46HzQJ0Uofwr9lI090WStPd0/DlzkYXR3adKtwvnqWEKGNYZpA/VLjH4Tp1xy+/NkvypyOBcIPf9JJy6QHz2n13ETxQ9thDHZtaH/zGQSlL+YO1rcUjdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299871; c=relaxed/simple;
	bh=mCmUaMm5zZUMpGQGggF3LxDqS0jcg87Ttr4R1TVZnhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFN/sYQ3eNSqfMXN4UQsgGch+5+bZma9gAuNqj/GuVWYjfNJcuwcoyVaUQ+dJX1cn+FffC9NB8djjMY0LHcb2VUOcl33mZkeLaBlkEBMD6G2y4LMHBL5ja8P0Fy76qiUO9/mHfc7/kYPnPjUzNxIcyReCzFn7QU/GzKRcKofQ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smEW2fK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smEW2fK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578101F000E9;
	Wed, 20 May 2026 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299870;
	bh=0wg/2LsKJwHw+QKAhRFkcJzWqEhazJKANCJ3RzdGR2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smEW2fK4GW8RtnnoPPkW44h1SOBBmo2LPP8HklH1XZ5DOxEsVxLXTl+QZTf43dDm0
	 7syYkJaCdVtWzfrKz2yFqD/X8+lfiomYOaZvH6NTJhJQq/xmMlQj9TpATnWcn0zZdc
	 hvDckNaOl1AG/1J1oHlwKqPRt/xJUi52wjNwoZ50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 917/957] ceph: fix a buffer leak in __ceph_setxattr()
Date: Wed, 20 May 2026 18:23:20 +0200
Message-ID: <20260520162154.466588378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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


