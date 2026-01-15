Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3233C1997;
	Thu, 15 Jan 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499533; cv=none; b=URsrTo3GcUCmzQVJL87PRgD+ISUp97NEb6iPDZua+i/gvFtXhxHJJBNxMtwM8TS7Ee7Lh4s4foSPmrSJ+2jR0fffpXC9GkFEL603/yukzfDyk3lACcpYnLhdIlNIn13sZ5/53y/KC5PZvv7L2O6+gRLyqCGyct9WTiCk+kIcLLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499533; c=relaxed/simple;
	bh=ZprC0EeYwiwjVNEmspJ/mecko7OoMoCmLh7kIugPd2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afXPwKzG/C5mwcJ1oXFki6JSynD3iSJ2pZWJxc3IboCX5OUw5n8Yq2NJj83c9mRW6hesSoZFo8OCavSgOR0865f/ZDaWI6GnmtKeRX3qxYAY9vUxMer9dHpTJxiOvcQfNnk0S3ZcUBszRPUGGTBNtrXQjoTf05GtqrhtpGegFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1SRnPpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1SRnPpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A089C116D0;
	Thu, 15 Jan 2026 17:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499533;
	bh=ZprC0EeYwiwjVNEmspJ/mecko7OoMoCmLh7kIugPd2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1SRnPpMfudw46XdS0Drmd9cSjbK4jVrBvH4rWKFYNi0Rnq/ea6RnHI9VGJiR7E/B
	 FKux88hpXpQAo3fVhjTm6mr4BtXNdOe0yjEE/ahC6Fj9HSnClqiANwS9L0aE8qRzLt
	 VpIj0CupuilVHb60pOHizaDmEJ7XcFTA39n5gUyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheendra Raghav Neela <sneela@tugraz.at>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 260/451] fsnotify: do not generate ACCESS/MODIFY events on child for special files
Date: Thu, 15 Jan 2026 17:47:41 +0100
Message-ID: <20260115164240.293205736@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 635bc4def026a24e071436f4f356ea08c0eed6ff upstream.

inotify/fanotify do not allow users with no read access to a file to
subscribe to events (e.g. IN_ACCESS/IN_MODIFY), but they do allow the
same user to subscribe for watching events on children when the user
has access to the parent directory (e.g. /dev).

Users with no read access to a file but with read access to its parent
directory can still stat the file and see if it was accessed/modified
via atime/mtime change.

The same is not true for special files (e.g. /dev/null). Users will not
generally observe atime/mtime changes when other users read/write to
special files, only when someone sets atime/mtime via utimensat().

Align fsnotify events with this stat behavior and do not generate
ACCESS/MODIFY events to parent watchers on read/write of special files.
The events are still generated to parent watchers on utimensat(). This
closes some side-channels that could be possibly used for information
exfiltration [1].

[1] https://snee.la/pdf/pubs/file-notification-attacks.pdf

Reported-by: Sudheendra Raghav Neela <sneela@tugraz.at>
CC: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fsnotify.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -224,8 +224,15 @@ int __fsnotify_parent(struct dentry *den
 	/*
 	 * Include parent/name in notification either if some notification
 	 * groups require parent info or the parent is interested in this event.
+	 * The parent interest in ACCESS/MODIFY events does not apply to special
+	 * files, where read/write are not on the filesystem of the parent and
+	 * events can provide an undesirable side-channel for information
+	 * exfiltration.
 	 */
-	parent_interested = mask & p_mask & ALL_FSNOTIFY_EVENTS;
+	parent_interested = mask & p_mask & ALL_FSNOTIFY_EVENTS &&
+			    !(data_type == FSNOTIFY_EVENT_PATH &&
+			      d_is_special(dentry) &&
+			      (mask & (FS_ACCESS | FS_MODIFY)));
 	if (parent_needed || parent_interested) {
 		/* When notifying parent, child should be passed as data */
 		WARN_ON_ONCE(inode != fsnotify_data_inode(data, data_type));


