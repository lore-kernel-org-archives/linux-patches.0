Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A9F1DF74E;
	Wed,  6 Nov 2024 12:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895745; cv=none; b=ZtvYkJ9I2kXuFU9zFao+dhsrIVM/KUGK2UeHDxu+nS6gH3BXqASzIpKR2c8j8DH5dzOq/BqCHfoT54e0q8qpBtAo/IqZsF8SuhQWTSLHDpkb0um+LrHal7yD5P3uCyzcEbaNiKxAXNV0uLU+Xhtd+2sZ1cQqz0FHmCxPU9C5wy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895745; c=relaxed/simple;
	bh=ZtheL90N9LA0rVdn1DXOkNyyKC/lIk/8bCzCLlYgx2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuMJigRtJjyRl+D8ByPNrXG0SVzj0AWhZDfKIhIGO46o5GG77TUXaZj1AygwI7EH2270eIZuH3MbUL8A5r6XWU6j5X7cneT8SfSsaCG+FyAf62zL54qOYrk3k8ys7+UfQIS34OM5iew96T6ShZsLef3WDMfZBSTchyLTAFySfGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvkgt363; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvkgt363"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1DFC4CECD;
	Wed,  6 Nov 2024 12:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895744;
	bh=ZtheL90N9LA0rVdn1DXOkNyyKC/lIk/8bCzCLlYgx2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvkgt363UStusOIErHB2xSFeiZicd4E2PHrP4tMEZ9JiewxjN1S7iq77JVAz+lEA8
	 TdBql4qqEimsm13R2IVT/FH3f1oj1MMJM7WkNIlpfQducGAGSBhKr2Ch4TCtLTSPgD
	 yYuYMPtxFvlwVxzsld/ICeqg6LN8EQ4IVZMYx1rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 320/350] selinux: improve error checking in sel_write_load()
Date: Wed,  6 Nov 2024 13:04:08 +0100
Message-ID: <20241106120328.654649995@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit 42c773238037c90b3302bf37a57ae3b5c3f6004a ]

Move our existing input sanity checking to the top of sel_write_load()
and add a check to ensure the buffer size is non-zero.

Move a local variable initialization from the declaration to before it
is used.

Minor style adjustments.

Reported-by: Sam Sun <samsun1006219@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
[cascardo: keep fsi initialization at its declaration point as it is used earlier]
[cascardo: keep check for 64MiB size limit]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/selinuxfs.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 60b3f16bb5c7b..c35aab9f24471 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -536,6 +536,16 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 	ssize_t length;
 	void *data = NULL;
 
+	/* no partial writes */
+	if (*ppos)
+		return -EINVAL;
+	/* no empty policies */
+	if (!count)
+		return -EINVAL;
+
+	if (count > 64 * 1024 * 1024)
+		return -EFBIG;
+
 	mutex_lock(&fsi->mutex);
 
 	length = avc_has_perm(&selinux_state,
@@ -544,23 +554,15 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 	if (length)
 		goto out;
 
-	/* No partial writes. */
-	length = -EINVAL;
-	if (*ppos != 0)
-		goto out;
-
-	length = -EFBIG;
-	if (count > 64 * 1024 * 1024)
-		goto out;
-
-	length = -ENOMEM;
 	data = vmalloc(count);
-	if (!data)
+	if (!data) {
+		length = -ENOMEM;
 		goto out;
-
-	length = -EFAULT;
-	if (copy_from_user(data, buf, count) != 0)
+	}
+	if (copy_from_user(data, buf, count) != 0) {
+		length = -EFAULT;
 		goto out;
+	}
 
 	length = security_load_policy(fsi->state, data, count);
 	if (length) {
@@ -579,6 +581,7 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 		"auid=%u ses=%u lsm=selinux res=1",
 		from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		audit_get_sessionid(current));
+
 out:
 	mutex_unlock(&fsi->mutex);
 	vfree(data);
-- 
2.43.0



