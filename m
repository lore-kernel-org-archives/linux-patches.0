Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370421C3F0D;
	Tue, 27 Aug 2024 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771633; cv=none; b=klMNCJlb+DmluvAemiOhZj1pSNB2cX1F7bzjqwYQYnnBud8GnkIuNYKZoUt2UPlE5gVJVD2zXAkosWYc4GRFNYsNArKOPpyYnhNwi5kkSA0yrrgajq1SnQ3+MVQ9dQAWZKtO4js7FkHh1IKQWqI7sQ6Wz9CnZLmfqe/aGfrj9uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771633; c=relaxed/simple;
	bh=9F3i0rzty8ZoTdaXLEnuqvdul1NxGvBjoRiJgMBqaec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDaOy7M1AifclpLSiZkBF7zRBe9d3V6Qpw16kDWcAwpf8RBgabnNuXA3USZ0c5Uk9yw/NLgQ1qvwOLeTHBZxs0ZK+kQT01VeTDKw3qoYEAkcsUR6MBlTvAWpZ5P2RqJ1NznzqEa0H4aivORBOK5b2Jgqsa90Ep7MiTGXtG9TYbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l++xFsYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l++xFsYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD18C61070;
	Tue, 27 Aug 2024 15:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771632;
	bh=9F3i0rzty8ZoTdaXLEnuqvdul1NxGvBjoRiJgMBqaec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l++xFsYQGHjaFjH//4q3Xl5UM8PfjG5AXEzZp1LtV5LVzIe8Zd/KCDviJEtVLpniM
	 Jsv6ofvdoPJ4HvfUFpCPuwRDPbK99iGdF+ofvqFc5NIrnrWBkLSF6woTk60moD/6lS
	 NYiYA0P2J/grkco5r/hxLFrfNZT6T04gOx2bS+vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Shilovsky <piastryyy@gmail.com>,
	David Howells <dhowells@redhat.com>,
	abartlet@samba.org,
	Kevin Ottens <kevin.ottens@enioka.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 248/273] smb3: fix broken cached reads when posix locks
Date: Tue, 27 Aug 2024 16:39:32 +0200
Message-ID: <20240827143842.840603689@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit e4be320eeca842a3d7648258ee3673f1755a5a59 upstream.

Mandatory locking is enforced for cached reads, which violates
default posix semantics, and also it is enforced inconsistently.
This affected recent versions of libreoffice, and can be
demonstrated by opening a file twice from the same client,
locking it from handle one and trying to read from it from
handle two (which fails, returning EACCES).

There is already a mount option "forcemandatorylock"
(which defaults to off), so with this change only when the user
intentionally specifies "forcemandatorylock" on mount will we
break posix semantics on read to a locked range (ie we will
only fail in this case, if the user mounts with
"forcemandatorylock").

An earlier patch fixed the write path.

Fixes: 85160e03a79e ("CIFS: Implement caching mechanism for mandatory brlocks")
Cc: stable@vger.kernel.org
Cc: Pavel Shilovsky <piastryyy@gmail.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Reported-by: abartlet@samba.org
Reported-by: Kevin Ottens <kevin.ottens@enioka.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2912,9 +2912,7 @@ cifs_strict_readv(struct kiocb *iocb, st
 	if (!CIFS_CACHE_READ(cinode))
 		return netfs_unbuffered_read_iter(iocb, to);
 
-	if (cap_unix(tcon->ses) &&
-	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) {
 		if (iocb->ki_flags & IOCB_DIRECT)
 			return netfs_unbuffered_read_iter(iocb, to);
 		return netfs_buffered_read_iter(iocb, to);


