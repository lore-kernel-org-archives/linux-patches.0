Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE65281369;
	Fri,  7 Aug 2026 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115668; cv=none; b=Gq7njdBRsvzsEzvX6JDW5PvroWWHYfxhRvLbFPo/SDNAllvzsnIsrYJAALoT4Xz6PBKcfO4h5faUksm2vlqtwM8T7hQO8h+P3QW/L8F/xpvRgb0x6EJFE0w8tv7aPOew7RHk5JMLO0jaTMWQxu3MI9VclQEg7rlo1RGUhDqaGoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115668; c=relaxed/simple;
	bh=esB68w5C8SiTQwZRyUYlRjQbI2ydd0IAk6/Hha71Miw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3FpRspUSsLrujVQrKqgQGKJ7cHfi5KS9YmYP8ywbljlBSYqTAR/TN8MMpvLbN4At4BZcOSkY88i1Ku+1rsDk0KBe/1/FPzM1k5Mj3aASTO+M8xUPtVSQ7IJqvzLxsHIevulirMC+5sJEWib03Rl8oxUaiBGLsZymOmup70qXj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJT/Bm4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJT/Bm4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16A21F000E9;
	Fri,  7 Aug 2026 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115667;
	bh=lfKTOEteIohLcxfmejT7YD9urb6Wc4xc1qjCYiWddvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJT/Bm4lmK8FjzmjO7d0NcJo8EOp9pdbJWw0fvnmFwCc55zD1k4XCD8XvFmV2813p
	 3nZ/7WUHUOmtDz3drYFhrf690Yk0J9+9bjKh8ip61bmXcIokGyc3cS9ygPfSP6KC5R
	 6Y72+3DLDLz3mWl5IBHhQljETwHiR1CkVHpNI5lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 357/396] file: ensure cleanup
Date: Fri,  7 Aug 2026 16:38:37 +0200
Message-ID: <20260807143431.984485239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit d2ea4d254d04a89e17504af0230c7268e3cac6bf ]

Brown paper bag time. This is a silly oversight where I missed to drop
the error condition checking to ensure we clean up on early error
returns. I have an internal unit testset coming up for this which will
catch all such issues going forward.

Reported-by: Chris Mason <clm@fb.com>
Reported-by: Jeff Layton <jlayton@kernel.org>
Fixes: 011703a9acd7 ("file: add FD_{ADD,PREPARE}()")
Signed-off-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit d2ea4d254d04a89e17504af0230c7268e3cac6bf)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/file.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index cf389fde9bc28..27484b444d315 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -161,12 +161,10 @@ typedef struct fd_prepare class_fd_prepare_t;
 /* Do not use directly. */
 static inline void class_fd_prepare_destructor(const struct fd_prepare *fdf)
 {
-	if (unlikely(fdf->err)) {
-		if (likely(fdf->__fd >= 0))
-			put_unused_fd(fdf->__fd);
-		if (unlikely(!IS_ERR_OR_NULL(fdf->__file)))
-			fput(fdf->__file);
-	}
+	if (unlikely(fdf->__fd >= 0))
+		put_unused_fd(fdf->__fd);
+	if (unlikely(!IS_ERR_OR_NULL(fdf->__file)))
+		fput(fdf->__file);
 }
 
 /* Do not use directly. */
@@ -230,7 +228,8 @@ static inline int class_fd_prepare_lock_err(const struct fd_prepare *fdf)
 		VFS_WARN_ON_ONCE(fdp->__fd < 0);               \
 		VFS_WARN_ON_ONCE(IS_ERR_OR_NULL(fdp->__file)); \
 		fd_install(fdp->__fd, fdp->__file);            \
-		fdp->__fd;                                     \
+		retain_and_null_ptr(fdp->__file);              \
+		take_fd(fdp->__fd);                            \
 	})
 
 /* Do not use directly. */
-- 
2.53.0



