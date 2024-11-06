Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C581EE005;
	Wed,  6 Nov 2024 13:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898023; cv=none; b=tmI1IwahyxWCypwWtYgKgQBnjNS++JoeP/xoZ33bMy4GXtwU7kwXaVaLeQRnUqIU5+lZNerx6pCf1zUkDrbYbAzEnpdKngpJICKR0lEcUa0YzqdYt+7D4uIRI1m29SorAUX3Yvzo9jE8MoTgv7gWBhHg39pGbxYQM9KOlAkr5ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898023; c=relaxed/simple;
	bh=9CjO1K6QVPIkl/WkCKJ9l7A1C0qtbi5uw4UYW5/eWfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGOSji3p6PAXiJzMXOXMd+IyVORZd/n9Me/kQfZBQKlSMcxkihwpxdw+7EAugJzVsTbmGPM3i8Xv+MaNOlziERULm78mQOt6/WHN42VkwQp64nBzmFXgQo/OM6M5KsclbyzVfKuuri+HfR0PJ2YJ11n4LwMMa6wqlpoeMWi8Xnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNAGtaYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNAGtaYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56548C4CECD;
	Wed,  6 Nov 2024 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898023;
	bh=9CjO1K6QVPIkl/WkCKJ9l7A1C0qtbi5uw4UYW5/eWfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNAGtaYmA3XLjekaNz1YtLyCdMvOuBGPpnqQ6qmrEUOfsgVIVwMO3EVW9b0YOJ9Vt
	 f+lBzwm/2/ShnGbh2vO8HoXxKUN/Iv4KRUCX07cW9H//2+YxhUFnrL3uZ3HsqA1tY/
	 2j6j9acJRxMsE7ISAV6kMPurEBAl7t/4kYoJ4KJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/462] smackfs: Use rcu_assign_pointer() to ensure safe assignment in smk_set_cipso
Date: Wed,  6 Nov 2024 12:59:50 +0100
Message-ID: <20241106120333.904844189@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawei Ye <jiawei.ye@foxmail.com>

[ Upstream commit 2749749afa071f8a0e405605de9da615e771a7ce ]

In the `smk_set_cipso` function, the `skp->smk_netlabel.attr.mls.cat`
field is directly assigned to a new value without using the appropriate
RCU pointer assignment functions. According to RCU usage rules, this is
illegal and can lead to unpredictable behavior, including data
inconsistencies and impossible-to-diagnose memory corruption issues.

This possible bug was identified using a static analysis tool developed
by myself, specifically designed to detect RCU-related issues.

To address this, the assignment is now done using rcu_assign_pointer(),
which ensures that the pointer assignment is done safely, with the
necessary memory barriers and synchronization. This change prevents
potential RCU dereference issues by ensuring that the `cat` field is
safely updated while still adhering to RCU's requirements.

Fixes: 0817534ff9ea ("smackfs: Fix use-after-free in netlbl_catmap_walk()")
Signed-off-by: Jiawei Ye <jiawei.ye@foxmail.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a71975ea88a94..ddb0a292802ef 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -920,7 +920,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	rc = smk_netlbl_mls(maplevel, mapcatset, &ncats, SMK_CIPSOLEN);
 	if (rc >= 0) {
 		old_cat = skp->smk_netlabel.attr.mls.cat;
-		skp->smk_netlabel.attr.mls.cat = ncats.attr.mls.cat;
+		rcu_assign_pointer(skp->smk_netlabel.attr.mls.cat, ncats.attr.mls.cat);
 		skp->smk_netlabel.attr.mls.lvl = ncats.attr.mls.lvl;
 		synchronize_rcu();
 		netlbl_catmap_free(old_cat);
-- 
2.43.0



