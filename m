Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4630C60F;
	Sat, 12 Sep 2026 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230095; cv=none; b=E9cKo9qdczyMywGjd/KLZ3c9INAl8Hq+2ajAPYYWPbigmZT3Rsu9IEntd+uQgBMx0sxxfPfrJpcvGoe0IIj9eqHS1T1Y154nK8kh+rVIw+T47neIdok9RTGmJheFy3CFNiPczG/bf8DpKlk3aMEu4kK17N8qRYMsbd36gAVBLN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230095; c=relaxed/simple;
	bh=s7MpjHCHvEnbN8me3Fq4S0u9gTP30CUi9H9iXdQ8RAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdYvbjtII3x0BpzlZZQWfXj3GQ2l+S7bhLLN2ghMmiYwaZGKRUrhmbfEkvDXcB3NLi+I5n9xudvL6aTKnpmDwuPYQPkEXQAbVHbAUWAZbVNWxr+vHr4pTjeYdFCZY5VJ+AYn6Vpe59NLOZuPnWcRPEsHELCwPoallB7YZvhJdWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj4VBO1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj4VBO1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF3C1F000FF;
	Sat, 12 Sep 2026 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230094;
	bh=2hs7grVHDzesgWqB4PWJclfVAaHPWqRZ41WbZxRIGKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vj4VBO1RcDEyKVr1Osbr6TBpyZ+bADao1ZAXWVEuT2qRqxA64TyO2vzVqhRHk7VE1
	 jGwNUTRLRS8qxmYkQ5iUbFbk01G3SOmZ+MWwq+jusZqDhq0CCmnWd/+1P+OT5qUnp4
	 MWBIXj7CL2C9JRZ4aFBBmmIbJKnC+8bIHgt5UEow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0723/1191] scsi: ufs: debugfs: Reserve space for a string terminator
Date: Sat, 12 Sep 2026 08:57:31 +0200
Message-ID: <20260912065604.519058979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit abd26e6b53c4169122d61fdd4cabe09bdd916aac ]

ufs_saved_err_write() copies user input into a zero-initialized stack
buffer and passes it to kstrtoint(). A write that fills the entire buffer
overwrites its only terminator.

Reject an input whose length leaves no room for the trailing NUL.

Fixes: 7340faae9474 ("scsi: ufs: core: Add debugfs attributes for triggering the UFS EH")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260717153914.26321-7-liqiang01@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index e3baed6c70bd9..6dece24baad15 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -165,7 +165,7 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
 	char val_str[16] = { };
 	int val, ret;
 
-	if (count > sizeof(val_str))
+	if (count >= sizeof(val_str))
 		return -EINVAL;
 	if (copy_from_user(val_str, buf, count))
 		return -EFAULT;
-- 
2.53.0



