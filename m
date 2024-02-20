Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2922DF9F;
	Tue, 20 Feb 2024 21:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464241; cv=none; b=W482vr5oJVCbk+G24jRZrqGXyF6CN54RbY0eDxNkCd52DUnG6cHGGXeCZTJWPTeZf3DeLk7F8J8Zxv3KUDBSKXnRBd5IskahL2Tl57VdtpfYD5UteJtSV4wAEc7kr4qyCNPst5mfYuJ/Na0diJeHydH8Ht4dEwZFtrcEegJk1GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464241; c=relaxed/simple;
	bh=Vm6DO8sGIBgNJ+dHzQeSaCmPGdGYjWXcNcgk/2NhU48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYjZgGn9d3+Wykluj+Qeohex/tOMKtzKacNmBUKAUcPswC6Y6dEzkKdTvMrjQ7+gFmkP7rdb77CmV+jzscKYx+piej5zV+7NpLSSNm7FEaCwJcleZWPlATbyVt9kPM03Psp2s6sBjPtprsdTV+qG4vAzvwgv9CcmnLIDQKUymh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9u2N+sJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9u2N+sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5A0C433C7;
	Tue, 20 Feb 2024 21:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464241;
	bh=Vm6DO8sGIBgNJ+dHzQeSaCmPGdGYjWXcNcgk/2NhU48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9u2N+sJ0y2jSxLUBoiYqiRbCX/9dHI+aAHEUoNY42c0Z28/zNgpzLsiHdZC069JO
	 y4r0WmTyEbmN5szTfIJ/BJZy/sj689SeKqqaB8tXmoKP/XTlfeH2dioiDw9RZIlMCW
	 JSVDY7zkJLx7y+xmLSmGD4RB81m8syAPSuEM04kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 295/331] eventfs: Have eventfs_iterate() stop immediately if ei->is_freed is set
Date: Tue, 20 Feb 2024 21:56:51 +0100
Message-ID: <20240220205647.317532939@linuxfoundation.org>
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

commit e109deadb73318cf4a3bd61287d969f705df278f upstream.

If ei->is_freed is set in eventfs_iterate(), it means that the directory
that is being iterated on is in the process of being freed. Just exit the
loop immediately when that is ever detected, and separate out the return
of the entry->callback() from ei->is_freed.

Link: https://lore.kernel.org/linux-trace-kernel/20240104220048.016261289@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -788,11 +788,12 @@ static int eventfs_iterate(struct file *
 		name = entry->name;
 
 		mutex_lock(&eventfs_mutex);
-		/* If ei->is_freed, then the event itself may be too */
-		if (!ei->is_freed)
-			r = entry->callback(name, &mode, &cdata, &fops);
-		else
-			r = -1;
+		/* If ei->is_freed then just bail here, nothing more to do */
+		if (ei->is_freed) {
+			mutex_unlock(&eventfs_mutex);
+			goto out;
+		}
+		r = entry->callback(name, &mode, &cdata, &fops);
 		mutex_unlock(&eventfs_mutex);
 		if (r <= 0)
 			continue;


