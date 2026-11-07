Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065607;
	b=axgItTQTBi9jN5ryx6rWV5n5ct9MsgD/CqUr9P4w1d0zl/iCQATVrpO8q6ZnA7Q2QDK3
	 oWZJIS73A4C1bpUiySDevlDyPUKt04t7WeAuDg4C16OHK0T66QqGdHFFRH+S5nhOE79BG
	 +cfugl5pLIx1r3vmaAr9m4xTne2hZ+3Sb6fgWWyjPmhNKESi2uY/zi13PFWxQOIUI9/tz
	 nXj8/1ls+rWSFQdIKCAHyYLg/OAjFHJa0MLbLrHjx7yNiZ8JWoSNuFhqziTmi++q6pUJD
	 zzoiuKn2vFsHwy/P6kZQuSeeoPyb6K1z5tCSaoXWZrHVCte0n+Qy9bNh7EIocD6Yydw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vK+K3JNgfDXjS4SMHc64qI4UPjfgxw+WmfIWmK722XQ=;
	b=0YeQ5o2GF6O1xfwdcgEH5oNGjXY0tNN+ft9h+p/Fdb1nPY6n4zVUs/FyQLZD6cW6S6/0
	 lg/I5OxmE6KHzlQcvHkOjtd3mCb2TdrcTenrpa04txqGSlr9dFqk7rAbcsL1BwMAVToPP
	 /5kUfOIGNgsk8knf7CGHNekCj2mTC13oGsxWCDaLa+/THlnDCMIM2wVb6riVqrRuADHfp
	 Xhm0E/7SnPO0dL+BHQV6siPge3K9s380Hk8sdfwDOr7pj96/Sz7l2qcR1ufPYak30zZv1
	 Ya+RxRf3MPbXXSMWwSzCyIKd41RuAHJN4mt6BivODTxOl9VKGmrwgC6mNO24v2kDMjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yR6LQrzG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F73606A32C;
	Sat,  7 Nov 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yR6LQrzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2215C1F0089F;
	Sat,  7 Nov 2026 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065607;
	bh=vK+K3JNgfDXjS4SMHc64qI4UPjfgxw+WmfIWmK722XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yR6LQrzGm1f0V4+TwNM/LGhbYuKixOUm89Gqm6YHmKCjNNGmUhbjos2nWyRbqG+8d
	 kfhk0hCNuAD71P+1pHRt9kIIrVzXA2qzUcUrZ2nGSiIc9lmjimlfU+p4E021PBuadc
	 6IuLOyJoYtbAQ+mti67WcU2eiL14j8EtOdGhFKOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1249/1257] splice: avoid stale f_pos writeback on error
Date: Sat,  7 Nov 2026 08:59:05 -0500
Message-ID: <20261107135013.816356152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 79b496ebe382866e3a05090b7dc9ae95e85e65b2 ]

do_splice() snapshots an implicit file position before calling the splice
helper. Since splice does not take f_pos_lock, another operation on the
same open file description can update f_pos while the helper is blocked.
If the helper then fails, the unconditional writeback restores the stale
snapshot.

For a directory without ->splice_read, a file-to-pipe splice fails with
-EINVAL. A concurrent directory mutation and getdents() call can advance
f_pos and refresh the filesystem's revalidation cookie before that failure
restores only the old position. The next ext2 readdir can then trust an
offset inside a directory entry and copy data from the adjacent page to
userspace.

Only update an implicit file position when splice returns a non-negative
result, matching read and write. Keep explicit offset updates unchanged.

Fixes: 7995bd287134 ("splice: don't pass the address of ->f_pos to methods")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20261018051708.2422394-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1ab..96378d3e65580 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1349,10 +1349,10 @@ ssize_t do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
-		if (!off_out)
-			out->f_pos = offset;
-		else
+		if (off_out)
 			*off_out = offset;
+		else if (ret >= 0)
+			out->f_pos = offset;
 	} else if (opipe) {
 		if (off_out)
 			return -ESPIPE;
@@ -1373,10 +1373,10 @@ ssize_t do_splice(struct file *in, loff_t *off_in, struct file *out,
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
 
-		if (!off_in)
-			in->f_pos = offset;
-		else
+		if (off_in)
 			*off_in = offset;
+		else if (ret >= 0)
+			in->f_pos = offset;
 	} else {
 		ret = -EINVAL;
 	}
-- 
2.53.0



