Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6D4DF6B;
	Mon,  1 Apr 2024 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989309; cv=none; b=Kiaptt1j3wSSQBhJEKZt5feEZL+jh1gw7mB9/v7f+w63rW7xe6StlgEWETbSLnEhSb62Sp3VFSa4/JbCRpOh2an/+8zMlRVUv4TuzCqooup5uTR0DFwsnbVGf4DAdjiaslRFa0de+lpXILYBy7oaMfzYdIBgOoaLPrzyiXBwO3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989309; c=relaxed/simple;
	bh=OYoNyC8GrwY4vy95GE/o4Icjtq4ShVuRo2Qt0qF6usU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssOkuvsguZjVcrFFw+v30ByIZWJkyhqVKuK/38oJMcvhFsI7dFCtiObA1KgGjKHkyzbk6AbjLoYEWYSHodUszbYQiiqdQKQLQMhlXtTwcQvjVF17VC5k4Cz7qXgY7ER14Xev11RejQFz9AR3ZPpdHg2P6y7gae4tMgOum9Np1Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4k3gm7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4k3gm7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF339C433C7;
	Mon,  1 Apr 2024 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989309;
	bh=OYoNyC8GrwY4vy95GE/o4Icjtq4ShVuRo2Qt0qF6usU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4k3gm7Nq7ZDu4ucOnAmdZOqD27+xfk6YeB1oQBxea07BDgFFlxl+H4uHu0JmSger
	 kPwcr5FTLuIqj750E39PLb8ff+U7cmjTTJa/cRFMoX1/NW+bCTayS5eS+Mzuei0z2j
	 k21kbmKPOHVpP5nxsVzfZvRqMVgXagrNH1QsQKk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/396] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Mon,  1 Apr 2024 17:41:00 +0200
Message-ID: <20240401152548.221049705@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit ac02f007d64eb2769d0bde742aac4d7a5fc6e8a5 ]

If the SMACK64TRANSMUTE xattr is provided, and the inode is a directory,
update the in-memory inode flags by setting SMK_INODE_TRANSMUTE.

Cc: stable@vger.kernel.org
Fixes: 5c6d1125f8db ("Smack: Transmute labels on specified directories") # v2.6.38.x
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0fe3ccec62a52..e1e297deb02e6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2854,6 +2854,15 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	if (value == NULL || size > SMK_LONGLABEL || size == 0)
 		return -EINVAL;
 
+	if (strcmp(name, XATTR_SMACK_TRANSMUTE) == 0) {
+		if (!S_ISDIR(inode->i_mode) || size != TRANS_TRUE_SIZE ||
+		    strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
+			return -EINVAL;
+
+		nsp->smk_flags |= SMK_INODE_TRANSMUTE;
+		return 0;
+	}
+
 	skp = smk_import_entry(value, size);
 	if (IS_ERR(skp))
 		return PTR_ERR(skp);
-- 
2.43.0



