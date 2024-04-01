Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810233FE2D;
	Mon,  1 Apr 2024 15:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986640; cv=none; b=jyfLgf3l3duF0HIFufJ7IQ6m/iIm4mw/Bct8F+TxyAHdiQxER7KQlRoBov8FCQZmSbp7DVv6QhbUjPzGQ76oqrrbMyg4cOw1XrJe7fv1TaYpSHmRAnKtNpwyFX87ICg92FYQSw4JjchjqKXYe6dKdO13htpUl2bjHoc1mktvxn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986640; c=relaxed/simple;
	bh=VSRjtP9KGGjo6wAjGLIFWKy8fJv10eLMjvR2SjrLQ/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHHX9sMSwQYxY6DUYawaiRidejItAYjo9H4Pf9MfwMZuYON6fm7cuL4K9BsgHj7z+cTswwcvpuFurB8qCqXeJPs181weVOdyIR1L1MsOMw65F7mTN3cNoyXe9O4yjLlaYuVIclpSbmnIbWvY+C3z0zTugh8o4m70XdTe2cUG8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVHSh4zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVHSh4zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10A9C433F1;
	Mon,  1 Apr 2024 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986640;
	bh=VSRjtP9KGGjo6wAjGLIFWKy8fJv10eLMjvR2SjrLQ/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVHSh4zcXwd8Bj+6n2+snZs3dbWNjX0bk/bcmzCcD0/TKG4lhOWp349omV3w+/+D8
	 YlORoscRjSRrA5Td0tOJUPsClquY94Idj4Nji7xAtLpLt+pUrgJYhILGubGM6ycKSA
	 p2X0PlgLWm+Sm24spee/zyLIYAhiMA9+ZqjwwZnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 009/399] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Mon,  1 Apr 2024 17:39:35 +0200
Message-ID: <20240401152549.426425791@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 72b371812a001..6e5f74813c101 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2856,6 +2856,15 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
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



