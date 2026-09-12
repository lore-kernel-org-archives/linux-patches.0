Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37A83542F8;
	Sat, 12 Sep 2026 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205965; cv=none; b=MppBYqGmZYBB3kMci65dOMSLS7pF/tHXojt5aun2fqNb/cvvPVvbD0DtQjjpSmJWzB3cJ6o7rxH2AP2ijLSE+/1lx4eWSOP/Iv0WSEP/THQcOu+E7+LtneuH5xb6fAriYs+XBCH0QHGSs8gkCkruEWVR0fwJ0Fb4MXAJvHfDvlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205965; c=relaxed/simple;
	bh=03uIbu43Nwnjn829Vt4szHaNi3HYGL0VEVpoGN/litk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWlVlo5XTiPJXwsEcrETLVAyQHYkvDLC4+OIBCetcdAbEDz1Wj81IRH/dpRvYqoMmUtdZP+FnsoA5q0ujxojsOjO2nfcGPZhPL5rw8PbTJgsXVqHh3hzJmoArYGb2mdFDc3N5ckM6XO8aqpH08DhnRwjOxqsOGitbrtO/5oJVRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycQVf37S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycQVf37S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9EC1F000FF;
	Sat, 12 Sep 2026 09:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205964;
	bh=6GDfZv+OTwBJVKRyToS1jjEgx+hs2wBhSamv04HQoro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycQVf37SfBTAmVouEociL+kLcNI9nKsAGUlh9adAxmUDpGtdYuF2YFw0Ou5Dp8qk1
	 83AOZlu/VXA3Q3VFoO9Uk4LeorNePZAo8WdYTGMpVPzO4lhe0tZA36nUz8qUpeQLDi
	 k0uds42l3yMJYdYbN+xE1JrIAz8N7fsWokmWcLKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumjin Im <imbumjin@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0092/1518] Smack: Fix error in capability bypass
Date: Sat, 12 Sep 2026 08:37:41 +0200
Message-ID: <20260912065625.554950360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0d984fdf211a6..8a53605546c4a 100644
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



