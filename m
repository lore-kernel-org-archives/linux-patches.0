Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9853F23B3;
	Tue, 17 Mar 2026 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766425; cv=none; b=S+aChyWMr1jyS7LnX8ycvADZagt80oohj3Y+0+WJUfXJ77/Skw+IGdcHjbfSXSRPTXjCnnTVYdf8FyuMGCasWq+OeoI29uuhd9sV+TBRvD09qaw9W+Cyr6wOy3yGjBteDh/UAo8rTWo0ZRsetq1ttO33zGfrp05TlCZx6CUdYvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766425; c=relaxed/simple;
	bh=kBYZeSiRxcVhe6HbbzYFQtU2HtqxHwKPcAMg1HlP9OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQXsiQb/7cTornCeGkfcECGcd+jxF/o8NHwi8hNNKfGTsfoWTNJvuixBeOSrFTj8xCsK1yS4rTXYaiio4Y1O54ep7djSON7y5hWEJnDrZWBjgnJ19gDtZArjY8u2I61p7h3AyCzssvmaZFuJdYle+4mw1SdjA65NHp8IGlIJT4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTFTsjPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTFTsjPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9796FC4CEF7;
	Tue, 17 Mar 2026 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766425;
	bh=kBYZeSiRxcVhe6HbbzYFQtU2HtqxHwKPcAMg1HlP9OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTFTsjPV07+sgNxxx5MU1BfCPlTjG7W7CUl/RMFvD+C4HbntsjnqfQgzTijEgViVX
	 eQsL37/cnKJ/AV1mdFCkesZpHWoH/Pgu7pBFA0RqkNG8AaRgApLq7heHCErjXA8vbx
	 gHogI/akn8HsaQQcd84BHdmIVqG6cE3KyU+kO61A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 244/378] nstree: tighten permission checks for listing
Date: Tue, 17 Mar 2026 17:33:21 +0100
Message-ID: <20260317163015.995600371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 8d76afe84fa2babf604b3c173730d4d2b067e361 upstream.

Even privileged services should not necessarily be able to see other
privileged service's namespaces so they can't leak information to each
other. Use may_see_all_namespaces() helper that centralizes this policy
until the nstree adapts.

Link: https://patch.msgid.link/20260226-work-visibility-fixes-v1-3-d2c2853313bd@kernel.org
Fixes: 76b6f5dfb3fd ("nstree: add listns()")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@kernel.org # v6.19+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/nstree.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/kernel/nstree.c b/kernel/nstree.c
index f36c59e6951d..6d12e5900ac0 100644
--- a/kernel/nstree.c
+++ b/kernel/nstree.c
@@ -515,32 +515,11 @@ static inline bool __must_check ns_requested(const struct klistns *kls,
 static inline bool __must_check may_list_ns(const struct klistns *kls,
 					    struct ns_common *ns)
 {
-	if (kls->user_ns) {
-		if (kls->userns_capable)
-			return true;
-	} else {
-		struct ns_common *owner;
-		struct user_namespace *user_ns;
-
-		owner = ns_owner(ns);
-		if (owner)
-			user_ns = to_user_ns(owner);
-		else
-			user_ns = &init_user_ns;
-		if (ns_capable_noaudit(user_ns, CAP_SYS_ADMIN))
-			return true;
-	}
-
+	if (kls->user_ns && kls->userns_capable)
+		return true;
 	if (is_current_namespace(ns))
 		return true;
-
-	if (ns->ns_type != CLONE_NEWUSER)
-		return false;
-
-	if (ns_capable_noaudit(to_user_ns(ns), CAP_SYS_ADMIN))
-		return true;
-
-	return false;
+	return may_see_all_namespaces();
 }
 
 static inline void ns_put(struct ns_common *ns)
@@ -600,7 +579,7 @@ static ssize_t do_listns_userns(struct klistns *kls)
 
 	ret = 0;
 	head = &to_ns_common(kls->user_ns)->ns_owner_root.ns_list_head;
-	kls->userns_capable = ns_capable_noaudit(kls->user_ns, CAP_SYS_ADMIN);
+	kls->userns_capable = may_see_all_namespaces();
 
 	rcu_read_lock();
 
-- 
2.53.0



