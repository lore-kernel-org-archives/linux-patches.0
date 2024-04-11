Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA69145353;
	Thu, 11 Apr 2024 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830463; cv=none; b=b4RKN0t0dgKNN6z+nac5vVNceB76Ev1Yo3JlJlL3XD26iVqMYXqCLMtZbBJr/1VM49uAkappESA9yY0iNpZUbQO+uqqf3AJe1bO5OTAIOiA59Kl9pr6VXEilGdEybDRigqEDgtUdS6G/vn6+Sbwf0tD6lko0fKUg2ooQC9qYZ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830463; c=relaxed/simple;
	bh=OxX2KimLLp0ixnNHu+iB08B8JAxnc13jOuJveY6HL84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLw+O6U6eZ1/Mg5b81HjZgDUqNH1ze0Szyu09WnRQRELy9toZWJ4GIsTgjXKi+9DYJ5dKJrza8Cwr0c4CuDNy9/R5HVorVB0YiwpYUhVJgymnpXwAEXsgy6TwjqKypf2pZdu18PKPo4xkwO40DkrKcXqA0OSI4DDNjva5SnxwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLxC7+WN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLxC7+WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CBFC433F1;
	Thu, 11 Apr 2024 10:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830463;
	bh=OxX2KimLLp0ixnNHu+iB08B8JAxnc13jOuJveY6HL84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLxC7+WNuWYmVmsBN/D6JgYFrx748H/oBF/ciSHoMvljjJJkRsEU0sRgF8nKtbnlF
	 p0/rSCwfUfwiXKyD2Usv8Kri4KDl2GrDbaGi2thOui922z7HfSQULPKheCKB2GtU27
	 wYa11J3JgyT0+VgnOBZerS4He6Z1zwLq6PTJDKGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/215] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Thu, 11 Apr 2024 11:53:40 +0200
Message-ID: <20240411095425.221267968@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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
index 65743be5b30f5..072ce1ef6efb7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2717,6 +2717,15 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
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



