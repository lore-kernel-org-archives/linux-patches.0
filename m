Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D0F42A9B;
	Tue, 27 May 2025 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367718; cv=none; b=hac1/qp0KsekBMr5WZYvJZm57lStgs/dwS3HX4vsWlPAI4g3nUSsu45t9O/pG9bcVFToDPRBXPaIM8gTPOknBJsFqxXh+rbomDKmWEOI18b3MiIjCMmBEwZNoZr7IlIG5Oli91ZSlPD866ZIsQ5IOMThcmgvNyUQzR3U8cHvHAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367718; c=relaxed/simple;
	bh=1pDxtUY02ttLFfUMz+uFPbwwln0BJ7zza8Y1SBflahM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWJDiVoLE2o+1Aa3efOY357PFWvt8KzL/jMvjmPkqDFegbCVvTSViEoRqLvs3T3unh7btjWckYkN9mr7+MSpd7GLYH4r++ZcC+TVK+tXj5cTLd7kmz8JmL51Bszc6OMGObKEipJY/yDlsEMJAHzNJ+fX8+3gWz9MviPzeZdOinM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQT9ATYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQT9ATYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13B9C4CEE9;
	Tue, 27 May 2025 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367718;
	bh=1pDxtUY02ttLFfUMz+uFPbwwln0BJ7zza8Y1SBflahM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQT9ATYwpN5b26JlLl0ZJxCt6h0N0eVj8KFGlbn5AsdOszAYqd4VRXm6v7a+TcQu0
	 vHdBNaTqMELbp5XvWWmFNKCCSQ0DjJuXqQgA2CzqWN8YqxwF+q1V1TyVVWEeFvBt0+
	 ifU/PblqVjCj6OY9s3LvsneO1T+XBbLVf43rdmto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 447/783] smack: Revert "smackfs: Added check catlen"
Date: Tue, 27 May 2025 18:24:04 +0200
Message-ID: <20250527162531.336072782@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index d8f9922804974..a7886cfc9dc3a 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -812,7 +812,7 @@ static int smk_open_cipso(struct inode *inode, struct file *file)
 static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos, int format)
 {
-	struct netlbl_lsm_catmap *old_cat, *new_cat = NULL;
+	struct netlbl_lsm_catmap *old_cat;
 	struct smack_known *skp;
 	struct netlbl_lsm_secattr ncats;
 	char mapcatset[SMK_CIPSOLEN];
@@ -899,19 +899,8 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 
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



