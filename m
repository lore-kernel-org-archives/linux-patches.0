Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70E48F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AB9C433C7;
	Sun, 16 Jul 2023 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539450;
	bh=ycImygvbZDTq4k5kMjlqHNll0+3pnHoUPou8YLUYNUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oObSnY4LD5DKf6lOhNOQNJLEL0DcvNZMmkTkjYOc7fKV4oQYzh3hky4MSw/kQ2G7g
	 Fhgn9XvKHy6Lwenj/H7SkYjQssuzYRuTdNdsO4JJKi/AM37UC4Pl+IhhO/tuhPflI3
	 w2hsNJeu4SclF+v7zLayOpEXzV3q3y2ZMFsLXE94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/591] fs: pipe: reveal missing function protoypes
Date: Sun, 16 Jul 2023 21:42:21 +0200
Message-ID: <20230716194923.929729751@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 247c8d2f9837a3e29e3b6b7a4aa9c36c37659dd4 ]

A couple of functions from fs/pipe.c are used both internally
and for the watch queue code, but the declaration is only
visible when the latter is enabled:

fs/pipe.c:1254:5: error: no previous prototype for 'pipe_resize_ring'
fs/pipe.c:758:15: error: no previous prototype for 'account_pipe_buffers'
fs/pipe.c:764:6: error: no previous prototype for 'too_many_pipe_buffers_soft'
fs/pipe.c:771:6: error: no previous prototype for 'too_many_pipe_buffers_hard'
fs/pipe.c:777:6: error: no previous prototype for 'pipe_is_unprivileged_user'

Make the visible unconditionally to avoid these warnings.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Message-Id: <20230516195629.551602-1-arnd@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pipe_fs_i.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 6cb65df3e3ba5..28b3c6a673975 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -241,18 +241,14 @@ void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
 extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
 
-#ifdef CONFIG_WATCH_QUEUE
 unsigned long account_pipe_buffers(struct user_struct *user,
 				   unsigned long old, unsigned long new);
 bool too_many_pipe_buffers_soft(unsigned long user_bufs);
 bool too_many_pipe_buffers_hard(unsigned long user_bufs);
 bool pipe_is_unprivileged_user(void);
-#endif
 
 /* for F_SETPIPE_SZ and F_GETPIPE_SZ */
-#ifdef CONFIG_WATCH_QUEUE
 int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots);
-#endif
 long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
 struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice);
 
-- 
2.39.2



