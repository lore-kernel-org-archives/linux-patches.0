Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102E61D5AD7;
	Wed,  6 Nov 2024 12:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895004; cv=none; b=rsDiXjrNm/vWYzzTBH9IHKkhy73AAHrfnjtOvc8aOh9GaQ+pKVK3d7KUm/eZ7NarK62wNyb8fFntD19EtIwQ/dDiGQVqGGx+1+ikLZISRH4mGhQlwNxvXfUqoTrUbD/v6VqspjmLVRh/Jv3uHZ1bL0K+rVYWokPzuHhoR51vMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895004; c=relaxed/simple;
	bh=kKaBlDNOL9KaYaIFD5igVamhepso3nOpXfhPBlGCDDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5PsH+OAEHddvwpBCFa4Dwl0m+G5mWWSUoMv4FOwneWqzDT0QYmb2mGPyh7piqXqsVvH/Fz1KJHyO3oRf8+myEhHfr5NvIy9tCd/VGVKvQF4AdJtvIxYIaUZFGqvAEPzBYgdCJmlV7e49MZjhJuraLxsWpGlLbP+aw6T7caaZIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2khePoRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2khePoRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E70AC4CECD;
	Wed,  6 Nov 2024 12:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895003;
	bh=kKaBlDNOL9KaYaIFD5igVamhepso3nOpXfhPBlGCDDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2khePoRTb0LivHV4OlsssE3cbAJSrEOukEFJFwmtkeH+1e2mpegegl8qcTcaeEiNX
	 o6YxOf53SdVaLvk8hnjmlPbGWjCiFQDKCyBIT6l7QwBvHe9uN+bseMid0lnusUkYm/
	 UitbERUhnBKntM7kmg5NG2haZ5JMgvm54CSaDu5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/350] smackfs: Use rcu_assign_pointer() to ensure safe assignment in smk_set_cipso
Date: Wed,  6 Nov 2024 13:00:00 +0100
Message-ID: <20241106120322.675878702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 61e734baa332a..83dbfa26a6518 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -948,7 +948,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
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



