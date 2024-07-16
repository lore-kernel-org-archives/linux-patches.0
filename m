Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EC6B641;
	Tue, 16 Jul 2024 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144376; cv=none; b=EYJJF/4tDi6IS0YFckTxXlK9r709oW8pMnNiohNdnHjJ0avk5YpWyFufvDURg9eou6WZdaOVDo9fICacP7ByJISI79L5dmEdrWgm7BCtYTNhu3497+mJOH2f6f3/lewUJWELiID3Kzw4D1LbrD70ptVdfyODaEedKW71DpvGESs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144376; c=relaxed/simple;
	bh=liHz1PpUfh+t3WIqNIj5tT2tCJjCKMKxGVjni86b1ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri0sC+70Gyn4d6ikiEshKPmW9QnYhEcHIA7oQpRTEkBdHmlaJkcvqImQqAK85s72L0TtfnZNFGPtfAaqeYPAEe0CjfX7An6F4LnPspyy8pKG6NtqKoduEK+oe4WqprY7uSiD2Q11zm6oOWr6nNR1Qfz/vNTLxds9knxWHJT8TVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4g81QH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4g81QH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1C0C116B1;
	Tue, 16 Jul 2024 15:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144375;
	bh=liHz1PpUfh+t3WIqNIj5tT2tCJjCKMKxGVjni86b1ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4g81QH11kKBxTiq2RtKL6YBmR+W439Z+K99Ly3zZUROkc4ukT2hphqHjfGzy1pxH
	 056s/Me4KVa4cdZTtiSeTuV6ayoYEUR7HeiPa0DZsmpJKVUNCPX9Fq2aNcAl/yUrfv
	 W9tz7jz5FThC1sJmCPJkqa0mLGupmLcaDQ8E9Cz8=
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
Subject: [PATCH 5.4 21/78] s390/pkey: Wipe sensitive data on failure
Date: Tue, 16 Jul 2024 17:30:53 +0200
Message-ID: <20240716152741.452849453@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0658aa5030c6f..ca090fdec5f2d 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -784,7 +784,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (rc)
 			break;
 		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
-			return -EFAULT;
+			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
 		break;
 	}
@@ -816,7 +816,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
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



