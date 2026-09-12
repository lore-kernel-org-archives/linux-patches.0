Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2EA455626;
	Sat, 12 Sep 2026 12:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216240; cv=none; b=mmv4FxDC6SAIQSrVuGtC08Ph1jhy1nT16Bk0rDVIfANsCiGLawKl95Zhl4ZshRHYAgUQdlaOOjRXC8sxaIQc63psAgALPnFMOqrO5NAu/ZrntlYGSvvxuBzLtzxAdYJIqH2/G6yfBDOQqW23dL6jBV0VTmQPxgE9yEhhph1SwI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216240; c=relaxed/simple;
	bh=Kufis48fXg9a6qMeWkvoYL7HsvOAgDlDP7aDvvRN2Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRfjqdZfwxRqCdzROb1y3Ueb8n/yHUXkBFrj0Hps+pcJkoSbk76wKyO2gjOjCaFd74X18M2L1Px5fWj/LrTOFb3HGil3qJ906yfudD0J6ryKby44k7LG5gj5w2ShzyasihrRwe3OLDA2d8wqh7yvVBg9sYc1vinI+OgowtS1Y6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJzHaB/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJzHaB/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE711F000FF;
	Sat, 12 Sep 2026 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216238;
	bh=5AegeRE4gyMgLHOa9CJ9Ju45n407c0PeWWJGxmKQIZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJzHaB/hdk+tfOP7N09e0h1M7z8bzT2oPJYxfO7wUsgrv4s1O74KRLxSIYsyG870n
	 ZFITkTR6KYepVtY5fCW7CDaNnLz4zJfmT9vdYEiRT/+pB+tMkK/U/K6qJ2v1quSstS
	 x9I7QnvywmOqarQkOz5k2WsNdHWaHxOQRX5mLLs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0694/1376] scsi: ufs: debugfs: Reserve space for a string terminator
Date: Sat, 12 Sep 2026 08:52:00 +0200
Message-ID: <20260912065623.012620920@linuxfoundation.org>
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



