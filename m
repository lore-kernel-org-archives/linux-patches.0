Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10859151CCC;
	Tue, 20 Feb 2024 21:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464929; cv=none; b=nmHrxvpZhJPeIdypmU5rS7FMYNPFDstBxJYFn1azZxqE6JewG+CVc0ZJmMzJGsPZPDcd4ipKhOMf+1vbFMRgUBQ1dM1GxwbTV/qkFc/bZblgJNRTHtw9o53qxBchsLFnEynJ9Gja8NQ7DT0NZO2dl7wwnlRoynwk6e1hAB7C8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464929; c=relaxed/simple;
	bh=jVskncKibh//SLhl6XydsQCqAm6Y1+rUPbHw2eZ3/80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHlRZwgLGBLDUZDTo5nliA3tPuz7a6J7hXHLwqnBNf776N2pn2jTWaRcdlj14rxhXKT024EPyNq/Mc9EMDBM1TznGjESSUVDFbrJKkjU/ByS2Z7M+9J4jGVHGeGcz/T/PGFwZWkd+yuB9rBWl8zYTLnd1oQyqShQ8VtP64UCaO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbeVFtOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbeVFtOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D50C433F1;
	Tue, 20 Feb 2024 21:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464928;
	bh=jVskncKibh//SLhl6XydsQCqAm6Y1+rUPbHw2eZ3/80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbeVFtOhdBFhg3lIkxDbdx/Q1OALryRszWiVPTYL0VlwYdxChXHLLyaAOxfSleKYN
	 L8tjNo4Emza01ZGRf64h7NhuhIkmtZrWLsgu5MC8nFVoJ+O7yY1WqR/txiysDaaYYC
	 ZDrH1/wtBs2XOPDmUKPagJ01KHnoCCUCd5639/qE=
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
Subject: [PATCH 6.7 181/309] eventfs: Have eventfs_iterate() stop immediately if ei->is_freed is set
Date: Tue, 20 Feb 2024 21:55:40 +0100
Message-ID: <20240220205638.812185201@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -750,11 +750,12 @@ static int eventfs_iterate(struct file *
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


