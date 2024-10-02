Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C261D0787;
	Wed,  2 Oct 2024 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878114; cv=none; b=Q6DB4pyUasznfJ/XeO3UrbW46uvYdTrNoR4PPdZFi2HcGxtXwZAmv2ZkAdnX3ULcOxTCZxNhJH7DW46q41BA1kWc9UTMzQQwK7VPWcIcPlPm6ylKl79y2V1hlmEoI1GXbQu3vQOZ1/hBpxmP37+k5oL7KWqXU4UgwzSMFEOOY8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878114; c=relaxed/simple;
	bh=3PmBV7R6SBekWKfGbQRNqJokrWF4+aP/tqlBXFEEbbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5xxyo8Edbkk49S5TdTSCf5wreRuC75uGRMTYoq0ujkz9k5A+fR7tETlcsBTFYIVQnCRuz0LSoWi+BfG679tp2eJbP10O2QyvVN32eQfjMorCf+FxpN8Pi1tbjD4Ysbei2NVhjw7Iw9WfPoavFQumHFTRgmoLiAjbxuBD4C/F9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuurbY5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuurbY5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C13DC4CEC2;
	Wed,  2 Oct 2024 14:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878114;
	bh=3PmBV7R6SBekWKfGbQRNqJokrWF4+aP/tqlBXFEEbbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuurbY5/1VogOkih6Hnt60fOiqrq/YMxWzEoF4NSCYwa2wxF7JZnFRbqCdwsbbUDo
	 190K3BsD5FTDeXTRuZDauI59zD3jTZHjcthaoEzh/C+aVvMkf+hi+tTAw3tkAiuvVd
	 dckIPBOLRQYWZp/SxMt7ifrb4+uryQ2ygjuRdyCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 276/634] smackfs: Use rcu_assign_pointer() to ensure safe assignment in smk_set_cipso
Date: Wed,  2 Oct 2024 14:56:16 +0200
Message-ID: <20241002125821.995726012@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e22aad7604e8a..5dd1e164f9b13 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -932,7 +932,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	}
 	if (rc >= 0) {
 		old_cat = skp->smk_netlabel.attr.mls.cat;
-		skp->smk_netlabel.attr.mls.cat = ncats.attr.mls.cat;
+		rcu_assign_pointer(skp->smk_netlabel.attr.mls.cat, ncats.attr.mls.cat);
 		skp->smk_netlabel.attr.mls.lvl = ncats.attr.mls.lvl;
 		synchronize_rcu();
 		netlbl_catmap_free(old_cat);
-- 
2.43.0



