Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF93114AD2E;
	Thu, 11 Apr 2024 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831445; cv=none; b=orS0e7PZkGzUER6H1O8RQMgvvLYV8l1lI6o+XAH+7MUevQVoBYOPFZbjCVtPj7CxybnaF/FbvWmNq4Uv42jOSAjs6lci1Wq137QMut44rIm2S5oUJgOHfx0us/ZOVUPGYInYTqvVY3dtNNzVM1kfTFYdPVZ4HrRo7MtNFUaI0Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831445; c=relaxed/simple;
	bh=XAPZ2s5IlXHU9PFUrUUc8M/4Ir45YsErKDqWN3XuDx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPs68Hel5WB2twHv74gDJBKCtKjcQcn9lGjwmbyXvTwIpfwN5J3wzeQ8pPpbBbqV0Rpjh8VN/slUl89NEqU+P3Jp+HEU3ttnfakM/9bA2lvyS0ku/OXBLZ5tvJhFzNp/OvDDYaygkuYgPd5vTIcgRJI4+TNsP5GWkPhoGoMC98w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7yZPJUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7yZPJUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6311EC433F1;
	Thu, 11 Apr 2024 10:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831444;
	bh=XAPZ2s5IlXHU9PFUrUUc8M/4Ir45YsErKDqWN3XuDx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7yZPJUUCDeF6jX7DBxDc2RB+m/U+vDAz9T3rt7RSlTq7h/0WqPC5NyYCr+X2Z435
	 qbuIof3npvcpEhqPRWMkwA2vExYdIaRcpqMSWCJjy7ExZU1hKF/0fV7iFbF8wu/WtJ
	 9VSO/3zxctfa9acBRyXWQ5PXlSfImr/NAQ3StLaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/294] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Thu, 11 Apr 2024 11:52:54 +0200
Message-ID: <20240411095435.977113083@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0be25e05c1a03..750f6007bbbb0 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2722,6 +2722,15 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
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



