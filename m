Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B781B2DF9F;
	Tue, 20 Feb 2024 21:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464159; cv=none; b=mVvRxryiJ51zOQkHTrC8YRBHWJmHq+qz2AU8V4mGVuhzcsee6oNbubRStLBJhNmbObVEzM+ZnhoQJl43zbVwykrKV1yF1BBWVqWCCpqXg8DnExE+gSHUauQgGlUu5iMCOX+KtMiuUVh5wOyfxPDMldgGuNLLSC6c+MhRgFGLmX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464159; c=relaxed/simple;
	bh=+/3AlPXUmEujHBwj5xjV72ji8ZJKz+U1eWEfr04tHQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/60vB5goRmHcudHS4Y/WAT7s/hJaGyKDv7CytpOFekCqp4OQI/a5A8iO5/5FHAftcQOzIengoWdZzuXGDPVQZmZXZ8Se6kEL+da+P+lDVcL7/oRrJMpQanHxMlz2V3L0XAufdWuJGJ6mDo4Un6MNwyopkyUUCu8eJgUFAGVV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFuJReQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFuJReQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E297C433C7;
	Tue, 20 Feb 2024 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464159;
	bh=+/3AlPXUmEujHBwj5xjV72ji8ZJKz+U1eWEfr04tHQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFuJReQaWTPrDgcdTKjYsD1inJ0t8NRwmY2rHovfV6z3vozl/5NXOSqqU6jCUwjW7
	 +h+nnUYZYqkcETP6N0dZIbzooHm84NhqiHt1Ly/gMOnUaBnEW0naoAdZrzqKRyz1X1
	 3APckwDz3+kpH4ExHJtrI243W9bRPMHzcYdt70eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 269/331] eventfs: Fix WARN_ON() in create_file_dentry()
Date: Tue, 20 Feb 2024 21:56:25 +0100
Message-ID: <20240220205646.336704175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit a9de4eb15ad430fe45747c211e367da745a90093 upstream.

As the comment right above a WARN_ON() in create_file_dentry() states:

  * Note, with the mutex held, the e_dentry cannot have content
  * and the ei->is_freed be true at the same time.

But the WARN_ON() only has:

  WARN_ON_ONCE(ei->is_free);

Where to match the comment (and what it should actually do) is:

  dentry = *e_dentry;
  WARN_ON_ONCE(dentry && ei->is_free)

Also in that case, set dentry to NULL (although it should never happen).

Link: https://lore.kernel.org/linux-trace-kernel/20231024123628.62b88755@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -264,8 +264,9 @@ create_file_dentry(struct eventfs_inode
 		 * Note, with the mutex held, the e_dentry cannot have content
 		 * and the ei->is_freed be true at the same time.
 		 */
-		WARN_ON_ONCE(ei->is_freed);
 		dentry = *e_dentry;
+		if (WARN_ON_ONCE(dentry && ei->is_freed))
+			dentry = NULL;
 		/* The lookup does not need to up the dentry refcount */
 		if (dentry && !lookup)
 			dget(dentry);


