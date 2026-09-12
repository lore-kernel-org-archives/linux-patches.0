Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9773B14D7;
	Sat, 12 Sep 2026 07:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196780; cv=none; b=D2Mp4hdbCzQJb4FYec/pnYjmVqw3nqI7qWR7i7T0Wv46JBqiCLjZqEzEMG3UiWplZMiNegq7eqe3BhmBN0C6g2DA+h7BjsNuw2HCZwni0bnCed5GyAu4XMn82NTlFxdU05eshhFayU4cLdDjRqgj+NSpK4l4aSdmWNWeRu/AjkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196780; c=relaxed/simple;
	bh=3o2ZyTgiGimoCl+UpF3qiD8G0GLCde/f5QC4npkS+6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiPWNY+MCpekM/OxC8YgZjCCSwuOPBd5j5FecDFZ+A9zKSJl3qQx6uVw5s3Xn48OTpizy8EjwoLRUnMJ70Dx+XcvgSbb2qOpcl0UM2xqS9CkXh/jC6D3oqkeR/+xLcwn38SQ+MySB9huHw5C8g2T8FoNfM9bXovTYiieMtVc2xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgPvEUQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgPvEUQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977AF1F00893;
	Sat, 12 Sep 2026 07:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196777;
	bh=xst0GKi5OFZ0wIgFe40RqGCBxSk7HnUn3rkiFxAolbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgPvEUQweiNkw0tWqpmipTSVGXKxym3Pdg6lIR2LkGQeIMSFBL4fQ0ef25EGGSOtM
	 UXjBVLIKweuVe2IuEZ46YchVTmDRxzh4ai0d4Z0njIkjwaaPwwFY6SuIihWKZaQYya
	 9BkdkMSPuBfgJGL5XVVqSZqIhPy0L9emn+Q8OQ7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumjin Im <imbumjin@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0034/1815] Smack: Fix error in capability bypass
Date: Sat, 12 Sep 2026 08:29:44 +0200
Message-ID: <20260912065649.816419886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit b2faddc13112489f8f11eb40b9456db8c1b58362 ]

A bug in smack_inode_xattr_skipcap() was introduced in the inode
capability handling. The strncmp guard at the top of the function
is coded backwards, resulting in consistently incorrect results.
Correct the check, and the code functions as it should. The error
manifests as requiring CAP_SYS_ADMIN as well as CAP_MAC_ADMIN to
change an inode's MAC attributes.

Fixes: 61df7b828204 ("lsm: fixup the inode xattr capability handling")
Reported-by: Bumjin Im <imbumjin@gmail.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index bbe6cd6b03f75..374873f2f4d9b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1312,7 +1312,7 @@ static int smack_inode_getattr(const struct path *path)
  */
 static int smack_inode_xattr_skipcap(const char *name)
 {
-	if (strncmp(name, XATTR_SMACK_SUFFIX, strlen(XATTR_SMACK_SUFFIX)))
+	if (strncmp(name, XATTR_SMACK_SUFFIX, strlen(XATTR_SMACK_SUFFIX)) == 0)
 		return 0;
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
-- 
2.53.0



