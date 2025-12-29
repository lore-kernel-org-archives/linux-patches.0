Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07698330B2A;
	Mon, 29 Dec 2025 16:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025237; cv=none; b=eUnC+VfyrWTDmCqjwmIWJlzjMaQskNyFOGoRnnqi8XuD9NDYwqeL0ZsLnTmHa0h5de45HlKARUyCpEMTjC8g8s+MFCjofkN6Ua6V7AVPWREWcZpZE+T+Dq2RNKIko+TErwI4eceKQLOalszqc2szR1b5XXbGVJbjlL98a1UD5Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025237; c=relaxed/simple;
	bh=NU9utE+WaoiDZUh+C/VhbYw2vmBaJUHIgElCvbhg9Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGWsf+DbX/t2dDDtvbeSfGrNeP4u26v2/cvoVkfiDiB4Z4ZR8MKvffqN318f/oBd4HFHMn+5c4g0SdbGxHuOb45RxuX80YrQQheMB3wPPTBAlRAX2VUvfXKlO/KwlhHAtsLz0PnBQbrQJ6LTsIHkDZze0the8oGNCNsPw9VxDrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eme6vX5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eme6vX5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CD6C4CEF7;
	Mon, 29 Dec 2025 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025236;
	bh=NU9utE+WaoiDZUh+C/VhbYw2vmBaJUHIgElCvbhg9Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eme6vX5O0iJ4jS7a6+joKVsXUFlK1PpJlbDtu9nzvKqmYIgWfIO2xkpNxif0GoF+c
	 uy43yirI9ENeku1ndiwyuw0Ix0S58kV8lCch9gPjNC/kdjNJ+A/jXkrNqFzcQBsIX6
	 YAiAWfVLiigF2qggYIQ2/SqaTiv4NlhEfIC0zbBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 143/430] ksmbd: skip lock-range check on equal size to avoid size==0 underflow
Date: Mon, 29 Dec 2025 17:09:05 +0100
Message-ID: <20251229160729.624921528@linuxfoundation.org>
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

From: Qianchang Zhao <pioooooooooip@gmail.com>

commit 5d510ac31626ed157d2182149559430350cf2104 upstream.

When size equals the current i_size (including 0), the code used to call
check_lock_range(filp, i_size, size - 1, WRITE), which computes `size - 1`
and can underflow for size==0. Skip the equal case.

Cc: stable@vger.kernel.org
Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -324,6 +324,9 @@ static int check_lock_range(struct file
 	struct file_lock_context *ctx = locks_inode_context(file_inode(filp));
 	int error = 0;
 
+	if (start == end)
+		return 0;
+
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
@@ -828,7 +831,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work
 		if (size < inode->i_size) {
 			err = check_lock_range(filp, size,
 					       inode->i_size - 1, WRITE);
-		} else {
+		} else if (size > inode->i_size) {
 			err = check_lock_range(filp, inode->i_size,
 					       size - 1, WRITE);
 		}


