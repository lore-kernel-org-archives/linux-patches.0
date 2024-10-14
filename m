Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B6A3BBF2;
	Mon, 14 Oct 2024 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917892; cv=none; b=pLA7DeTIkuOmhjjvZ6J4EnhV6Etf/FxUk9qiz68Uj4O1ECyMINle8cmhTEi/ilDZDTNvuXoQ0ip5ljEYWDQPvzcj4zXGeK8Z6OcKN8L1i+yLa6fkLAEalQnKkyKzUXXW2Q22h21OUUBH9m23RtSFJ5TNgOnlY9TV7ylwk9uzEqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917892; c=relaxed/simple;
	bh=W5JM9HwaMPQNIdk9J/wmZo1LR/9Mc+Fzo4p0vzUxRyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWEHwKZMEA3H93sd1eIjxiDk7Maaow/fJTiveu8Jl1sSTWlKcbypTZNP0AUiVZOQxlXlwyYM1NgpyVyyDOvXMIcNnh5fAHQ1l/YJ7ekSJdC1MOfQKg3v5lpFSk9LfATfH8T7v3rJyMETvugZt+ukUAZQA4oRA5ZkfMRKn4WQIh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8tcsh7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8tcsh7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3912C4CEC3;
	Mon, 14 Oct 2024 14:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917892;
	bh=W5JM9HwaMPQNIdk9J/wmZo1LR/9Mc+Fzo4p0vzUxRyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8tcsh7CGLfQfgZYyrNxkN3CDI/3HHKans3IRwX+9IsB+/kwL5Y5r7MLyJnsEzhWr
	 FYwBmKS+s9cpm8bfnNqgHOwrxTAM4mobTHgmecZRu3WLNdO10rHSYiR548mzYZDUPA
	 TAYtEHAzmwUzJyA7rhY2hHK0DAvU6ggsECF7Bj+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/798] smackfs: Use rcu_assign_pointer() to ensure safe assignment in smk_set_cipso
Date: Mon, 14 Oct 2024 16:11:59 +0200
Message-ID: <20241014141224.411055830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index da7db9e22ce7c..d955f3dcb3a5e 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -921,7 +921,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
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



