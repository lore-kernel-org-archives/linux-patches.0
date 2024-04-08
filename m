Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1E779F0;
	Mon,  8 Apr 2024 13:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583599; cv=none; b=oqfzjkbYspSSEwwIYLkM8ZK1kaPgMu4c/ZbXdtH43K3IqlZwl/TPEM+7wHeNlW6n2JIFkXBBkYCY7P9ZWskC/tBNrNqRW0mnXLHNRlYmuhL2zTlT0vfOlFI5/5i04VWZlqeXc6NMXEZGlLbf7b0bxaXq1dWy7BSDWDFkECeRjkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583599; c=relaxed/simple;
	bh=4vYMasS44HXmQCcW/sQikVObimYiBftAwl1iIWrnD84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyR8YLtfkWVxXrMnO/rZLlmoYzxf8fWK7COPhn5d9CVZuqeOkGTRALgzhZ99TRjDZ0oAWVHt9W7CxtQAAeSvrd6De7qIrFxmPeuudbiYNM1Q9hOwtWFMSEdhjDCwKwo+fLH/Y8Q1hUrUkqQ5FV8GESI2JcBzIsh4vZlhhc3un0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRSesKLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRSesKLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E8EC433C7;
	Mon,  8 Apr 2024 13:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583599;
	bh=4vYMasS44HXmQCcW/sQikVObimYiBftAwl1iIWrnD84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRSesKLv5Z+vrX4laXfGSsVv4d5F61ytHpNnMfzZ8/FS9txP50qDU1AKkzwaSKkKw
	 q0WtmhKlZTVlenUKSJJnbmHdvNGMYPf5mVjYl14xrvJylSRMdJ96FHslZKe3Zwffpf
	 VgE9gC9/US2cZGp9PoJ58JUU+iJzio1Op49zTfOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Delalande <colona@arista.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 265/690] fsnotify: invalidate dcache before IN_DELETE event
Date: Mon,  8 Apr 2024 14:52:11 +0200
Message-ID: <20240408125409.218664108@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a37d9a17f099072fe4d3a9048b0321978707a918 ]

Apparently, there are some applications that use IN_DELETE event as an
invalidation mechanism and expect that if they try to open a file with
the name reported with the delete event, that it should not contain the
content of the deleted file.

Commit 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of
d_delete()") moved the fsnotify delete hook before d_delete() so fsnotify
will have access to a positive dentry.

This allowed a race where opening the deleted file via cached dentry
is now possible after receiving the IN_DELETE event.

To fix the regression, create a new hook fsnotify_delete() that takes
the unlinked inode as an argument and use a helper d_delete_notify() to
pin the inode, so we can pass it to fsnotify_delete() after d_delete().

Backporting hint: this regression is from v5.3. Although patch will
apply with only trivial conflicts to v5.4 and v5.10, it won't build,
because fsnotify_delete() implementation is different in each of those
versions (see fsnotify_link()).

A follow up patch will fix the fsnotify_unlink/rmdir() calls in pseudo
filesystem that do not need to call d_delete().

Link: https://lore.kernel.org/r/20220120215305.282577-1-amir73il@gmail.com
Reported-by: Ivan Delalande <colona@arista.com>
Link: https://lore.kernel.org/linux-fsdevel/YeNyzoDM5hP5LtGW@visor/
Fixes: 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of d_delete()")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
[ cel: adjusted to apply on v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/fsnotify.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index c80f448b9b0f2..bb8467cd11ae2 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -240,7 +240,8 @@ static inline void fsnotify_delete(struct inode *dir, struct inode *inode,
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
-	fsnotify_name(dir, mask, inode, &dentry->d_name, 0);
+	fsnotify_name(mask, inode, FSNOTIFY_EVENT_INODE, dir, &dentry->d_name,
+		      0);
 }
 
 /**
-- 
2.43.0



