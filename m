Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69017172F;
	Mon,  8 Apr 2024 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581267; cv=none; b=bRSH2BQ4OHy6RU+D/xkPFBgiO2p6T4IPhYxo2QeVfHs6S2Nk2CLJUzT9kZExISPT5wEu+GlKeEFaocrpaLFhNfLQDz8SPn8vI6w63EnvTynzT0Clsq95Ho+caiAoIJczEzUK8zXPevYFpSUMgbIqSGdZLsnT3Cbr9W1VQsQpUJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581267; c=relaxed/simple;
	bh=mJVNz6AFZQW6ryAvHQfJz7lB5EO1N+8tbGdvIcF7DWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYjqUmWgWJt0cmVe7i5iux9LhaqTfKJ/55CCDHdjbBahetAhIcY2uQkCmJzGeuaEYNh33jEieIWYSOSDw9cmPYo6cmTvP+viwL8wCgjEeJqzqbmCIZ9T8tsZaIw1aWKFh6T7opaYHbfbUI8+K0eTG6ksB+gYrtgbRsm+G91G5io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvczYpuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvczYpuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCE2C433C7;
	Mon,  8 Apr 2024 13:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581267;
	bh=mJVNz6AFZQW6ryAvHQfJz7lB5EO1N+8tbGdvIcF7DWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvczYpuEu0eFXXAcQuPEoYZO9SRUTfUadQ/0AK8MrEMUmzuBc44r1PmSxO3mlVCjz
	 XXXgphuKdLSBFYtkSpEj+GdXw4yfQBmVrv4xCDOWNeAcEcsZTdwpwnRKeKnCi4fc6p
	 NnixDB4Pjjj/InKOizUlexv+mBKSGYqimJqtvK38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/690] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Mon,  8 Apr 2024 14:48:00 +0200
Message-ID: <20240408125400.057653494@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index c45f0d61447c7..c6f211758f4e3 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2721,6 +2721,15 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
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



