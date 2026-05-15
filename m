Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AD735AC09;
	Fri, 15 May 2026 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861229; cv=none; b=TNmTpMsZP4AZO/QZ40HZ7sF1dwZCY+im0ZwatfKs54YPum+t8DgB7XQM1cxipK81bSYy47HuSZckCDeoq4xds9eSbCdqCePED6z9jQbT+pM/HkkcJUaIHIH3BxMYvtvynh8qe+Cwl4pnsw6cJntvWDrzMFvuh8wl/SHYNC6aOUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861229; c=relaxed/simple;
	bh=8RIQewIbG2OfN9Yng/wmkY8+3ZpJvxhGoIMYEW0D69w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=op+UtniDiaPSaKLWLXr/Xh2f0MGI/97zxD4ay848x00JBnUFqZv8XKHoujCWx/yI/JTcmM6SyUJ0fAjcFnGkaxX5Y0I88inhLm5HIpRyy0fIQJdeEHYevizmENxnySsoqj+9lWYrKXNNij9FOv1y3yQ4McsOuSk/xWzx1o3Kzng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4IPW1tT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4IPW1tT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE7AC2BCB0;
	Fri, 15 May 2026 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861229;
	bh=8RIQewIbG2OfN9Yng/wmkY8+3ZpJvxhGoIMYEW0D69w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4IPW1tTmKRtC4JU9lnB4AS6AJGTeGectV6GEcxhTiS3MiHyiK0mVtf6Dr9s7aeY5
	 TPtxIgpcHeZCy06DV6s58BpG4uXTFufEUlaZBS9guCC3fLysB0t2u+zvZpLUjvUzTz
	 jTHsL0lIGRdt/7hzOQR+JeYM89cMge855i1cRpaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 206/474] selinux: shrink critical section in sel_write_load()
Date: Fri, 15 May 2026 17:45:15 +0200
Message-ID: <20260515154719.470054822@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 868f31e4061eca8c3cd607d79d954d5e54f204aa upstream.

Currently sel_write_load() takes the policy mutex earlier than
necessary. Move the taking of the mutex later. This avoids
holding it unnecessarily across the vmalloc() and copy_from_user()
of the policy data.

Cc: stable@vger.kernel.org
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/selinuxfs.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -594,34 +594,31 @@ static ssize_t sel_write_load(struct fil
 	if (!count)
 		return -EINVAL;
 
-	mutex_lock(&selinux_state.policy_mutex);
-
 	length = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			      SECCLASS_SECURITY, SECURITY__LOAD_POLICY, NULL);
 	if (length)
-		goto out;
+		return length;
 
 	data = vmalloc(count);
-	if (!data) {
-		length = -ENOMEM;
-		goto out;
-	}
+	if (!data)
+		return -ENOMEM;
 	if (copy_from_user(data, buf, count) != 0) {
 		length = -EFAULT;
 		goto out;
 	}
 
+	mutex_lock(&selinux_state.policy_mutex);
 	length = security_load_policy(data, count, &load_state);
 	if (length) {
 		pr_warn_ratelimited("SELinux: failed to load policy\n");
-		goto out;
+		goto out_unlock;
 	}
 	fsi = file_inode(file)->i_sb->s_fs_info;
 	length = sel_make_policy_nodes(fsi, load_state.policy);
 	if (length) {
 		pr_warn_ratelimited("SELinux: failed to initialize selinuxfs\n");
 		selinux_policy_cancel(&load_state);
-		goto out;
+		goto out_unlock;
 	}
 
 	selinux_policy_commit(&load_state);
@@ -631,8 +628,9 @@ static ssize_t sel_write_load(struct fil
 		from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		audit_get_sessionid(current));
 
-out:
+out_unlock:
 	mutex_unlock(&selinux_state.policy_mutex);
+out:
 	vfree(data);
 	return length;
 }


