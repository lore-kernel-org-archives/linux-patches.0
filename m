Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC2E317145;
	Sat, 12 Sep 2026 15:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227754; cv=none; b=k8GU0z8vMwcdIhl3V/K4zoEe5tCETRxLTd93S84PQ1JwIipgCyE1oV7eDY9YxFyz7571o4kvL2el8IOM9+I1UJTX2b0Q6e2rVWF0Mjmn0QYRUm+6ovkw8STPvuoUjCe9souQwN0VadqDU0viSR5hfO1mrldfUbOZpqmX2wjH9J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227754; c=relaxed/simple;
	bh=AqoJRAordAXcCwwmaIXoQCYA67EOfKkBq0tlHKuJysQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBzNiChmOfNFYjziuD0B4mq9Wwh+AX+OMIMFJsVwxiRHM6S5zEIOTi6QylH0UXYmUn7ddcxELis3tffXcERJ4hiM+itIpd5XUR5HT4um+nif46JtpzlgkC9PSsUXHVAeYkXQttERBatNMgREmQRJ6PKAZbpK6ScxbsQc2cZM74Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVEsfR5F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVEsfR5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22DC1F000FF;
	Sat, 12 Sep 2026 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227753;
	bh=D+pcoI+/yLvy4+dhQ8eW2+RiVd2nmNvRniLfJrxupJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVEsfR5F8PmaycoDMNTyyOl1AURqaoqXsaMzImjj4rSEzTivkrH5h+GVYVp+n4Ptx
	 m64wOju66bR1V77pRMbcRp+hMXB+S6+JPTy+MKpX0kLw01MihGqkskfsNaT7R+VcYC
	 IqyWjmAwGe/H8qot1V1la+pt4LUiWrNR9q9tUIms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 6.1 0247/1191] smack: fix cred UAF in smack_file_send_sigiotask()
Date: Sat, 12 Sep 2026 08:49:35 +0200
Message-ID: <20260912065553.763675823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1836,7 +1836,7 @@ static int smack_file_send_sigiotask(str
 {
 	struct smack_known **blob;
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
+	struct smack_known *tkp = smk_of_task_struct_obj(tsk);
 	const struct cred *tcred;
 	struct file *file;
 	int rc;


