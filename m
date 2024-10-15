Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EE61EABC3;
	Tue, 15 Oct 2024 11:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992744; cv=none; b=L4dYgFcqklbI9tNPeiwm6VsOKRBDREt2WBctV5C++3cTfX1p0ew6eFl/Q3VI/oWF/k/F0JlK1iADUY4v8/Stnz07y0o22ErEm34e9q6MYREJBd6BBbx/a4skPSSAMphdu114SWCxAvfQhcrmyzle7jaxZUh6xH9tQ+B9z6y7bGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992744; c=relaxed/simple;
	bh=Vm7mqtZ5lMCfDsFDdZoRkelZMpcjd0daPBOII1h0Ueg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSpHbJlK4R0uuSOUr/zzxBEMyviboeqs1sG9MERaFvStSOxbilu7JEG49o8/mtG5aQrhF9lt1PlyV/5AbODCObCn1BJNX1vl6uTXn+zbekVITG1jItm1UYE/WyuhIc9ns/6vzM0BBm8luXWunaSNakE8LaxH+LfbSESz/6D1wDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEWcWPkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEWcWPkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F8FC4CEC6;
	Tue, 15 Oct 2024 11:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992743;
	bh=Vm7mqtZ5lMCfDsFDdZoRkelZMpcjd0daPBOII1h0Ueg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEWcWPkDC35aYzfxpMgxw7nTk9N4l1aNJoZYC4np0EjaqczUxUhqJ3W3IRhuEs7rq
	 GcqbBgQQtF7vFjYsPPDxXy3An/bF9phQ/1yczM+FIvKFxC3eDiC1QqKIMxMdb2eWDv
	 XccFhpGtvjI5ZQ+AOegz6rDm7JwQAS3xAmggqNOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/691] smackfs: Use rcu_assign_pointer() to ensure safe assignment in smk_set_cipso
Date: Tue, 15 Oct 2024 13:22:32 +0200
Message-ID: <20241015112448.456305697@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 27fd7744e0fc0..f6961a8895296 100644
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



