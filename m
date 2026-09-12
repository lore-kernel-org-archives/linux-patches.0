Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FA53F788A;
	Sat, 12 Sep 2026 11:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214344; cv=none; b=WGO0bENOSWjaYghTHjk91UypuhNU0joMR0VX56st/lgY4tny8xQ0foIbwZ8ni+m3QPDNjmNw4mr0iOdK9l/RKSGs+7Pz/TjVn3bbWrEdiPnYQGae+TI0sfcks/6n3mE1PPbdIPgLE1tjKh5AxvDQle6o2PEAzCyACtDU8xi4dk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214344; c=relaxed/simple;
	bh=yget+FzVL+RtoDAxGLtHaHOUWdXFpUmk4awyO+oehl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFZf/DOEMiUAu5AVeglBb6ITCo3bvKtLDOsoSBoNXQIOrPkwa5c6b0xA2MA0wcdsCKKybQfms01dxqTEjnE1PNbD6dRfwWBOlK6QRtppRcd+Prhjh7P6Rynlk/1MAmPMQh7ChJV/eVDKYtJ0y+4Wc2Z27fl4iwjETky4pptXZ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuPJkQqM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuPJkQqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351121F000FF;
	Sat, 12 Sep 2026 11:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214343;
	bh=Ss0KGOKEFmnP8SKf01BIRTZ5si2ZL+OzyfKjyT0s03k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuPJkQqM7lSHOV7f9ex/X6mgKm8YSzjgn+2XJvaVeWGYC6ZvuXzi2r/UQto6ZhfEq
	 U4fB3D2QNpem33hRydpD5rm+VMaeFy0Bmt7Cft1ds55oKrWaM559l9vmJu7QxRg7tP
	 LxwH9VoxqthGGTU8GymsG0PzGKdsGOBydLasCUeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumjin Im <imbumjin@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0307/1376] Smack: Fix error in capability bypass
Date: Sat, 12 Sep 2026 08:45:33 +0200
Message-ID: <20260912065614.393045259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7a9b20a576c62..cc1f0014a10f1 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1329,7 +1329,7 @@ static int smack_inode_getattr(const struct path *path)
  */
 static int smack_inode_xattr_skipcap(const char *name)
 {
-	if (strncmp(name, XATTR_SMACK_SUFFIX, strlen(XATTR_SMACK_SUFFIX)))
+	if (strncmp(name, XATTR_SMACK_SUFFIX, strlen(XATTR_SMACK_SUFFIX)) == 0)
 		return 0;
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
-- 
2.53.0



