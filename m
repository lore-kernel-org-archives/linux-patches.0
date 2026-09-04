Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2983DB310;
	Fri,  4 Sep 2026 05:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498918; cv=none; b=jR7CnpHa6R5okG67IjCjB9j3A2ftpvUqe934kbs1vV0mys2eSsIVyCjIVE1IgZh3Skmb97BhWrVjB7sbuYRIEVRM6Fjv4b2MMZV2GYGIlJu57WXNZn8mLKLRUYossmVZOmiDcMfx/uCRpJ15oehaJNe2LIvdo1p/SiwHwprGHp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498918; c=relaxed/simple;
	bh=iinmEJVQ0UFa9hH3gYfVIXg3jKM60v7u8JoCa9pm08c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMDsVC+VP/w5aTi8KJRuhOqTG1i1zsec7D54GYYxZyu1b1w8sBEZBCbc4ndKRofNIj0qL9qqnoyMkpZ0lDVR1c8nLpWolV+rPhYPYwVPxqOsl30z0lU9Yt7Ac0SxCsr6JsMdxUfhcBEV72ky2YCGvNaE1dxnOsxPkwpq2tSbk/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9tqf0b+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9tqf0b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AE21F00A3D;
	Fri,  4 Sep 2026 05:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498916;
	bh=2tGubNey3+nbCdC94LCmGNi8fYenCQpFFydmwxxtU+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9tqf0b+34EhJ3EPvyK3peVgu//rqg5IZbDNsaZ4sB/ZiwQMWlm5xjD0Rj3MmW5BY
	 EaGjzxJ5ijnEo5XgN7FM4dUOKEJmtByuoB2Er89x0GkRvyV55cXR64UuTgziiLsSrD
	 PM1kNMuVhin5TAXbNMSBPIDulTdS3F5g4I2nOuAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 234/713] cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
Date: Fri,  4 Sep 2026 06:53:22 +0200
Message-ID: <20260904045809.066961074@linuxfoundation.org>
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

commit 364b183230586a62660a7280c1eb20138338eeb5 upstream.

cifs_do_truncate() is invoked from cifs_open() without i_rwsem, so it
cannot use cifs_resize_file_locked() to perform a proper fscache cookie
resize.  Instead, add cifs_invalidate_cache() after cifs_setsize().

cifs_invalidate_cache() calls fscache_invalidate(), which works without
holding i_rwsem: it unconditionally increments inval_counter and sets
FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data is not
served once the cookie is later activated by fscache_use_cookie().
Truncation to zero leaves no valid cached data, making invalidation the
correct semantic here.

Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1016,6 +1016,7 @@ static int cifs_do_truncate(const unsign
 		if (!rc) {
 			netfs_resize_file(&cinode->netfs, 0, true);
 			cifs_setsize(inode, 0);
+			cifs_invalidate_cache(inode, 0);
 		}
 	}
 	if (cfile)


