Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622868;
	b=4QIg+DTnYzvVD99pouU3IygrWRqMn6u95/sLYhoKRJgMoJ/eka/Eylf2mWAo9ILlorWs
	 LD4T5Fs6CVYjdeIFqtHdiFy5Nb7DyjzqtU6JA0s/6SwTNslegZ4S2LSpQUsLsgDrXRQMQ
	 ghmTs9ziMbGAMJofIa2fFhpFw2YU/F5fmXUonhscP2ZwyOQI0y7aJnxKj0TE0J7Jnsp+X
	 6Sz0lGTnGgnvBwNOWOQqGGm8XlEyYLDL8dRbi4zxu3BUfbvKswUUmox+GRzNX9vhZBVq/
	 SyG/fs5MPZ5Xy1WCp1mApaXLEY2lwiK9Jbm7SMoW2hhIeb4S0CD+lOFFZKLi8AcjTCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1K73wMi7/SYC/BDWZ6RRM6HaXXt3keXGqIlVUzKHANo=;
	b=sO2cVCnu6eJ2L9C3rS8rfRiKk5xoMC3pr2scovGSIiQp8hxF09Lz42nTA5H9knn28P1N
	 y7FMIOiZ8V0HCAZIZgri1aJgFHO3kbh7DNHTKRSA6B05U4kUQy1g4ZffAJIbnaFYxbMo4
	 YcQqLwEQGrROpKnwTci/wgfx+0z+ZyF8eYVaJGLMyLHuyKq1GF38XJeTLwH7SF+0NW9wj
	 wvAPUHHpn8KFH2EXq6mtQjVLEPP68010iKpunkJhqpRAILrgAGeJFBH//J6TvyJKbNTIs
	 jryhGZCXpR3InPzd0rh1SGN1ftOxzkkLR84kPEbxTIhOQ3NixoqCxYqTtauV3O0GrvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWJQgSoN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3FD606A321;
	Wed, 25 Nov 2026 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWJQgSoN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5171F000C0;
	Wed, 25 Nov 2026 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622868;
	bh=1K73wMi7/SYC/BDWZ6RRM6HaXXt3keXGqIlVUzKHANo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWJQgSoNyKPavV4KMlPvJjTg+Dc00pUW7zLG2cIN7yJdld95sHAdy/1T/kqodwIvn
	 64OE2skkaTbbBrRn3OxXrzcEqcbk6zCGl/Hg7m2DeW5GFdBZXEr0q9pO0N4FOoRpHC
	 yukq50/viF8X+5atXnyWw15OyejCIiPqFVePX9gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 674/990] fs: fix the SEEK_CUR f_lock condition
Date: Wed, 25 Nov 2026 15:34:01 +0100
Message-ID: <20261125143837.873652434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 1448959fe3d013ffdb8302d17e4a8fdad2d2da95 upstream.

Commit da06e3c51794 ("fs: don't needlessly acquire f_lock") wanted to
skip f_lock for SEEK_CUR on files that already serialize f_pos through
f_pos_lock, i.e. FMODE_ATOMIC_POS files and directories, and keep it
for everything else. The condition it added does the opposite:
file_seek_cur_needs_f_lock() returns false exactly for the files that
never take f_pos_lock and true for the ones that do.

So since v6.15 a SEEK_CUR on a shared block device or on a character
device that uses fixed_size_llseek() updates f_pos without any lock and
two concurrent calls can lose an update, while regular files and
directories pay for a spinlock they don't need.

Invert the condition.

Fixes: da06e3c51794 ("fs: don't needlessly acquire f_lock")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261106-work-file-seek_f_lock-v1-1-5b9a6c2928d4@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -1210,14 +1210,18 @@ static inline bool file_needs_f_pos_lock
 
 bool file_seek_cur_needs_f_lock(struct file *file)
 {
-	if (!(file->f_mode & FMODE_ATOMIC_POS) && !file->f_op->iterate_shared)
-		return false;
-
 	/*
+	 * Files that go through f_pos_lock when they are shared, i.e.
+	 * FMODE_ATOMIC_POS files and directories, don't need f_lock for a
+	 * SEEK_CUR. Everything else does, since nothing else serializes
+	 * the f_pos update.
+	 *
 	 * Note that we are not guaranteed to be called after fdget_pos() on
 	 * this file obj, in which case the caller is expected to provide the
 	 * appropriate locking.
 	 */
+	if ((file->f_mode & FMODE_ATOMIC_POS) || file->f_op->iterate_shared)
+		return false;
 
 	return true;
 }


