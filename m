Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF5B13DDDD;
	Thu, 11 Apr 2024 09:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829511; cv=none; b=In0juru71AdUgjdZhKLcPEW2GqEUfoUuNbl/Z2d6YFgPrDCqtheU4aS9Sd1pMhoA5TWmT5VJcr0D9OIqLqbnmBYpcyEWpbahZ8IfbNjh9qcxrvCRGjKgeHX0MYxMzB6ajDrLMZ+IpTE0Q3N9UwK78bCFDpZLFJZaOcENYCgX8Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829511; c=relaxed/simple;
	bh=tSM6KvUdogG9SEdJA3o3LWBs4JkWb3q2Fhtw1eRxRIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BICDhnfdRUxR04S4sgd9M2QTri5wp8NWTAPYTCT6P6VkmijmJeDjc7MRIe7HJ8DS88DNMDiuNKyDuxpiyMKnBJxThYyaDG2QJzTiDXWb7pUxcyTxTJytwUtoBc0xXzl9TFZP5htpGygJd+54KYDVF4+DhJivq86AH7QpFXxxfBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRDi7JQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRDi7JQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350D2C433F1;
	Thu, 11 Apr 2024 09:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829510;
	bh=tSM6KvUdogG9SEdJA3o3LWBs4JkWb3q2Fhtw1eRxRIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRDi7JQWYzxuGrN4obfX5AzdEIhBObrwWC0uvLMQ8XeNG9H252nl5h8W9340Mk/pp
	 1qsQ+m9wQSi0cBtXwfGB+HN3dpX0QdpLw1T5mQSSQ39hOfSa+mcPfUqCngr5R4IuTj
	 05B0j78WeH0GQXwXgogQgOOlFGSCnS29/wO9ujRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/175] smack: Handle SMACK64TRANSMUTE in smack_inode_setsecurity()
Date: Thu, 11 Apr 2024 11:53:55 +0200
Message-ID: <20240411095419.913953001@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2f2dc49f53dff..d9bff4ba7f2e8 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2802,6 +2802,15 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
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



