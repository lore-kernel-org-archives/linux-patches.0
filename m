Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5716435E550;
	Tue, 16 Dec 2025 12:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886824; cv=none; b=Vqu7AZzyNrfpfs3b4VX+AioROPJHISHpEruiPA/NznuJdqABfV0EB0wtZTzXT5vj8JhEZu3fFCD6NWdXY5KotTY9KAtb716VCZTv6+oOPIJk+PfeIOtXuSQ6rT1BIkGGK2+Xzay4RdsXuHb56f+tFuSz0124EQxBRX41KpUUpvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886824; c=relaxed/simple;
	bh=zqHBMXnlaVsa5E8/INlTnxZmpHaICEdMVw+L0N2FEEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EincW2kXqsLu1MDK8SnCKyrVk8jsgTdd2qZMbNa2b6rkEPrBTlmizRRAS/pKAAg7v3lpnWiQGDvgsfyVtsW+GKTyuXkLyuWsUjs5vMlhBN4TMEPmgauuuJelVDB/xx435nfgDx+MslxoUptBR9V3l1ZSUUCGchUlAmKdLu6ffuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yodoQ8YX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yodoQ8YX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728D3C4CEF1;
	Tue, 16 Dec 2025 12:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886823;
	bh=zqHBMXnlaVsa5E8/INlTnxZmpHaICEdMVw+L0N2FEEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yodoQ8YXCMejbeDlaRZZzkShpU4VA4PlrFw5ud7HVAnMRa+7Kvm+u2SNY4T3k7Kcb
	 C9NXRVAUXCvg4F0ABDNizfE0lJFhoi1t2crDjppk2H2oP1qV3zxT0555vPYExgRGwW
	 tM2UUwVcbFXVjzI3/Nispg99XwNlIvWN9hrHUZt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/614] ima: Attach CREDS_CHECK IMA hook to bprm_creds_from_file LSM hook
Date: Tue, 16 Dec 2025 12:06:33 +0100
Message-ID: <20251216111402.256055747@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 8f3fc4f3f8aa6e99266c69cc78bdaa58379e65fc ]

Since commit 56305aa9b6fa ("exec: Compute file based creds only once"), the
credentials to be applied to the process after execution are not calculated
anymore for each step of finding intermediate interpreters (including the
final binary), but only after the final binary to be executed without
interpreter has been found.

In particular, that means that the bprm_check_security LSM hook will not
see the updated cred->e[ug]id for the intermediate and for the final binary
to be executed, since the function doing this task has been moved from
prepare_binprm(), which calls the bprm_check_security hook, to
bprm_creds_from_file().

This breaks the IMA expectation for the CREDS_CHECK hook, introduced with
commit d906c10d8a31 ("IMA: Support using new creds in appraisal policy"),
which expects to evaluate "the credentials that will be committed when the
new process is started". This is clearly not the case for the CREDS_CHECK
IMA hook, which is attached to bprm_check_security.

This issue does not affect systems which load a policy with the BPRM_CHECK
hook with no other criteria, as is the case with the built-in "tcb" and/or
"appraise_tcb" IMA policies. The "tcb" built-in policy measures all
executions regardless of the new credentials, and the "appraise_tcb" policy
is written in terms of the file owner, rather than IMA hooks.

However, it does affect systems without a BPRM_CHECK policy rule or with a
BPRM_CHECK policy rule that does not include what CREDS_CHECK evaluates. As
an extreme example, taking a standalone rule like:

measure func=CREDS_CHECK euid=0

This will not measure for example sudo (because CREDS_CHECK still sees the
bprm->cred->euid set to the regular user UID), but only the subsequent
commands after the euid was applied to the children.

Make set[ug]id programs measured/appraised again by splitting
ima_bprm_check() in two separate hook implementations (CREDS_CHECK now
being implemented by ima_creds_check()), and by attaching CREDS_CHECK to
the bprm_creds_from_file LSM hook.

The limitation of this approach is that CREDS_CHECK will not be invoked
anymore for the intermediate interpreters, like it was before, but only for
the final binary. This limitation can be removed only by reverting commit
56305aa9b6fa ("exec: Compute file based creds only once").

Link: https://github.com/linux-integrity/linux/issues/3
Fixes: 56305aa9b6fa ("exec: Compute file based creds only once")
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_main.c | 42 ++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index cdd225f65a629..ebaebccfbe9ab 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -573,18 +573,41 @@ static int ima_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
  */
 static int ima_bprm_check(struct linux_binprm *bprm)
 {
-	int ret;
 	struct lsm_prop prop;
 
 	security_current_getlsmprop_subj(&prop);
-	ret = process_measurement(bprm->file, current_cred(),
-				  &prop, NULL, 0, MAY_EXEC, BPRM_CHECK);
-	if (ret)
-		return ret;
-
-	security_cred_getlsmprop(bprm->cred, &prop);
-	return process_measurement(bprm->file, bprm->cred, &prop, NULL, 0,
-				   MAY_EXEC, CREDS_CHECK);
+	return process_measurement(bprm->file, current_cred(),
+				   &prop, NULL, 0, MAY_EXEC, BPRM_CHECK);
+}
+
+/**
+ * ima_creds_check - based on policy, collect/store measurement.
+ * @bprm: contains the linux_binprm structure
+ * @file: contains the file descriptor of the binary being executed
+ *
+ * The OS protects against an executable file, already open for write,
+ * from being executed in deny_write_access() and an executable file,
+ * already open for execute, from being modified in get_write_access().
+ * So we can be certain that what we verify and measure here is actually
+ * what is being executed.
+ *
+ * The difference from ima_bprm_check() is that ima_creds_check() is invoked
+ * only after determining the final binary to be executed without interpreter,
+ * and not when searching for intermediate binaries. The reason is that since
+ * commit 56305aa9b6fab ("exec: Compute file based creds only once"), the
+ * credentials to be applied to the process are calculated only at that stage
+ * (bprm_creds_from_file security hook instead of bprm_check_security).
+ *
+ * On success return 0.  On integrity appraisal error, assuming the file
+ * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
+ */
+static int ima_creds_check(struct linux_binprm *bprm, const struct file *file)
+{
+	struct lsm_prop prop;
+
+	security_current_getlsmprop_subj(&prop);
+	return process_measurement((struct file *)file, bprm->cred, &prop, NULL,
+				   0, MAY_EXEC, CREDS_CHECK);
 }
 
 /**
@@ -1242,6 +1265,7 @@ static int __init init_ima(void)
 static struct security_hook_list ima_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bprm_check_security, ima_bprm_check),
 	LSM_HOOK_INIT(bprm_creds_for_exec, ima_bprm_creds_for_exec),
+	LSM_HOOK_INIT(bprm_creds_from_file, ima_creds_check),
 	LSM_HOOK_INIT(file_post_open, ima_file_check),
 	LSM_HOOK_INIT(inode_post_create_tmpfile, ima_post_create_tmpfile),
 	LSM_HOOK_INIT(file_release, ima_file_free),
-- 
2.51.0



