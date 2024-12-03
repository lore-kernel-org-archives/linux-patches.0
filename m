Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958301F754A;
	Tue,  3 Dec 2024 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239649; cv=none; b=In7Yc/bIrJ6GLGxEdK0SPLn9us4DQ27zG7duMEMiKWUEZw2qpIiVP7fqyjcZ7YfYGcFdcR4eBzMTc9EJspSw3B1ZYQSOugzdJqcjt0IUdB/9a5XV/dpORclBq45TnnhR8hvlgf1EBOg8f8nJ8h61jcy2lIwX98Pv0GhOq8Sx+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239649; c=relaxed/simple;
	bh=GdJvbfHuTNX2LkbCLAFosbSSI17hnF0yyrGvMAiTEFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stk4vj1CLs3KFFst8b7+qyLLszgXr9K/eOcxbyRPSvBIK0F/mtZ9oecKpvRKfMMsiZH/L4FqcwOYHIG7U8GKOHHUJlBwlCN0AzCRmtvec6zb3vmjmQCXF5NtY5ktioLByym6GD1BG0g702USZxyvQysJfszdO75wJNADfB6on9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chJVQ2uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chJVQ2uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54FBC4CECF;
	Tue,  3 Dec 2024 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239649;
	bh=GdJvbfHuTNX2LkbCLAFosbSSI17hnF0yyrGvMAiTEFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chJVQ2ujjjR1FSC3Yx6rsPuwmH1hLo8va5EWwtFXNezw82DAbqH67p+LT0Lh5hg6y
	 UycxnKFzUcL0q6gHqtHw69S3J/l+mMKuhmKfUnwHKOUF6OFtQOurdlCOdfzu9jEUCF
	 pxPT1h0hihmSjCLFTuFV+QJVMEd77+OlNkZJu/QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 687/817] Revert "exec: dont WARN for racy path_noexec check"
Date: Tue,  3 Dec 2024 15:44:19 +0100
Message-ID: <20241203144022.788690773@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit d62ba2a5536df83473a2ac15ab302258e3845251 which is
commit 0d196e7589cefe207d5d41f37a0a28a1fdeeb7c6 upstream.

A later commit needs to be reverted so revert this one as well to allow
that to happen properly.

Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -145,11 +145,13 @@ SYSCALL_DEFINE1(uselib, const char __use
 		goto out;
 
 	/*
-	 * Check do_open_execat() for an explanation.
+	 * may_open() has already checked for this, so it should be
+	 * impossible to trip now. But we need to be extra cautious
+	 * and check again at the very end too.
 	 */
 	error = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
-	    path_noexec(&file->f_path))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
+			 path_noexec(&file->f_path)))
 		goto exit;
 
 	error = -ENOEXEC;
@@ -953,6 +955,7 @@ EXPORT_SYMBOL(transfer_args_to_stack);
 static struct file *do_open_execat(int fd, struct filename *name, int flags)
 {
 	struct file *file;
+	int err;
 	struct open_flags open_exec_flags = {
 		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_EXEC,
@@ -969,20 +972,24 @@ static struct file *do_open_execat(int f
 
 	file = do_filp_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
-		return file;
+		goto out;
 
 	/*
-	 * In the past the regular type check was here. It moved to may_open() in
-	 * 633fb6ac3980 ("exec: move S_ISREG() check earlier"). Since then it is
-	 * an invariant that all non-regular files error out before we get here.
-	 */
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
-	    path_noexec(&file->f_path)) {
-		fput(file);
-		return ERR_PTR(-EACCES);
-	}
+	 * may_open() has already checked for this, so it should be
+	 * impossible to trip now. But we need to be extra cautious
+	 * and check again at the very end too.
+	 */
+	err = -EACCES;
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
+			 path_noexec(&file->f_path)))
+		goto exit;
 
+out:
 	return file;
+
+exit:
+	fput(file);
+	return ERR_PTR(err);
 }
 
 /**


