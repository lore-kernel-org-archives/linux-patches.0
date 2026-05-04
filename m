Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0268D3DFC74;
	Mon,  4 May 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904724; cv=none; b=VHho9bM38S3B6WhetisTlWvoGWdgCIm5XwFmT7Q7AxKjlGc9fxq8bktOs2wpvKzur68kPv1B/429VMfRxaTTqknknrQLbxiZV49YQrYzAWwLGtT8l5Zb7mpVXHjQoBNDvMXVjMcoxtkE7wAO3CH9lGTveBALjiO+12b/EkPaxMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904724; c=relaxed/simple;
	bh=J3ispVzi28WzJdoFtT2jcBVb9NnkIk6znf9u2614XbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQOPyggggHImpelzFr0+g48t4pTePdz0OQclbHBuSrUdvvZzzS5ahMRyEbcQTzXEs1ifGce7uPOa7cqZ2lXwvszihUUIQ//lLrklKWhXfzP9JCIiFSR99Xv6xCCYZjSgFLU5B78xEzhaKp7mbS7cvryPTax7BJq39AkdA7I/bjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6+/lyaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6+/lyaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4503EC2BCB8;
	Mon,  4 May 2026 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904723;
	bh=J3ispVzi28WzJdoFtT2jcBVb9NnkIk6znf9u2614XbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6+/lyaEioa2DoSm0f1Bov/wNnUB0D51+ZsvOZaDwqDkhGwZYkU0qci+P7JsfHb7h
	 rWETlw1F1HOJyY/4gvU09D8fw6797k69DhBbXz8dKRlJ7Ct2NiDTphcQ7nYjhTcU1p
	 izE38g03q3vU5FEnTFgknrTNxlGbgQcwe2YDZxT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 150/215] apparmor: use target tasks context in apparmor_getprocattr()
Date: Mon,  4 May 2026 15:52:49 +0200
Message-ID: <20260504135135.647806264@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -823,25 +823,23 @@ static int apparmor_getprocattr(struct t
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


