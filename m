Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C874646;
	Wed,  6 Nov 2024 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899123; cv=none; b=OWbvp41IjWA9/XKVr6FaJKsRlcMQmJ0u4OnO3jqaorS+GOOeRk3BgubxGYAK00MLEI4q2HbeNAXscWdrrCPmLlPuimhpQs6Vj2XUUQweCh16vrUE8DL9hgqUWYsFxZQrtUqyQPbTUmmw7soHwYf1w97ZNvP9VyTSSEqH+Prx6gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899123; c=relaxed/simple;
	bh=X6sGs1nydibkYbVtb/cxlJ3QHSqasaAbpXBFS9+Z61Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lizmSf8zn9ByIzitBjqrZDgbSVN7+U91wdSvG8gSbgqe4BgkzHZaWxQaD3qV3OBXul5/psZuXDWt4t0PaNObzmdDc9ZSNPDW37Wa09ML+tv8ZEKeMyjTSaGmFdLsT3yCvV0EvleNxbsvEUIapJS/zULv/9IEtLZAUO5360NnM4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6bxa6uY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6bxa6uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3383C4CECD;
	Wed,  6 Nov 2024 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899123;
	bh=X6sGs1nydibkYbVtb/cxlJ3QHSqasaAbpXBFS9+Z61Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6bxa6uYyRUFU48NHgcfwSdrNfjTtDx+20ROMsiKrLxQi+6P4dW5jXViKZLuXHe2K
	 CKSLQ5l8gtFx9e4W84K3+ZSPtaS1GP4it++W9Uy7QlhjKeMCEQRmm69B5CqNCL9pMJ
	 JBVBNyacZaQa423zYSrIEVsZbANKHR4w4OeIp4Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 423/462] selinux: improve error checking in sel_write_load()
Date: Wed,  6 Nov 2024 13:05:16 +0100
Message-ID: <20241106120341.962622589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e9eaff90cbccd..fd6282fa9c39f 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -535,6 +535,16 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
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
@@ -543,23 +553,15 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
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
@@ -578,6 +580,7 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 		"auid=%u ses=%u lsm=selinux res=1",
 		from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		audit_get_sessionid(current));
+
 out:
 	mutex_unlock(&fsi->mutex);
 	vfree(data);
-- 
2.43.0



