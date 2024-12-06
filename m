Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB432C8B;
	Fri,  6 Dec 2024 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496546; cv=none; b=WcLo7gJQRi4nVhYA06pOHQhsU5JpdtUk45yjmPnGCFzFFRY3DTSSUf5E6TikUS/Uqf6Lj4K11jSHdtoeZr42qNCfM+i8HsK1bF66UVcjxE+SPJZ/gjn4dfmnj/VoL8sRIfnmm+161YwnS3Jaw+ad+dqFexmJ1RR2Ha6+RmRzTkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496546; c=relaxed/simple;
	bh=bXupim2NDRNC98WcnaPOlOc8mEHAiSe0w3rH8J0zMbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B84w1n6StDden/DkPEw2f4mLvW6urdHrmvjRn/GWMNnaxPK9TKG/PEUsKHCsaFchdfNvckAc+jM0ExNrEPSNZlaJ+AtuiVgMwNZGOqu+2ZhD9NTDWPnwZPwgK/ehTDOubI+hUH+8M2ksvN0dk89g3+4+RMBEVSeU66uHRjgaI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6eATkxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6eATkxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24945C4CEE2;
	Fri,  6 Dec 2024 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496546;
	bh=bXupim2NDRNC98WcnaPOlOc8mEHAiSe0w3rH8J0zMbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6eATkxEDjtHFHzHzfFod5yMf7JfLsldwBGX/Gs3DslgyUSgJ8f8TzDBWDaqXbPbh
	 NTP6FdankUSNrTVl1eMwfgkJSNb2/lwjgZykzDrwM7yK5oeid5XEyWCW8NYy07wwmR
	 8KEJUyQMgjKnOdDErpKc/lM/UcfVmEbTiXKJ/nh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/676] s390/pkey: Wipe copies of clear-key structures on failure
Date: Fri,  6 Dec 2024 15:27:34 +0100
Message-ID: <20241206143654.727190851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Resolve minor conflicts to fix CVE-2024-42156 ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index d2ffdf2491da0..70fcb5c40cfe3 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1366,9 +1366,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = cca_clr2seckey(kcs.cardnr, kcs.domain, kcs.keytype,
 				    kcs.clrkey.clrkey, kcs.seckey.seckey);
 		DEBUG_DBG("%s cca_clr2seckey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
+		if (!rc && copy_to_user(ucs, &kcs, sizeof(kcs)))
 			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
 		break;
@@ -1401,9 +1399,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 				      kcp.protkey.protkey,
 				      &kcp.protkey.len, &kcp.protkey.type);
 		DEBUG_DBG("%s pkey_clr2protkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ucp, &kcp, sizeof(kcp)))
+		if (!rc && copy_to_user(ucp, &kcp, sizeof(kcp)))
 			rc = -EFAULT;
 		memzero_explicit(&kcp, sizeof(kcp));
 		break;
@@ -1555,11 +1551,14 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
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
@@ -1569,15 +1568,18 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
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



