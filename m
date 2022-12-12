Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D5928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA15C433D2;
	Mon, 12 Dec 2022 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852119;
	bh=OvIH+/rzbE4iIJMXArCK3MshVpQL1tOZGfQMHYX+yj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVo7LKQWIVGP5+wU2pRr2ksEdUk7Ls3h8SmZEQdxlGlUbqTH3pKW1YEi92Atwe7gd
	 yT0wfjPHBndNGB5/eswsTg08r018RH3a1Cc32iyZ9QbgGnEjrBFKcfURaHy5spq//m
	 mMTuNj3p58wVFinG0ui1/klytVxoWW14UBSTJRzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 015/157] fs: use acquire ordering in __fget_light()
Date: Mon, 12 Dec 2022 14:16:03 +0100
Message-Id: <20221212130935.047230694@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jann Horn <jannh@google.com>

[ Upstream commit 7ee47dcfff1835ff75a794d1075b6b5f5462cfed ]

We must prevent the CPU from reordering the files->count read with the
FD table access like this, on architectures where read-read reordering is
possible:

    files_lookup_fd_raw()
                                  close_fd()
                                  put_files_struct()
    atomic_read(&files->count)

I would like to mark this for stable, but the stable rules explicitly say
"no theoretical races", and given that the FD table pointer and
files->count are explicitly stored in the same cacheline, this sort of
reordering seems quite unlikely in practice...

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 3bcc1ecc314a..57af5f8375fd 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1002,7 +1002,16 @@ static unsigned long __fget_light(unsigned int fd, fmode_t mask)
 	struct files_struct *files = current->files;
 	struct file *file;
 
-	if (atomic_read(&files->count) == 1) {
+	/*
+	 * If another thread is concurrently calling close_fd() followed
+	 * by put_files_struct(), we must not observe the old table
+	 * entry combined with the new refcount - otherwise we could
+	 * return a file that is concurrently being freed.
+	 *
+	 * atomic_read_acquire() pairs with atomic_dec_and_test() in
+	 * put_files_struct().
+	 */
+	if (atomic_read_acquire(&files->count) == 1) {
 		file = files_lookup_fd_raw(files, fd);
 		if (!file || unlikely(file->f_mode & mask))
 			return 0;
-- 
2.35.1



