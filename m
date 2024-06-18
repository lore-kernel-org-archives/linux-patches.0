Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBCF13A877;
	Tue, 18 Jun 2024 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714944; cv=none; b=NuxcfPupMeeW3kaMzw4oqrZOEj/Eddp7zD8z+oxa29N/AZzqP7H2VDSnMLE8AS4fZDMfpAXMPAn31d2InVC8jmXeaNiYuJ5GSwqC9421sDlLdXylnxTGrYXA4DQw4IL2Fau0rCWCd/jK+2p8eRpDb8e5YkVu35ooujtfKJ0Af6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714944; c=relaxed/simple;
	bh=JtR56w20488SmXbiDi9/2z/1hgEAIq9Zfop4270heHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDwZwxBi4J7tV/D7Ysl7IToChSHTwaa+yyLHt9/m6U+kqbmvVpd/E06KeYsNpmJcwyHZs/01xA4tgjTwkCoS15C2NKbI8OH4gjtGpi3sU1aAtDBhA3GYxTtWgHPIoxilidxZ1lJmsGi0p9YRE5OgT8gGfXsgZPiGOZm3xXXP53U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4bfXKsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4bfXKsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DEAC3277B;
	Tue, 18 Jun 2024 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714943;
	bh=JtR56w20488SmXbiDi9/2z/1hgEAIq9Zfop4270heHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4bfXKsDyZityJN/1dMnYo0NWALjOUHKLFVWTYMnqi9GQCrrraYzUnPjnZTZ3jwwq
	 e6+/qyBi9xTZ2pDQnc+wGr3jeqrnn6MlG3F4dgBypQeStgTWsUGoAW3cBlWPKkHD2u
	 RRdqxehAzvala4DuWPzdeIopp0hFn0dvuK6LPOjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/770] kcmp: In kcmp_epoll_target use fget_task
Date: Tue, 18 Jun 2024 14:29:23 +0200
Message-ID: <20240618123411.518219866@linuxfoundation.org>
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

[ Upstream commit f43c283a89a7dc531a47d4b1e001503cf3dc3234 ]

Use the helper fget_task and simplify the code.

As well as simplifying the code this removes one unnecessary increment of
struct files_struct.  This unnecessary increment of files_struct.count can
result in exec unnecessarily unsharing files_struct and breaking posix
locks, and it can result in fget_light having to fallback to fget reducing
performance.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-4-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-4-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcmp.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index c0d2ad9b4705d..bd6f9edf98fd3 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -107,7 +107,6 @@ static int kcmp_epoll_target(struct task_struct *task1,
 {
 	struct file *filp, *filp_epoll, *filp_tgt;
 	struct kcmp_epoll_slot slot;
-	struct files_struct *files;
 
 	if (copy_from_user(&slot, uslot, sizeof(slot)))
 		return -EFAULT;
@@ -116,23 +115,12 @@ static int kcmp_epoll_target(struct task_struct *task1,
 	if (!filp)
 		return -EBADF;
 
-	files = get_files_struct(task2);
-	if (!files)
+	filp_epoll = fget_task(task2, slot.efd);
+	if (!filp_epoll)
 		return -EBADF;
 
-	spin_lock(&files->file_lock);
-	filp_epoll = fcheck_files(files, slot.efd);
-	if (filp_epoll)
-		get_file(filp_epoll);
-	else
-		filp_tgt = ERR_PTR(-EBADF);
-	spin_unlock(&files->file_lock);
-	put_files_struct(files);
-
-	if (filp_epoll) {
-		filp_tgt = get_epoll_tfile_raw_ptr(filp_epoll, slot.tfd, slot.toff);
-		fput(filp_epoll);
-	}
+	filp_tgt = get_epoll_tfile_raw_ptr(filp_epoll, slot.tfd, slot.toff);
+	fput(filp_epoll);
 
 	if (IS_ERR(filp_tgt))
 		return PTR_ERR(filp_tgt);
-- 
2.43.0



