Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BB13EDE55;
	Tue, 12 May 2026 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609100; cv=none; b=ck8uFZekpWTpK4KtEpgJGAImoMXSf4Jk1EShkq41K1vLmpqHrcuUXXvZ3MpS+ARaRmuMUiqohJ0J02fgcmXZyRe7tUDxMkV1ZzGTbhjWpJXQ//Q/spp26WdxUWh21hAq76svmcSn5LcfVj7bgEi65G7ww8CiPjIHTFXweEDjj7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609100; c=relaxed/simple;
	bh=yaLsBvdsUbT7jkkc0tQ5BQrwDxvGNKuCNb9ucQ9sS1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHcgLkFjldoWHGQ6PKYHA2kPbPPZx9tvH4f1xraIkCpqFdYYA807yIADJe6GkIzecgv/0wCj7pMARY7hN1dU73RgxSKA/sDys9nLzp5+JLlqJKCknh4/Xikz7Q0ht7YKByXRka+PX+ohJ/QJecyMVpyBe7toBPI58mpnGtjAfEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqKutxCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqKutxCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF80CC2BCB0;
	Tue, 12 May 2026 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609100;
	bh=yaLsBvdsUbT7jkkc0tQ5BQrwDxvGNKuCNb9ucQ9sS1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqKutxCs2VDuwlPmU5k1RxAgKIZr7LaMw3uTUfZHdwiKCI8//zhRQXFyWLMcvXsFc
	 P9dmdSAmdwdpcp8i7giQ7VV5pDaGE4jjZEb2SfCfuDUtmdoYM69bKn2WknVOWfXDau
	 p0ETQWvJFsZ4dSlYftfEU7w9JgCsm2zWvtqKQgnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 063/307] selinux: prune /sys/fs/selinux/disable
Date: Tue, 12 May 2026 19:37:38 +0200
Message-ID: <20260512173941.451224410@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


