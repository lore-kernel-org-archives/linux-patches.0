Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D19A42376F;
	Fri,  4 Sep 2026 06:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502988; cv=none; b=lX5IUyaBdTmEaYipDBR3xiwTS2HOMpYaecsnXGP70D5dYakpUKX4ldZlULt1yN7vAOSFKPy7/zlKIPxtsLu2nyEwWxMok6gCvQPaji+Oe7dGZx5ev/M2yCygKjAeoJe92r7QlqzWHj/1sRQmAGmih3hLrExYIVUlAzj+8SQ3L7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502988; c=relaxed/simple;
	bh=DtBbvZMoDdGh/d/uERHglGJhQeA4ADQIVKP7yZP0j/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2mVtbMoMuGJ+GVp/ecHVCXgLM9uSMX/bwdTiWolGSPVapA0AHrtiUCnjSAu4Ig4v6g53v0vvpRBjse2nM5IUReK5uNxLRu326WPKHVrKyCD8+OgNyyzso1XIX/m26S+hS6APNoILZwAVOwmh4QvLr5F7fCFxiNbJ+nXHS5HcTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0acoD0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0acoD0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53F61F00A3F;
	Fri,  4 Sep 2026 06:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502987;
	bh=Jhad7k+FCR2t1O/77fE4nTJ2KWGRHEmvZrDUQ95pgXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0acoD0DfMBFE9BxFoPBtPeHA/QUY6R5ExTpOMo+Xc/hZNvDCs5uDjSTnomYSbUD0
	 66+byzdbFdA5MuIchaaM0AwSNfYq5bQSLET49U209nAzBDRT0xcKhkGrokz3Xm5UFd
	 YowHbH0OZlCnlPHgDs9/ylAZl42d47Z/F+59ZQrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 6.12 399/403] smack: fix cred UAF in smack_file_send_sigiotask()
Date: Fri,  4 Sep 2026 07:03:22 +0200
Message-ID: <20260904045743.852626111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -1988,7 +1988,7 @@ static int smack_file_send_sigiotask(str
 {
 	struct smack_known **blob;
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
+	struct smack_known *tkp = smk_of_task_struct_obj(tsk);
 	const struct cred *tcred;
 	struct file *file;
 	int rc;


