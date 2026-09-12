Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6B53246ED;
	Sat, 12 Sep 2026 13:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221269; cv=none; b=AD6232WC77/UgHALsHNsiag3Lqta2Dqdu6MoXw8HHlMrw2Vf64ietKZ2Cw7uUF8tl74iITmGI5EB14MCRBlN4g0gldrkBfLPEAAwZzOPlqfny+N6kOKVglWOKlleV40yB3ziybDzyaYYivsGfr6GhVEK0mf0ws0wuSAHhLeusKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221269; c=relaxed/simple;
	bh=s7Tjf3fuo/jph+Xl3qFCLqvNB6ysqSqQwVfXTPt3XhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+8/KJth+fyz0QfPswVKR1AX3qYhIFW+EkHd171P6IZv21/6LsBWvHsNbzhHR0SoI1/S3JWxlLNR5zA7Gkmhr41uKCs7mn98vecbLJBEgUkfIjTzt7J8LcGoiP4kNXO72iJgLy+8qRUbvYnVibLJti7vo03S2PiGqSKKnDL4CTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZvFzrTf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZvFzrTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141DD1F000FF;
	Sat, 12 Sep 2026 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221264;
	bh=VsRYkFaCVUJ2mhv28+wxiMo2EVPhfQ8c/awv2+x7hKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZvFzrTfopC5uaa/G0vAKXROKudAV1r2EwXTqCpYcpmHeZEz5SCybudsBu+2LAhvP
	 MGLH9lFG0gC+grc/kFu+puv9K6unply8Zl773ReMOEzaQe3L4yOI3kKZKDHjFY0218
	 MNrurZzsCa+obNMz8bgOQKAQ1/yC2D0bt+Orf6m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 6.6 0304/1424] smack: fix cred UAF in smack_file_send_sigiotask()
Date: Sat, 12 Sep 2026 08:45:36 +0200
Message-ID: <20260912065614.093186728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -1907,7 +1907,7 @@ static int smack_file_send_sigiotask(str
 {
 	struct smack_known **blob;
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
+	struct smack_known *tkp = smk_of_task_struct_obj(tsk);
 	const struct cred *tcred;
 	struct file *file;
 	int rc;


