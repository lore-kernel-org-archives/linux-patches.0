Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9F319DF71;
	Tue, 16 Jul 2024 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144538; cv=none; b=lTiokKmXK2bCrEQLmnC3X5WywhUR4gkbeepyyv+wyvYTEthfid3Jsbl71JeslpLkNSUaMhGN+8WtucFB9oI6G3DHn7+r/IKjbM3GrQzG2iWV9ENMAqmhoo8eH/OdqjtMcyV23gx0lHwFvVbh8Lm9xBOrdvRRJQ24DwPod/tfKyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144538; c=relaxed/simple;
	bh=XuiFWNOeK1+mAEQFsFneCQVftlt+ubuBfghjn0jChv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4nXddiG7Y69nbMhvmseubgIpencZZy+vwuLj3hdR8Jst/o3AAHa+f+cRN0apiT8fw6BLeldWjP1sX291IG2Wy2UQzqxqwl9NCP+yWu/vhXCzye0fTCszdK2jj91ZBGAWhDukjlF87AErhYg+JxOIbT7CCN0pWaHQvaU137g13o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To1jhCQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To1jhCQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C642AC116B1;
	Tue, 16 Jul 2024 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144538;
	bh=XuiFWNOeK1+mAEQFsFneCQVftlt+ubuBfghjn0jChv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To1jhCQHDO+D19GE3L8PFQ0JrlnunZB8dFpGhCgXUSgvI40m0a48x3MTZWeO2jjqS
	 FLm37htxTSFpCvjZHBTcQDpWagzUX9d+6/vo5ps8lKTbpAEDFOVvqvVqvegq0ut1mD
	 RpV/y6OQVj/XXmvs7WckgLjcFbgm+TkLLz3Ldlw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/108] s390/pkey: Wipe sensitive data on failure
Date: Tue, 16 Jul 2024 17:30:41 +0200
Message-ID: <20240716152747.005044818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

[ Upstream commit 1d8c270de5eb74245d72325d285894a577a945d9 ]

Wipe sensitive data from stack also if the copy_to_user() fails.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 69882ff4db107..362c97d9bd5b1 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1155,7 +1155,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (rc)
 			break;
 		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
-			return -EFAULT;
+			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
 		break;
 	}
@@ -1187,7 +1187,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (rc)
 			break;
 		if (copy_to_user(ucp, &kcp, sizeof(kcp)))
-			return -EFAULT;
+			rc = -EFAULT;
 		memzero_explicit(&kcp, sizeof(kcp));
 		break;
 	}
-- 
2.43.0



