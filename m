Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E95C415F22;
	Fri,  4 Sep 2026 05:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500257; cv=none; b=iccpiHQrZgeQgjiX94lErYPUyZZeSUp8R+ykdPuYSEQEjPHgwadmlHTcy0syzUx0AZ2H40wyvRz+QtMGDK6eJEYZile9C5PoKcp70D4JfigXogDPO1n33MZOzuwKabwvJa7TMC0pdJwUjoGBbZ9AjlD4F0rA5ZhUJuMpJf/2sjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500257; c=relaxed/simple;
	bh=pfTdR09tvtP/UGxMYPJuT2N51qsukMfwe5OCmKFK0vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4dA8pC95xNsf2MX5y1FZb7wEXLL6Y7Ti3wJPwkGnQvOacyXGjvhumO0A+td7uG4LHWOKsVdvUyHUg0SRBax8JD5K1VSQeYBi4t15+BjEb+oz/r57xyucAZchY78Z5ZHIIfIsDsUhXgd1R0KAy63y3g7r1ZKv54frJ0+eYJp0tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGXvhggx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGXvhggx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A261F00A3D;
	Fri,  4 Sep 2026 05:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500256;
	bh=Z3/TWq+ZFuDckDys9RNQBQQc3avaFcDCbzYErjfQoEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGXvhggxReM8eohpLw9b+eQnQoGxdWtmoBUD/DEaOKDkEwH2ONXfwZeb8BZPhxMii
	 7app3TUprXkIYyCjDerehxkT7pNVKgC6YDZ1dlcWWM0Y5dz/PdXxg8xjD4rQ/5LCI4
	 KCi495ujfTvvdPaKB5UhaUfusDLsWT4Ouy1QDNYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 7.2 706/713] smack: fix cred UAF in smack_file_send_sigiotask()
Date: Fri,  4 Sep 2026 07:01:14 +0200
Message-ID: <20260904045819.673203348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit fedc88e38ce979a720cd2de042578cb5df3dc8de upstream.

When inspecting the credentials of another task, objective credentials
(->real_cred, accessed with __task_cred()) must always be used.

Accessing ->cred on a non-current task is forbidden unless that task is
being created or destroyed; a task is allowed to change its own ->cred
pointer with no synchronization, and changing ->cred should only affect the
current syscall.

smack_file_send_sigiotask() was accessing both sets of credentials: First
tsk->cred, then __task_cred(tsk).

Fix it, always access the objective credentials here.

I have tested that this bug can lead to a KASAN-reported UAF of struct cred
in smack_file_send_sigiotask(), and that this fix prevents the race.

Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/smack/smack_lsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1964,7 +1964,7 @@ static int smack_file_send_sigiotask(str
 {
 	struct smack_known **blob;
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
+	struct smack_known *tkp = smk_of_task_struct_obj(tsk);
 	const struct cred *tcred;
 	struct file *file;
 	int rc;


