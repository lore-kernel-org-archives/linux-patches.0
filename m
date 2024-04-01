Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE9E43AD6;
	Mon,  1 Apr 2024 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987950; cv=none; b=Wt+cVL/OFGEH78V9cKd+fCadc8h23Ykc0xTOIE3elc0XOxBecPMijC8IdEKV9o5MVFFhv4W3HV5BG/eHt4B8QeHofLYzRmOHptBk49dIDAIYK8E1TVPK5Zi1fTm/tfaUhti7FhqKMk84nqjkHWI1MWbbNS1825YH/4jE/bZub7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987950; c=relaxed/simple;
	bh=879sPgWfEQrnyN9tgjdEZzI6RmNoKazVltba8sIUNaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWa3zu3YdiNEjKh7EVnkP66WtB+bObV791kWNL8nmAVFB7u8SWd9rn6IZCaZv0AfAlev8DChSjjvSOii58C5hgHNU7rYSfbxQIJlPVQDK77t/UHfEvVEZ2hK7wr/OKBgudzKKREJ+Hef9qy/KskFlC60W6qEG4klOv8V9qzTuW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7RK4G+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7RK4G+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C421C433C7;
	Mon,  1 Apr 2024 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987949;
	bh=879sPgWfEQrnyN9tgjdEZzI6RmNoKazVltba8sIUNaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7RK4G+YGKLyh4gCD8jrvA6ZiWra4uPS6aWt8cI2y/meEUtzTnJ4X9zYkiOw+HWYr
	 gVHiPQmDwn9J/CTlfi0nmK8OJBgC2NVlAvWjpsLFdvFyLzcZlLW7ihnaTNf+8Jso0e
	 a0IVt2rJ7q7RpWYxxkN6DcRTJxKX7i9SqeID78RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 011/432] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Mon,  1 Apr 2024 17:39:58 +0200
Message-ID: <20240401152553.465775992@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



