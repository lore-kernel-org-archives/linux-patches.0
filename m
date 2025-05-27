Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A113086347;
	Tue, 27 May 2025 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365405; cv=none; b=IODklYf37hRnJ1vcECzKjivVLcwfveYPTpiDqe8jNJt8hw0xAIztvFYzV0U0cxYag417ex88cRAqmc9/rEFjXHLwU3Rmmq/BHwKuqu+5QyUtqYJY6ADx1jZT4GmKVDinc0NYoFa1GqBGXDGyA7TekhaOkIw7EsyWnTTCeTD0NSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365405; c=relaxed/simple;
	bh=pqXeNknQJMQZRQWxtkTSgnS1SYDfotwd4nMHSFl9pgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIDJvw8tP/VZGIfRh6SRbMeHFAabrx9osbaEMC32fbnlt6emOAV0Bg1Hv8fZi1fC2c6edMFTpb5qpujna2khldp4tygbDPt9K/YSGkTA4t9gei2aQ/LAE1n5EKj/g9W6zl5a6zzxTiL9yIGD+JxyghZnLvCP1HR1gH7t0AB9pNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDsVYBCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDsVYBCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28286C4CEE9;
	Tue, 27 May 2025 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365405;
	bh=pqXeNknQJMQZRQWxtkTSgnS1SYDfotwd4nMHSFl9pgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDsVYBCEF8zPnCo1vN7iYYXSABTUZTYV7q/q9zLUYZpLSKGC2Y9B7b/EhY+OeTj2c
	 7yQUo9Bhav0QJSvHlZEtox1jqh2tIXnadirdmD5zV8ADZvdZmDCaF/LPje8SajY5vH
	 YEN8yc7iQ4FIngt3jgbRj/7fg3WlPEJeqRSgEIGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 365/626] smack: Revert "smackfs: Added check catlen"
Date: Tue, 27 May 2025 18:24:18 +0200
Message-ID: <20250527162459.855743990@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit c7fb50cecff9cad19fdac5b37337eae4e42b94c7 ]

This reverts commit ccfd889acb06eab10b98deb4b5eef0ec74157ea0

The indicated commit
* does not describe the problem that change tries to solve
* has programming issues
* introduces a bug: forever clears NETLBL_SECATTR_MLS_CAT
         in (struct smack_known *)skp->smk_netlabel.flags

Reverting the commit to reapproach original problem

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index d27e8b916bfb9..1e35c9f807b2b 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -830,7 +830,7 @@ static int smk_open_cipso(struct inode *inode, struct file *file)
 static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos, int format)
 {
-	struct netlbl_lsm_catmap *old_cat, *new_cat = NULL;
+	struct netlbl_lsm_catmap *old_cat;
 	struct smack_known *skp;
 	struct netlbl_lsm_secattr ncats;
 	char mapcatset[SMK_CIPSOLEN];
@@ -917,19 +917,8 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 
 		smack_catset_bit(cat, mapcatset);
 	}
-	ncats.flags = 0;
-	if (catlen == 0) {
-		ncats.attr.mls.cat = NULL;
-		ncats.attr.mls.lvl = maplevel;
-		new_cat = netlbl_catmap_alloc(GFP_ATOMIC);
-		if (new_cat)
-			new_cat->next = ncats.attr.mls.cat;
-		ncats.attr.mls.cat = new_cat;
-		skp->smk_netlabel.flags &= ~(1U << 3);
-		rc = 0;
-	} else {
-		rc = smk_netlbl_mls(maplevel, mapcatset, &ncats, SMK_CIPSOLEN);
-	}
+
+	rc = smk_netlbl_mls(maplevel, mapcatset, &ncats, SMK_CIPSOLEN);
 	if (rc >= 0) {
 		old_cat = skp->smk_netlabel.attr.mls.cat;
 		rcu_assign_pointer(skp->smk_netlabel.attr.mls.cat, ncats.attr.mls.cat);
-- 
2.39.5



