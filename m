Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9000D386C13;
	Fri,  4 Sep 2026 05:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498909; cv=none; b=owyKf4O242NxGOE0zdFDQhnZMj1ivOt8FBVylEo1K7uJOxg+XRGbkAM7CSYkePa6Hsiwg+id/mUrCZt8BPZcaLbkxcu0K6XUUdn+45/RWmawpx9dR8F+GenALtJHDj2s+zLbF55Pz598222B18KXwWCfdsfBN4gFB3yq9MtclJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498909; c=relaxed/simple;
	bh=UQZfIWa6jJOGtB+CEMSw1O0WsNI4wj8v+yAbz4sqwVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov/owqfNQ2XFtyvLm9aDNR0i9KbtfaPzLaQI4zdtosESak8KVMtnagYEp5aXkOelmBoWi/3J5n01tVUPk4WiQQQDY5ngAd+4wIj91yC+MdUo/b31FgW1sqSyaL7QjSdRSL0Lfl5ikdJxFjAdyHH8/mztEu5SVwf67olN5x7JQ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTdJS2h6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTdJS2h6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEA31F00A3D;
	Fri,  4 Sep 2026 05:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498908;
	bh=tGQMI4tlo/ILQAXnJWqMGiAcOwUDwWPTfqdU6KM36AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTdJS2h6weKKk/j5dJg8GLXXtyk1/2J6NxKKYoRLlmAk9M8sXw4INMS2Jxz2rH8N2
	 7GsHgQ/ENobjTnFM5iViwYiVnBKqNH6KERXft6Yd02Mzwv507lQ/w6wHpUs2p+4So9
	 poj1qHwrj5I/uY6KbYIa8XlT7LYffEpo9ecYI1MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 231/713] cifs: call pagecache_isize_extended() in cifs_setsize() when extending
Date: Fri,  4 Sep 2026 06:53:19 +0200
Message-ID: <20260904045809.000840968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit c510edb9734af1c274d18f4f31a471a166bbc7e8 upstream.

cifs_setsize() calls truncate_pagecache() but skips
pagecache_isize_extended() on extension.  truncate_setsize() shows
the correct pattern:

  i_size_write(inode, newsize);
  if (newsize > oldsize)
      pagecache_isize_extended(inode, oldsize, newsize);
  truncate_pagecache(inode, newsize);

pagecache_isize_extended() zeroes the tail of the page straddling old
EOF.  Without it, dirty bytes in that region can be written back to
the server, exposing stale data in the newly extended range.

Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3057,6 +3057,8 @@ void cifs_setsize(struct inode *inode, l
 		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	if (offset > old_size)
+		pagecache_isize_extended(inode, old_size, offset);
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 }


