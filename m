Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD913A877;
	Tue, 18 Jun 2024 12:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714941; cv=none; b=qx+MjKRGzXpIhp6JBysZPJov+PxEqNzmbNbtlgdGqwlywiOHIu66OZVA+L9A1QT4fu+ro/aeU4TYev5zReiBsutMgoSpKsdPw98TqII/fkbp1G6mBSMLv/9CW/ug9C1gPFb/SsCzk2IYlmcxiAiZuMfP2LYVCnCYlK8WNHL2GnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714941; c=relaxed/simple;
	bh=GqRQ7G+3OY1F/s28gjKsbshzPehBzbukfxkaTpd+JsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pa3sMc9iL+EC6M8MtH4FLUy3+NxHI6bIFGmEKaot3VBL2h6E7dY7EziLqrK0V3/LFyQyzIhhWDIuCajwAh29uATJPs+D6nYCJRc2SJcqsmBj9e7nMORBEZyfzk1XvRtsZXXA1TdMJizW3RpiX4GzGdO2UmE5I4kJSpY9j7WjA/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDvGbVPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDvGbVPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B14C3277B;
	Tue, 18 Jun 2024 12:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714940;
	bh=GqRQ7G+3OY1F/s28gjKsbshzPehBzbukfxkaTpd+JsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDvGbVPBJzxoy70VJ2aqn8gMZucxz2hHEZ/blzUSzccB7fz1zaSd6PWozUzS7hbUV
	 RbOE0fhwYZ2oovizqhWC4j+BXCHJrw0O9A5OtbjLcY8Q3+Il+EGKnlkimGOT3nXUSr
	 XTigpOhyDCVKiYCW/z/1p1Ovg+ONWoBaUOX1E/V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/770] exec: Remove reset_files_struct
Date: Tue, 18 Jun 2024 14:29:22 +0200
Message-ID: <20240618123411.480913996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 950db38ff2c01b7aabbd7ab4a50b7992750fa63d ]

Now that exec no longer needs to restore the previous value of current->files
on error there are no more callers of reset_files_struct so remove it.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-3-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-3-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c               | 12 ------------
 include/linux/fdtable.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index d6bc73960e4ac..5065252bb474e 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -466,18 +466,6 @@ void put_files_struct(struct files_struct *files)
 	}
 }
 
-void reset_files_struct(struct files_struct *files)
-{
-	struct task_struct *tsk = current;
-	struct files_struct *old;
-
-	old = tsk->files;
-	task_lock(tsk);
-	tsk->files = files;
-	task_unlock(tsk);
-	put_files_struct(old);
-}
-
 void exit_files(struct task_struct *tsk)
 {
 	struct files_struct * files = tsk->files;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index b32ab2163dc2d..c0ca6fb3f0f95 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -108,7 +108,6 @@ struct task_struct;
 
 struct files_struct *get_files_struct(struct task_struct *);
 void put_files_struct(struct files_struct *fs);
-void reset_files_struct(struct files_struct *);
 int unshare_files(void);
 struct files_struct *dup_fd(struct files_struct *, unsigned, int *) __latent_entropy;
 void do_close_on_exec(struct files_struct *);
-- 
2.43.0



