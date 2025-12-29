Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912FB332EB8;
	Mon, 29 Dec 2025 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025868; cv=none; b=nOft9eBe4JY7aB9jEe1geLOn6VKugkuzX6rjpl/naRM8fHBTBRtw1FDPw5O58PWUoN5U54QMBg603ANPs8nwA7firTZESPdkG0WNqH0JaXNADBcX0ZaA6rZT9f1rYg0UoKjz0lu4huydNfxj4CZ84mc07wsIQjPeBSaThfzgwaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025868; c=relaxed/simple;
	bh=ub9yr0DkGj/P0LB+Fl5sjUJ0tzI+mnFYyLyeYlxiYdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4OH0f6RdX3c58aS5YCNe4DObdNu4YAzHaOh7ma+Nm74MvIKZota9EyB8jpnXg5RzQ/i6RxqVV5k7pExJ+OcA2VK+BVN1/qlmwjqAQ43PdgxE0nmswrhgFpqnSSRmjJT7aRmJbGY6x5HoBPHx8Sk7wy6kxgQkYbN7J+sx+8U9ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvqzF7mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvqzF7mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC17C4CEF7;
	Mon, 29 Dec 2025 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025868;
	bh=ub9yr0DkGj/P0LB+Fl5sjUJ0tzI+mnFYyLyeYlxiYdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvqzF7mYj/xBgYz146JA5EXGSZUBjXykC5FbX9d7GZXqXAdtMBJOdPYRmazEJDiAR
	 VkZO2nKIq1ggeWu5RN+b9gp7SW7XppPQT1uUl6TE8/6FEnKBTP1fsmWKpKTYvDe+HF
	 xNwmy6NkQAhxCmPiao2YfSge/7MTdmmL4tjwxG8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheendra Raghav Neela <sneela@tugraz.at>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.18 365/430] fsnotify: do not generate ACCESS/MODIFY events on child for special files
Date: Mon, 29 Dec 2025 17:12:47 +0100
Message-ID: <20251229160737.760006986@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -270,8 +270,15 @@ int __fsnotify_parent(struct dentry *den
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


