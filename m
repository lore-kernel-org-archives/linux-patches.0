Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51158847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42A1C433A0;
	Fri, 10 Mar 2023 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456223;
	bh=Iqiq++vbitb9GcrMB8hKTHTqm8c52kbGCuOxrQ5jZko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRg3AsPrGpBcDMK44gIU6rUPIeNAMnMQwqh80/EEa0YfS/L8RUEudSLDrPATqx93z
	 cyABaclWMwyUUjvJgeF9aKb80AWF/fyX7MKZIorBgoSP6BdJI+BHgPezwM/+riz2vZ
	 1oFN6jEqPbkA0vrDJowldhLHaNJjduFwrPZ4RN/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.14 122/193] ima: Align ima_file_mmap() parameters with mmap_file LSM hook
Date: Fri, 10 Mar 2023 14:38:24 +0100
Message-Id: <20230310133715.316949036@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 4971c268b85e1c7a734a61622fc0813c86e2362e upstream.

Commit 98de59bfe4b2f ("take calculation of final prot in
security_mmap_file() into a helper") moved the code to update prot, to be
the actual protections applied to the kernel, to a new helper called
mmap_prot().

However, while without the helper ima_file_mmap() was getting the updated
prot, with the helper ima_file_mmap() gets the original prot, which
contains the protections requested by the application.

A possible consequence of this change is that, if an application calls
mmap() with only PROT_READ, and the kernel applies PROT_EXEC in addition,
that application would have access to executable memory without having this
event recorded in the IMA measurement list. This situation would occur for
example if the application, before mmap(), calls the personality() system
call with READ_IMPLIES_EXEC as the first argument.

Align ima_file_mmap() parameters with those of the mmap_file LSM hook, so
that IMA can receive both the requested prot and the final prot. Since the
requested protections are stored in a new variable, and the final
protections are stored in the existing variable, this effectively restores
the original behavior of the MMAP_CHECK hook.

Cc: stable@vger.kernel.org
Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ima.h               |    6 ++++--
 security/integrity/ima/ima_main.c |    7 +++++--
 security/security.c               |    7 ++++---
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -18,7 +18,8 @@ struct linux_binprm;
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_file_check(struct file *file, int mask, int opened);
 extern void ima_file_free(struct file *file);
-extern int ima_file_mmap(struct file *file, unsigned long prot);
+extern int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags);
 extern int ima_read_file(struct file *file, enum kernel_read_file_id id);
 extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
 			      enum kernel_read_file_id id);
@@ -44,7 +45,8 @@ static inline void ima_file_free(struct
 	return;
 }
 
-static inline int ima_file_mmap(struct file *file, unsigned long prot)
+static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
+				unsigned long prot, unsigned long flags)
 {
 	return 0;
 }
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -303,7 +303,9 @@ out:
 /**
  * ima_file_mmap - based on policy, collect/store measurement.
  * @file: pointer to the file to be measured (May be NULL)
- * @prot: contains the protection that will be applied by the kernel.
+ * @reqprot: protection requested by the application
+ * @prot: protection that will be applied by the kernel
+ * @flags: operational flags
  *
  * Measure files being mmapped executable based on the ima_must_measure()
  * policy decision.
@@ -311,7 +313,8 @@ out:
  * On success return 0.  On integrity appraisal error, assuming the file
  * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
  */
-int ima_file_mmap(struct file *file, unsigned long prot)
+int ima_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags)
 {
 	if (file && (prot & PROT_EXEC))
 		return process_measurement(file, NULL, 0, MAY_EXEC,
--- a/security/security.c
+++ b/security/security.c
@@ -920,12 +920,13 @@ static inline unsigned long mmap_prot(st
 int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags)
 {
+	unsigned long prot_adj = mmap_prot(file, prot);
 	int ret;
-	ret = call_int_hook(mmap_file, 0, file, prot,
-					mmap_prot(file, prot), flags);
+
+	ret = call_int_hook(mmap_file, 0, file, prot, prot_adj, flags);
 	if (ret)
 		return ret;
-	return ima_file_mmap(file, prot);
+	return ima_file_mmap(file, prot, prot_adj, flags);
 }
 
 int security_mmap_addr(unsigned long addr)


