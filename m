Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7DBA3F;
	Mon,  1 Apr 2024 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990621; cv=none; b=hIACA/Jpc68u1FtnBivbGhIor5ZFBufg7SxMSjL4zvbrqwAptg60MqC14dq4nUF99CBNAQlNy6N/uCg92oQu7MFhw1y1dZoAZlA57fkM3pOflw3/OnhFW0dfGcaoKR699E36hNkB8EhztFuFfhciqgykNUqVe+swrMAe0tnEu+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990621; c=relaxed/simple;
	bh=gU5Lly2vyXGtBxlPoBCQ9wCa/5tf7dRugPWAw5kN2ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvQFRzZxHGneA7m0oMKGjuGeQlmbUWqJ7H/bLBbjnfUKUQkEU0QAgZ8SXmvDvAqvEhESfg/BLfiwZr3DRmjSNgAclxIpQXe/VvdBT6UmUt6zmENb7UFmOCzJVKjbspfDZvzF5DZykYh93Rbnrec5bwSGRltwg3QnXldQf5OVPxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W948eBP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W948eBP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5C0C433F1;
	Mon,  1 Apr 2024 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990621;
	bh=gU5Lly2vyXGtBxlPoBCQ9wCa/5tf7dRugPWAw5kN2ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W948eBP9VBYQlmU1bg8KGpMFMpJwq6Ecj4WOuYaUeHRkY7aYD/fxVpe4g0cHKjZlw
	 VnPzS5Dfcyd6jp0FpgRB0QMX6uBCClYsEAxX8ml0n+Dx6XUAUhuGmzX4M+MMM/DMcv
	 I3NKXyPrzzJXtmeCnTMNqpw79UDc4KTEObgHnmLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/272] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Mon,  1 Apr 2024 17:43:25 +0200
Message-ID: <20240401152530.771176172@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index 07f7351148ecf..feba69549d086 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2783,6 +2783,15 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
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



