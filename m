Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755821EE033;
	Wed,  6 Nov 2024 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896724; cv=none; b=IbF98rpqe6Y17iepcI32Yss5FDJLQYCoq14kwIKYJmPAkZJi+OuDQgWQdrfd3wi0RKxv7WJ45FklhGqoSH4wf5fzbCHXlh6lHGlkcgJweoRUXMR0f6qQ1h89YLOLRTtHjzW5G40LeOvCC03lTu8d57TVNmmgn1mODonemnl1Ssk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896724; c=relaxed/simple;
	bh=oDq5gwZTQFD5zRCA0zHrZd/TWb6fTmAZ2yQf7K2p1YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTjahW/mAqffEEJFNg9nmoTn1bOX2JNlw1KsDEq+rQ1O9kQsX2vvM9NlrTseAIFQufhiORu98PGP2uKqreHbCoFGxJs/adcZtUXJrgN4wJ/vgV2mvwNAJ0K94A+7VS5i9fa0V/JRTDt9f78uLFgj3CWMSjYHZNSEsVWvZQwJH4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15Y3xjAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15Y3xjAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE1CC4CED3;
	Wed,  6 Nov 2024 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896724;
	bh=oDq5gwZTQFD5zRCA0zHrZd/TWb6fTmAZ2yQf7K2p1YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15Y3xjAdmL6zF60jCmU/qDyJIKMpFb1LGnckhY/rpd2hKsdICleA1Dy1tJBiMuGH7
	 XJ6SG6i2a+0fu2qJglFKMn6dmaMODEZzTOdA0sYmv4x+1r5BXdZYgg3EfjngZzEKyK
	 Vp7pXkzEhNNtz7uhcDg7zT8wXPM/k6/IqBwjRsHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/110] selinux: improve error checking in sel_write_load()
Date: Wed,  6 Nov 2024 13:04:17 +0100
Message-ID: <20241106120304.612299124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/selinuxfs.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index d893c2280f595..7415f49a3d81e 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -620,6 +620,13 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 	ssize_t length;
 	void *data = NULL;
 
+	/* no partial writes */
+	if (*ppos)
+		return -EINVAL;
+	/* no empty policies */
+	if (!count)
+		return -EINVAL;
+
 	mutex_lock(&fsi->state->policy_mutex);
 
 	length = avc_has_perm(&selinux_state,
@@ -628,26 +635,21 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 	if (length)
 		goto out;
 
-	/* No partial writes. */
-	length = -EINVAL;
-	if (*ppos != 0)
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
 
 	length = security_load_policy(fsi->state, data, count, &load_state);
 	if (length) {
 		pr_warn_ratelimited("SELinux: failed to load policy\n");
 		goto out;
 	}
-
 	length = sel_make_policy_nodes(fsi, load_state.policy);
 	if (length) {
 		selinux_policy_cancel(fsi->state, &load_state);
@@ -655,13 +657,12 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 	}
 
 	selinux_policy_commit(fsi->state, &load_state);
-
 	length = count;
-
 	audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
 		"auid=%u ses=%u lsm=selinux res=1",
 		from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		audit_get_sessionid(current));
+
 out:
 	mutex_unlock(&fsi->state->policy_mutex);
 	vfree(data);
-- 
2.43.0



