Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B115B10D;
	Mon, 28 Oct 2024 06:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097710; cv=none; b=ERGNF1DRRPSakZZ825BRYWbr7gxsf9QkgVkOhspjVD/WjNuuHSMt2IcQnGx47MNnX5wiv5+hNkkha157qgT09idxvfKj5L82ajpMePIimSQXY2KZBXERA9U2KeS4k92/O6mwByrYcJzHSxZFlblOOQhgRrtjH2n+jauWl2g8JIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097710; c=relaxed/simple;
	bh=h30Fq4HAsQtM6kuxkkWZm/I1OZPkqeNDa9hVa8KhjaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7+imkmW7BldGHW1M2o/BQ3ufoB8b890sv3MzTKe3B74ndK5968ygQv+PvBfIXAbAeMuthQQxo+UJes27vg5Tp9X7S6IIEImpx5/A2gPG+HElTigW8rmNEbPPTap+HeuJ/EkYUaEosagROSf53vvhV75mIaLt1wDnavWK25yMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNs2e0OW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNs2e0OW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B520C4CEC3;
	Mon, 28 Oct 2024 06:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097709;
	bh=h30Fq4HAsQtM6kuxkkWZm/I1OZPkqeNDa9hVa8KhjaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNs2e0OWNrrUPBnRXWrVZBsDE0a1tTPO1ZunfNqgFoM/X6724ObZvqqgFkyX3dF0+
	 lKeSTOQgHBhuLrle+KImAB/g6Icyp/EGPHW5LGFfHV8k9LBrs6GB/DsVj1R+pNfhLj
	 qWvAS9l8/N5MTJv0USle4aGllJ9pzAzsig9Cywpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/208] exec: dont WARN for racy path_noexec check
Date: Mon, 28 Oct 2024 07:24:54 +0100
Message-ID: <20241028062309.465868707@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit 0d196e7589cefe207d5d41f37a0a28a1fdeeb7c6 ]

Both i_mode and noexec checks wrapped in WARN_ON stem from an artifact
of the previous implementation. They used to legitimately check for the
condition, but that got moved up in two commits:
633fb6ac3980 ("exec: move S_ISREG() check earlier")
0fd338b2d2cd ("exec: move path_noexec() check earlier")

Instead of being removed said checks are WARN_ON'ed instead, which
has some debug value.

However, the spurious path_noexec check is racy, resulting in
unwarranted warnings should someone race with setting the noexec flag.

One can note there is more to perm-checking whether execve is allowed
and none of the conditions are guaranteed to still hold after they were
tested for.

Additionally this does not validate whether the code path did any perm
checking to begin with -- it will pass if the inode happens to be
regular.

Keep the redundant path_noexec() check even though it's mindless
nonsense checking for guarantee that isn't given so drop the WARN.

Reword the commentary and do small tidy ups while here.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/r/20240805131721.765484-1-mjguzik@gmail.com
[brauner: keep redundant path_noexec() check]
Signed-off-by: Christian Brauner <brauner@kernel.org>
[cascardo: keep exit label and use it]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index f49b352a60323..7776209d98c10 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -143,13 +143,11 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 		goto out;
 
 	/*
-	 * may_open() has already checked for this, so it should be
-	 * impossible to trip now. But we need to be extra cautious
-	 * and check again at the very end too.
+	 * Check do_open_execat() for an explanation.
 	 */
 	error = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
-			 path_noexec(&file->f_path)))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
+	    path_noexec(&file->f_path))
 		goto exit;
 
 	error = -ENOEXEC;
@@ -925,23 +923,22 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 
 	file = do_filp_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
-		goto out;
+		return file;
 
 	/*
-	 * may_open() has already checked for this, so it should be
-	 * impossible to trip now. But we need to be extra cautious
-	 * and check again at the very end too.
+	 * In the past the regular type check was here. It moved to may_open() in
+	 * 633fb6ac3980 ("exec: move S_ISREG() check earlier"). Since then it is
+	 * an invariant that all non-regular files error out before we get here.
 	 */
 	err = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
-			 path_noexec(&file->f_path)))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
+	    path_noexec(&file->f_path))
 		goto exit;
 
 	err = deny_write_access(file);
 	if (err)
 		goto exit;
 
-out:
 	return file;
 
 exit:
-- 
2.43.0



