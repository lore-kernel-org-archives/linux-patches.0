Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9F53D9029;
	Mon,  4 May 2026 14:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903485; cv=none; b=G3G/hu7WpQSj0UTBLAlr1/IRpz17bG2wvld1hzlI+EJdvK78GKa3a+I5SH80Oxiy0nhtMnvmQy+FuS5bw5P5cInkAME7kMSlNqFQrGTi7VMqZnWPn8ESPRtpJzXQ/OvdkgOi9NLr185YzuPovbpssV/SkcqBamUH6m6pafqFGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903485; c=relaxed/simple;
	bh=dLOPJYoXbCUtFjpsERn16wtMs5pd/z9EUq8PprMQwCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTrHfeoTsABXEB9wuDBYsYqd1+TEx4EHXSJAfiPqnyNwrGKQuACfAUG0vbRoTvFUARx9+UXJK3Imc1UGt11sgpdhaC+Shnp5QhZQdtcZohtV4PWtLCZ2iNkf5TKnfSfE4PZrsBf2qeB8pPi/p0owQhOf1imyEqLULntbMjIo32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FICafbhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FICafbhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B8AC2BCB8;
	Mon,  4 May 2026 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903485;
	bh=dLOPJYoXbCUtFjpsERn16wtMs5pd/z9EUq8PprMQwCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FICafbhYMYpvyAVIQXdLVhgNikU3WV8/AjsxIM6RVRxk9iALLqor4Jmrvr9na1wTW
	 36BF6j2eoKRXtnSNy2dpETBd7HER7M9KSdMptITH4zXU/HAZC9bsWLxVY9de2LVCZG
	 7OhXj8LkryYO5RWMBtkFE0/4w3DcmqiCWbNrz1T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 7.0 253/307] apparmor: use target tasks context in apparmor_getprocattr()
Date: Mon,  4 May 2026 15:52:18 +0200
Message-ID: <20260504135152.340442833@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Cengiz Can <cengiz.can@canonical.com>

commit 4afc61702bdcc3b9b519749ef966cf762a6e7051 upstream.

apparmor_getprocattr() incorrectly calls task_ctx(current) instead of
task_ctx(task) when retrieving prev and exec attributes, returning the
caller's labels rather than the target's.

Fix by passing task to task_ctx().

The issue can be reproduced when a process with an onexec transition
(e.g., configured by a container runtime) is inspected via
/proc/<pid>/attr/apparmor/exec. The reader's own value is returned
instead of the target's.

Reported-by: Qualys Security Advisory <qsa@qualys.com>
Fixes: 3b529a7600d8 ("apparmor: move task domain change info to task security")
Cc: stable@vger.kernel.org
Co-developed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Cengiz Can <cengiz.can@canonical.com>
Co-developed-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/lsm.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -822,25 +822,23 @@ static int apparmor_getprocattr(struct t
 				char **value)
 {
 	int error = -ENOENT;
-	/* released below */
-	const struct cred *cred = get_task_cred(task);
-	struct aa_task_ctx *ctx = task_ctx(current);
 	struct aa_label *label = NULL;
 
+	rcu_read_lock();
 	if (strcmp(name, "current") == 0)
-		label = aa_get_newest_label(cred_label(cred));
-	else if (strcmp(name, "prev") == 0  && ctx->previous)
-		label = aa_get_newest_label(ctx->previous);
-	else if (strcmp(name, "exec") == 0 && ctx->onexec)
-		label = aa_get_newest_label(ctx->onexec);
+		label = aa_get_newest_cred_label(__task_cred(task));
+	else if (strcmp(name, "prev") == 0  && task_ctx(task)->previous)
+		label = aa_get_newest_label(task_ctx(task)->previous);
+	else if (strcmp(name, "exec") == 0 && task_ctx(task)->onexec)
+		label = aa_get_newest_label(task_ctx(task)->onexec);
 	else
 		error = -EINVAL;
+	rcu_read_unlock();
 
 	if (label)
 		error = aa_getprocattr(label, value, true);
 
 	aa_put_label(label);
-	put_cred(cred);
 
 	return error;
 }


