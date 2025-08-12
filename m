Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C4E1FF7C5;
	Tue, 12 Aug 2025 18:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025112; cv=none; b=chyATuS4gkWcycebD5CSgNwk8MIp6YALMj94/8uN91QWochyo3c7YyIuTWM5XFyIKxehD8DqJ2Ts6JatlIHGa7giKYCbZ0CoZ5BsHqceSJN+XdJJ6ac2ZrOfUL6ziF00oEE1JrNFuIYo2foG6eGJLfmu78Ke14p66uJdqab4mbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025112; c=relaxed/simple;
	bh=S8mMM+2lJB8Qj7CRNDnEgyC41Y8n0ZBAdv5RPjPpbhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2zl0qNW/4/7pyzpRmUHIYFshWLGvRIpBCCSDnlVo2RV8Z+YYFK0ki5HByyXU0GUvOePPWTRBG/heZwlTUYMUjm68eXuCY1FFk35T5A+PVts/xO1Ws8nW3Jt8BDD25fimZ/bUAUd6BsiFIPPRivdOOJUfYsAM4pCT9Ch1r0gUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iczBlfSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iczBlfSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8B6C4CEF0;
	Tue, 12 Aug 2025 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025111;
	bh=S8mMM+2lJB8Qj7CRNDnEgyC41Y8n0ZBAdv5RPjPpbhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iczBlfSh+BxzTtN2rQ+U3pOwI/AvSXs9q03mdF5U6pcZA91oKJWFqHG7aAcCcLhvi
	 05Y99umw6itVj6kMscGgRP5pNfOtK5b0V3tNP/NbHtuRf8PWIWqEHKuv8vdIawlJH6
	 ousceDf6JrxblubV+seO5aBi1sBZ8DdykBaquPTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.16 573/627] nfsd: dont set the ctime on delegated atime updates
Date: Tue, 12 Aug 2025 19:34:28 +0200
Message-ID: <20250812173453.674932630@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit f9a348e0de19226fc3c7e81de7677d3fa2c4b2d8 upstream.

Clients will typically precede a DELEGRETURN for a delegation with
delegated timestamp with a SETATTR to set the timestamps on the server
to match what the client has.

knfsd implements this by using the nfsd_setattr() infrastructure, which
will set ATTR_CTIME on any update that goes to notify_change(). This is
problematic as it means that the client will get a spurious ctime
update when updating the atime.

POSIX unfortunately doesn't phrase it succinctly, but updating the atime
due to reads should not update the ctime. In this case, the client is
sending a SETATTR to update the atime on the server to match its latest
value. The ctime should not be advanced in this case as that would
incorrectly indicate a change to the inode.

Fix this by not implicitly setting ATTR_CTIME when ATTR_DELEG is set in
__nfsd_setattr(). The decoder for FATTR4_WORD2_TIME_DELEG_MODIFY already
sets ATTR_CTIME, so this is sufficient to make it skip setting the ctime
on atime-only updates.

Fixes: 7e13f4f8d27d ("nfsd: handle delegated timestamps in SETATTR")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -470,7 +470,15 @@ static int __nfsd_setattr(struct dentry
 	if (!iap->ia_valid)
 		return 0;
 
-	iap->ia_valid |= ATTR_CTIME;
+	/*
+	 * If ATTR_DELEG is set, then this is an update from a client that
+	 * holds a delegation. If this is an update for only the atime, the
+	 * ctime should not be changed. If the update contains the mtime
+	 * too, then ATTR_CTIME should already be set.
+	 */
+	if (!(iap->ia_valid & ATTR_DELEG))
+		iap->ia_valid |= ATTR_CTIME;
+
 	return notify_change(&nop_mnt_idmap, dentry, iap, NULL);
 }
 


