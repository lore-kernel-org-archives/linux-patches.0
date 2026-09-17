Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27FD59B688;
	Thu, 17 Sep 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659000; cv=none; b=t49Aew3U3GvaUsQdc1pMv2csUUoOYc7s14+H6QyLSQlmvAFQOR8yih4qkktndUCckxvH704TsILYWzkwXPYmwprEYvs1R7F38GeyuMKI4igJKEtYnpGT9B/6r/n5PCgHiPLz48tw/fmo3q8NpN8FaeMGPYmx5pa/4KuteCaq9ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659000; c=relaxed/simple;
	bh=Ly++MVPRA9BB02SqcOn1XMXtT6GNn7N9WoN+QGf+rLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msXlm2CAfjBYljZiCYDnCzjCu7v2hSYKLxxU8ndELLAh7VbvOwglQEOGRiCSHiS3UTw8x63emHE2Ekv5AylZFYF5IFVdkdPc+R+s5SbQogAaFQWHApST2cKWqRhJbBhSIgq6ulAvJ8/3ZG8Rp+pUdPSPqiADf6reCPfYwRWTnj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfsBtX4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfsBtX4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9A51F00893;
	Thu, 17 Sep 2026 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658980;
	bh=kBnrGyEjQD4U1YA3U1KqbOB3y7TWmncIIkI58hYrGxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfsBtX4yOaKGOnSn8dzmkGZDo5g7e9sQygDgDuChntGm7rl2RDNGAHdmrdOK2oQwt
	 VM3k/ckcm51KRmRZhGR8PodR6R3qM6Er6JmblaE7yk4iREbh9J5H0gdskLMqrV6QrY
	 OCSi2gmJDwsMKISOiOGhU2cNa+ohXLuYS6crJZ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 103/733] s390/diag324: Preserve -EBUSY return code
Date: Thu, 17 Sep 2026 16:06:51 +0100
Message-ID: <20260917151353.529555292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit 439077c39d8f7108aea4dd8d4d819b9b864fe84c ]

When diag324 reports -EBUSY, the error code is
overwritten by the result of copy_to_user() and put_user(). As a result,
the ioctl may incorrectly return success instead of -EBUSY.

Preserve the original diag324 return code and only return -EFAULT when
copying data to userspace fails.

Fixes: 90e6f191e1ee ("s390/diag324: Retrieve power readings via diag 0x324")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/diag/diag324.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/kernel/diag/diag324.c b/arch/s390/kernel/diag/diag324.c
index fe325c2a2d0dc..3eec0cc8fb9e0 100644
--- a/arch/s390/kernel/diag/diag324.c
+++ b/arch/s390/kernel/diag/diag324.c
@@ -182,8 +182,7 @@ long diag324_pibbuf(unsigned long arg)
 		goto out;
 	rc = copy_to_user((void __user *)address, data->pib, data->pib->len);
 	rc |= put_user(data->sequence, &udata->sequence);
-	if (rc)
-		rc = -EFAULT;
+	rc = rc ? -EFAULT : data->rc;
 out:
 	mutex_unlock(&pibmutex);
 	return rc;
-- 
2.53.0



