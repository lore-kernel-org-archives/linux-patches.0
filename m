Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5C53E0721;
	Tue, 12 May 2026 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607864; cv=none; b=c0BQeoxtT+QdMTUiT/xYveoyIgl/Lmav6iDDIeUfZzh9Ccx6WKEMU9wsgaPAQh2IqF09QZeADyCXpkoGsv9HdSa9OQnp1EZsrodJkgomwWfFICTT8PBsZpA8qSstKSJ4Jmap40ydszmtdH7be0o5A3TtiOBbnr+B53LKVKlAXiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607864; c=relaxed/simple;
	bh=pNWdPQW1/OPjYTf6zPOA4Z7pZegY3122I0nmqKCuRFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMnVC9JqFbOOFmcB4yWO6e7fXbxvrlhzjNhxcNNGZdoUu37s27gr/opH7dJjTMljfYNt02J++mObOs3fmojusI2fNxd7Hu9M1Mj6F+50ZnXQ9kCdk0RTIT6cHNvT7iws3Bh4r8UR2jJP+gHoAwHDIIO70YIdn/lTzlXINMCtn/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIlgdwFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIlgdwFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EA5C2BCF5;
	Tue, 12 May 2026 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607864;
	bh=pNWdPQW1/OPjYTf6zPOA4Z7pZegY3122I0nmqKCuRFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIlgdwFh4bEj1oN8jw/HLRig6+sZMnjCQTjLqcncfO18Df4Bq1uZtB/WHwqaBJ/Bv
	 i/Oulc9OjQv0encdLRmq3ddkwNl1OfTQQ+szrHKkilph3vhw7jJ50aE5ckui2+1K0i
	 xnS9JCmmYME30afhJUcIKp/5Ireqj3KU4vToqcgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 058/206] selinux: shrink critical section in sel_write_load()
Date: Tue, 12 May 2026 19:38:30 +0200
Message-ID: <20260512173934.069280148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -583,34 +583,31 @@ static ssize_t sel_write_load(struct fil
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
@@ -620,8 +617,9 @@ static ssize_t sel_write_load(struct fil
 		from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		audit_get_sessionid(current));
 
-out:
+out_unlock:
 	mutex_unlock(&selinux_state.policy_mutex);
+out:
 	vfree(data);
 	return length;
 }


