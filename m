Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D2F3B2FC2;
	Thu, 17 Sep 2026 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665407; cv=none; b=KP5vjY1weN0NKqgFKgaBaYL8tvkx9YJa2eS7829G/x1ilIyjVG7Iu9TcJNW78Mu2d6/b0adxMXKoyBWm5KA6AKUrCAK5fIWLCulNHZwrBnJ52s+0/bQ9BtZjyqgKDJTVaDr5dcLAgyMEcS6E7y0VAiXKo94qSEY2z16EjX6hQ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665407; c=relaxed/simple;
	bh=PuZNyxLuxoHB7kwqZcg/9v8kifsiEBoYGfEAYgpykdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/oWEgNhRLa1l4u1e0gMvNn0ZRitBciuYcTI9g44UK6G78tc1iD3BqsJoR6CTcHg17my0lDDdg0r4IL/Oyao3zP+trrmfb20sX+eFh2gwMPmpSbC4ZQGlWmIoiA08adT0GbiRp5TRkJVrJqxaf8FytdVw88P9egRutGZnL2pl74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEUtpsim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEUtpsim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F23D1F000FF;
	Thu, 17 Sep 2026 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665406;
	bh=YRN6OBJo+e9OM996zwK5Za1iK0KpuZa24ZpcWQEjS+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEUtpsimisySCdE8MmViyLvW4L8IQCbYsvGwtoNk02yAjQqpKQgbxI8Qv9jW35Xo+
	 0lE+niKEJ98IBnE1dzG6SKJoQJW50wt0OHOoq8qhLHmnqRbolWL1kuvvh+cMpH2llM
	 dVw/2+DzlNp+AEubDlIKUgNR5L/u5Z6BAzb6gd5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0655/1250] s390/diag324: Preserve -EBUSY return code
Date: Thu, 17 Sep 2026 16:07:30 +0100
Message-ID: <20260917151609.647930998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



