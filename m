Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6EE3955D4;
	Tue, 12 May 2026 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608404; cv=none; b=A96EEETngdVgEdvNdhOt5AOAn9GhODGaH9fYM3YkEdrZwd0h/c+Ba5Vp5DNzpDGEYXIG83P3zXwEvGd5+wZ8uJ1Hj/Ndl3UgWyd7cJTlFNxQZnQirHAgrjDQSso2/LGTcfTchn26QI5GHpqYQC909gWPrU/fwRNXmTNCJMAUKwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608404; c=relaxed/simple;
	bh=VNDmcN4mOkejcgcvSyVx2tBG82psm+Vc78yTOFi/LWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTkYW1yXaEMT3fpys9UPGPq8WdW4vYWoPb61ooYcvcbJjSfn3CtQVx16DIjYHCpBTOCjhBR5j5CzXW0OaaOZatO/Nizw5JfNcOHx8UYOrk5BR7e9infSdY1R8JLL9Az9/vF5Ov6MQ3xl58/nSLopz1aJwBOdJM6oVlMatBkfD+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SE8SKtMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SE8SKtMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2140DC2BCB0;
	Tue, 12 May 2026 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608404;
	bh=VNDmcN4mOkejcgcvSyVx2tBG82psm+Vc78yTOFi/LWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SE8SKtMcYY5hV9ki+95/LuVI1jGRRSiv0CmaKI6jbFcq7tz/5zHXeJD5Oi2uh2c3u
	 tAFRL9aPK+JGKVrxjivGHaglQtFBKTYRWMB1TWWix9UqCrEOp64zWq6Q3lrtOMPHQA
	 1lLWmYVV4YSvnReUxgkjMNfqGXK25yxxDcNx7mSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 065/270] selinux: prune /sys/fs/selinux/disable
Date: Tue, 12 May 2026 19:37:46 +0200
Message-ID: <20260512173939.819866450@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 19cfa0099024bb9cd40f6d950caa7f47ff8e77f6 upstream.

Commit f22f9aaf6c3d ("selinux: remove the runtime disable
functionality") removed the underlying SELinux runtime disable
functionality but left everything else intact and started logging an
error message to warn any residual users.

Prune it to just log an error message once and to return count
(i.e. all bytes written successfully) to avoid breaking
userspace. This also fixes a local DoS from logspam.

Cc: stable@vger.kernel.org
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/selinuxfs.c |   36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -272,35 +272,13 @@ static ssize_t sel_write_disable(struct
 				 size_t count, loff_t *ppos)
 
 {
-	char *page;
-	ssize_t length;
-	int new_value;
-
-	if (count >= PAGE_SIZE)
-		return -ENOMEM;
-
-	/* No partial writes. */
-	if (*ppos != 0)
-		return -EINVAL;
-
-	page = memdup_user_nul(buf, count);
-	if (IS_ERR(page))
-		return PTR_ERR(page);
-
-	if (sscanf(page, "%d", &new_value) != 1) {
-		length = -EINVAL;
-		goto out;
-	}
-	length = count;
-
-	if (new_value) {
-		pr_err("SELinux: https://github.com/SELinuxProject/selinux-kernel/wiki/DEPRECATE-runtime-disable\n");
-		pr_err("SELinux: Runtime disable is not supported, use selinux=0 on the kernel cmdline.\n");
-	}
-
-out:
-	kfree(page);
-	return length;
+	/*
+	 * Setting disable is no longer supported, see
+	 * https://github.com/SELinuxProject/selinux-kernel/wiki/DEPRECATE-runtime-disable
+	 */
+	pr_err_once("SELinux: %s (%d) wrote to disable. This is no longer supported.\n",
+		    current->comm, current->pid);
+	return count;
 }
 
 static const struct file_operations sel_disable_ops = {


