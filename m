Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764903EDE55;
	Tue, 12 May 2026 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609092; cv=none; b=AZ2hsQg+O/TLyjEAotZnTIVICj8GEtFzAe6YMHBhP1oObfiayc0GQDdI1AhIb9eVx3idsK2NDf73qNrlhlMwXKYDmRUfEzX9fOTYKV3CeAgv8JQ/G44A3euEle1kHkW1DESzCw3bygd/TRgBmy+hNor9VrvykgYWufeOXJ8u2q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609092; c=relaxed/simple;
	bh=PDMjbAdfgWK3vmzlS5egVHUZiaubCqMlUk7kdt+/nDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVYodrZNASOxCtRq7DVUUzWEHqhMvliWRI2ztSjuOiy5w3LfWrJGs/nx60EnvjjrH2uyUTPtB8NcjjwpA2hxAgxz17cDBe0zVgegn30G1p3YIDGerJp9TjfL1CZ0j28Wc9P4DKt7DiG7eSVAEyGpt3V1DP6bpGl5K7gDt1mNrfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bajxXwo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bajxXwo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D248C2BCB0;
	Tue, 12 May 2026 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609092;
	bh=PDMjbAdfgWK3vmzlS5egVHUZiaubCqMlUk7kdt+/nDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bajxXwo1PNGHYF/Vj8cr2CWCSQ2gvgsX1TjYkNAPLek20iTT/Qhtgdhsavu3ZMf60
	 sTregSzEyCrOdS69AUckUiKZvVdntVPGkLTK/G8z5xP4fO5MMBDhd7vsYbdTtH6JiL
	 2ywRo7ivE9vBYBhI3jVFurTuGiba4gKsw2aSQrNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 061/307] selinux: shrink critical section in sel_write_load()
Date: Tue, 12 May 2026 19:37:36 +0200
Message-ID: <20260512173941.410254447@linuxfoundation.org>
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


