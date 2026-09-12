Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC76C3624CC;
	Sat, 12 Sep 2026 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237220; cv=none; b=VS4mTHvVJq5tsflpw4YGxnaYrrf53qe9DghCnVmXsVosqR4yMS2dy4Vh7WyMSnH0O+BxFQeM+wRxF3KiEHJlUe0VBv3CXcCwAj24lVLFKa0INk6Yrrh1KHyCNYNTSpdH4HWS3rYC84qVz2mYqWwQZiZ7mGEUEr1n7ZhZSjtS48g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237220; c=relaxed/simple;
	bh=pWVCO501dcz1cKd5Flp1WzOC5LqDBdBtUV6KX9ZVTbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMN3ec0WavAkI8ZU4oItcFg6xVoZZY4FB2PxyuMMv42n7pKtG3o4ePnjQ4IIX8CgPwlRuhe8sp1Xp7pdtNUV5tLbRUF1xCvQe2CQhuLf0YlyXvP0Xr/RmRWycoowXHUdNr04wWZ72jfcrBKqZ3X06gJYFvbN2teQ6KuQvr/Shv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJF1PC7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJF1PC7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C371F000FF;
	Sat, 12 Sep 2026 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237218;
	bh=q336ZmDNOBjEjIAbWYGjabaUeE8ueVNvKsRTg1Y1Ptw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJF1PC7UXTlJsIp5vofZJhlfmjevBsOkNtNRF2lmXxxP/eJOKMiGd7OPyvDOmEoZp
	 0fDQ3LJWlXKpMm3KDrDY3aDsIne4zECWujwrGV6lGR0ewBR8y8zaFz3g8Kt71YtqYb
	 BS4UmaX9OG86hCYvrs1pIZxTp4jXd3qaSgTBeshg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 5.15 212/935] smack: fix cred UAF in smack_file_send_sigiotask()
Date: Sat, 12 Sep 2026 08:54:02 +0200
Message-ID: <20260912065531.689396835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1788,7 +1788,7 @@ static int smack_file_send_sigiotask(str
 {
 	struct smack_known **blob;
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
+	struct smack_known *tkp = smk_of_task_struct_obj(tsk);
 	const struct cred *tcred;
 	struct file *file;
 	int rc;


