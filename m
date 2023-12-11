Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB04C2D0;
	Mon, 11 Dec 2023 18:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOBY97VT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8E8C433C7;
	Mon, 11 Dec 2023 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319519;
	bh=N2phUe92eyWjvfJ73Unsr3GzYc2LHsgMOgy3VHYYp/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOBY97VTuTGqXS+XpX1fzM3qVnR0zXmBDmBm1W9JtbEi35rzDTH/0tfZRYv+rugp5
	 5vqw5/otlIhfFJSiH/RXfm82zwCRK6H0Tg4Xj/4aFnq1f48yI1LHZ8Qw9VrY/dsNL+
	 +4LX6QwrZ1VhgqUS7kz65vzYBI0jtH62I+8S9SyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 134/244] io_uring/af_unix: disable sending io_uring over sockets
Date: Mon, 11 Dec 2023 19:20:27 +0100
Message-ID: <20231211182051.807348021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 705318a99a138c29a512a72c3e0043b3cd7f55f4 upstream.

File reference cycles have caused lots of problems for io_uring
in the past, and it still doesn't work exactly right and races with
unix_stream_read_generic(). The safest fix would be to completely
disallow sending io_uring files via sockets via SCM_RIGHT, so there
are no possible cycles invloving registered files and thus rendering
SCM accounting on the io_uring side unnecessary.

Cc:  <stable@vger.kernel.org>
Fixes: 0091bfc81741b ("io_uring/af_unix: defer registered files gc to io_uring release")
Reported-and-suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.h |    7 -------
 net/core/scm.c  |    6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -77,17 +77,10 @@ int io_sqe_files_register(struct io_ring
 
 int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file);
 
-#if defined(CONFIG_UNIX)
-static inline bool io_file_need_scm(struct file *filp)
-{
-	return !!unix_get_socket(filp);
-}
-#else
 static inline bool io_file_need_scm(struct file *filp)
 {
 	return false;
 }
-#endif
 
 static inline int io_scm_file_account(struct io_ring_ctx *ctx,
 				      struct file *file)
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -26,6 +26,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/errqueue.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 
@@ -103,6 +104,11 @@ static int scm_fp_copy(struct cmsghdr *c
 
 		if (fd < 0 || !(file = fget_raw(fd)))
 			return -EBADF;
+		/* don't allow io_uring files */
+		if (io_uring_get_socket(file)) {
+			fput(file);
+			return -EINVAL;
+		}
 		*fpp++ = file;
 		fpl->count++;
 	}


