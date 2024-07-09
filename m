Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D14156238;
	Tue,  9 Jul 2024 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524113; cv=none; b=RoLJ/QpRcXKvy+1+QrBsFJHn51BpPVm45xfjNJKTZvv59DM4lHDt4520J33lsJv0uaJXrg6RFLUwFpue3xBH1U1ngR2GK8O7n0oBNV7AZ6/Hblzr+P0+1Uv+W0OjxYBvR3z8tZrKdnX/M4LODWIp0blMCyx22Vd6N3/34+ABECs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524113; c=relaxed/simple;
	bh=8eJ8gO5zDpl1+w4KgSOclhta6lE9P3b2VZELe4Yjtyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/5udmQFY8HBowYYmwD2JSwOj4zb9w8YAnUaCiPo1b3v6mBdzAzhE5qbWw7RS4aWpgrkpMA7T5v3y1fR8keO9OHGiZ1qm8yo3Q9fd8bs59NdHOmX/gYTf8d9tij3LmnG4/bYiobNEicXCeLytum4jfeX11M8TsLAv7L/28UIClI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BysIXWSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BysIXWSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1960C3277B;
	Tue,  9 Jul 2024 11:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524113;
	bh=8eJ8gO5zDpl1+w4KgSOclhta6lE9P3b2VZELe4Yjtyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BysIXWSQBAq8H3YeT2mutocrw0dI66cL/wsL/hBl+8lOPvwyeuCBNvhgM1t2Vud2F
	 kzKnUbclLo7RYaQOw8Xm1lq6mBxC5aqxfnKHRGQvUsEbkVgNqds1JAf49R2RMbzq56
	 dOM+0qcPoRtc4ihax6fEOC7I0RVpd+6H3Fx1Ht10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 075/197] s390/pkey: Wipe copies of clear-key structures on failure
Date: Tue,  9 Jul 2024 13:08:49 +0200
Message-ID: <20240709110711.872249049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Dengler <dengler@linux.ibm.com>

[ Upstream commit d65d76a44ffe74c73298ada25b0f578680576073 ]

Wipe all sensitive data from stack for all IOCTLs, which convert a
clear-key into a protected- or secure-key.

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 179287157c2fe..1aa78a74fbade 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1374,9 +1374,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = cca_clr2seckey(kcs.cardnr, kcs.domain, kcs.keytype,
 				    kcs.clrkey.clrkey, kcs.seckey.seckey);
 		pr_debug("%s cca_clr2seckey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
+		if (!rc && copy_to_user(ucs, &kcs, sizeof(kcs)))
 			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
 		break;
@@ -1409,9 +1407,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 				      kcp.protkey.protkey,
 				      &kcp.protkey.len, &kcp.protkey.type);
 		pr_debug("%s pkey_clr2protkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ucp, &kcp, sizeof(kcp)))
+		if (!rc && copy_to_user(ucp, &kcp, sizeof(kcp)))
 			rc = -EFAULT;
 		memzero_explicit(&kcp, sizeof(kcp));
 		break;
@@ -1562,11 +1558,14 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (copy_from_user(&kcs, ucs, sizeof(kcs)))
 			return -EFAULT;
 		apqns = _copy_apqns_from_user(kcs.apqns, kcs.apqn_entries);
-		if (IS_ERR(apqns))
+		if (IS_ERR(apqns)) {
+			memzero_explicit(&kcs, sizeof(kcs));
 			return PTR_ERR(apqns);
+		}
 		kkey = kzalloc(klen, GFP_KERNEL);
 		if (!kkey) {
 			kfree(apqns);
+			memzero_explicit(&kcs, sizeof(kcs));
 			return -ENOMEM;
 		}
 		rc = pkey_clr2seckey2(apqns, kcs.apqn_entries,
@@ -1576,15 +1575,18 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		kfree(apqns);
 		if (rc) {
 			kfree(kkey);
+			memzero_explicit(&kcs, sizeof(kcs));
 			break;
 		}
 		if (kcs.key) {
 			if (kcs.keylen < klen) {
 				kfree(kkey);
+				memzero_explicit(&kcs, sizeof(kcs));
 				return -EINVAL;
 			}
 			if (copy_to_user(kcs.key, kkey, klen)) {
 				kfree(kkey);
+				memzero_explicit(&kcs, sizeof(kcs));
 				return -EFAULT;
 			}
 		}
-- 
2.43.0



