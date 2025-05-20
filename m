Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67D5243371;
	Tue, 20 May 2025 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750550; cv=none; b=PI2O3iWudNfV0NUap/QB2wVDuC04ozoDpKPZ1KR+xUimC9RMxHj2Q+J31odCWbH+A8uTVRVpFr0TJWIODTzGLabmP2ycW4aCMIOA1OLD1aMaBVclJZdiWXpJfxQkKaWg0G23S2CJ0H937zIJdqPGc+UrWKnHgNmvtOeB42Zr/Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750550; c=relaxed/simple;
	bh=AfRBPd2ekAxAZUGRr8fA8dxZSvEjmV48i4jIFNzAuIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sshJe/MG4/djszYPAJnU87ufXRMMLkcPfuWh1bv84RXDeoNUi4Wp1kvc8GEBIM2zA2d4x6CiLhcoE5L+rSUo0tWZ2sCN0WhRFVSl1I5ahe05tqadn7QzdAU+84/hDClLnC+PibTvbafgMhaw9tdDqG48WJNXN2DpvBW/K5lBCVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWYA1gWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWYA1gWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA6AC4CEE9;
	Tue, 20 May 2025 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750550;
	bh=AfRBPd2ekAxAZUGRr8fA8dxZSvEjmV48i4jIFNzAuIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWYA1gWcG/kiOlV7sltRP6MX+MctLBrSU7iv02AIY7qwUAkyiDNkzBsD4l964N6zw
	 97VFEoi6IGAttAeTz4NkCVb3661bBmk7aGsLdoGGOWCYJ00mY0wICyrvgjWxZDDZif
	 IPFVtv5KDP4ONixo1Tf40M1eJ/Hz4jdQGlg7oFHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 014/145] tracing: fprobe: Fix RCU warning message in list traversal
Date: Tue, 20 May 2025 15:49:44 +0200
Message-ID: <20250520125811.109464485@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 9dda18a32b4a6693fccd3f7c0738af646147b1cf ]

When CONFIG_PROVE_RCU_LIST is enabled, fprobe triggers the following
warning:

    WARNING: suspicious RCU usage
    kernel/trace/fprobe.c:457 RCU-list traversed in non-reader section!!

    other info that might help us debug this:
	#1: ffffffff863c4e08 (fprobe_mutex){+.+.}-{4:4}, at: fprobe_module_callback+0x7b/0x8c0

    Call Trace:
	fprobe_module_callback
	notifier_call_chain
	blocking_notifier_call_chain

This warning occurs because fprobe_remove_node_in_module() traverses an
RCU list using RCU primitives without holding an RCU read lock. However,
the function is only called from fprobe_module_callback(), which holds
the fprobe_mutex lock that provides sufficient protection for safely
traversing the list.

Fix the warning by specifying the locking design to the
CONFIG_PROVE_RCU_LIST mechanism. Add the lockdep_is_held() argument to
hlist_for_each_entry_rcu() to inform the RCU checker that fprobe_mutex
provides the required protection.

Link: https://lore.kernel.org/all/20250410-fprobe-v1-1-068ef5f41436@debian.org/

Fixes: a3dc2983ca7b90 ("tracing: fprobe: Cleanup fprobe hash when module unloading")
Signed-off-by: Breno Leitao <leitao@debian.org>
Tested-by: Antonio Quartulli <antonio@mandelbit.com>
Tested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 95c6e3473a76b..ba7ff14f5339b 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -454,7 +454,8 @@ static void fprobe_remove_node_in_module(struct module *mod, struct hlist_head *
 	struct fprobe_hlist_node *node;
 	int ret = 0;
 
-	hlist_for_each_entry_rcu(node, head, hlist) {
+	hlist_for_each_entry_rcu(node, head, hlist,
+				 lockdep_is_held(&fprobe_mutex)) {
 		if (!within_module(node->addr, mod))
 			continue;
 		if (delete_fprobe_node(node))
-- 
2.39.5



