Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489C712BF3D;
	Tue, 14 May 2024 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682489; cv=none; b=tegkqXc76Uu7k2z6M417oqfa49fsERMHBEju+hXQP8kjlDh4j7XVhZR1iKeRnIuTru+5b1eb3Cl/M1z/jdZsja7U56UXHGqe/XU9qmxshPujkoOyyKNlChEt8tw8EojOPmpFJBb1EGHU+cF04yWOvYDZcehBp2zYMKNpMXRdLn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682489; c=relaxed/simple;
	bh=FaPhXuiryfxEM7XF8vFKsJucv4YK9Zr6iMljdJ+vnhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUq0Y1j+bmq1+taB69vF6tMhoSaxfGTy5KTlVBAfaUb5zMkwyF05swuZsGiG35o7vdFI1efzuMtiGTMiyyYWGBoAm/USpwYkg2IKZkWFtOC9a3u1aXVEtrkdUQrHy4GJh7v84J8dbMDISjpgdMXEEjLhVSBEHOqu+Xq1AZX0Nn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEa951Gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEa951Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5E6C2BD10;
	Tue, 14 May 2024 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682489;
	bh=FaPhXuiryfxEM7XF8vFKsJucv4YK9Zr6iMljdJ+vnhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEa951Gn1CcvUPMwGkSXW9prty8nmmmE8shwQozQrLDwQWOxNO+XjZlBbok5+klbh
	 XcYXXqR9MS88EWx5rb2uLRpQW0k4EuORkm3JnYHOB/vm93DLjnhqPvk7NCAoX/PS0r
	 Zy3UaQLVtZhoyPrbIobmENFNhZUshtMaSYqfimqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 069/336] s390/cio: Ensure the copied buf is NUL terminated
Date: Tue, 14 May 2024 12:14:33 +0200
Message-ID: <20240514101041.210610848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit da7c622cddd4fe36be69ca61e8c42e43cde94784 ]

Currently, we allocate a lbuf-sized kernel buffer and copy lbuf from
userspace to that buffer. Later, we use scanf on this buffer but we don't
ensure that the string is terminated inside the buffer, this can lead to
OOB read when using scanf. Fix this issue by using memdup_user_nul instead.

Fixes: a4f17cc72671 ("s390/cio: add CRW inject functionality")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-5-f1f1b53a10f4@gmail.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/cio_inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/cio_inject.c b/drivers/s390/cio/cio_inject.c
index 8613fa937237b..a2e771ebae8eb 100644
--- a/drivers/s390/cio/cio_inject.c
+++ b/drivers/s390/cio/cio_inject.c
@@ -95,7 +95,7 @@ static ssize_t crw_inject_write(struct file *file, const char __user *buf,
 		return -EINVAL;
 	}
 
-	buffer = vmemdup_user(buf, lbuf);
+	buffer = memdup_user_nul(buf, lbuf);
 	if (IS_ERR(buffer))
 		return -ENOMEM;
 
-- 
2.43.0



