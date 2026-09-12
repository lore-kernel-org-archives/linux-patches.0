Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0265E340A57;
	Sat, 12 Sep 2026 07:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199870; cv=none; b=tBEGAxy4NaxPum/djS3MjYtZ3+/DfgQBAxsrOmyHn19fAcOlYDNX9yhLiZdb+uo8LSv3j+kWFx9Y4P9sO36PwALC0UTuv2/rtPkgiuobr7leMXnn8QdMKYr/STpL6HwVV+vY+SoKV/0TweS4KkPg8MwkeWOi7p1UopV0//6wEt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199870; c=relaxed/simple;
	bh=oWf3JQ3cVR/wK8cEtdzgkfbIYPq6AJSt7r85H0gliH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrE8Nsg3i9m6TxzLXrRXFYpFjxYF9NdSDyuZA1UHRcNjEdmzqcUTW+hQTaeIhi4aJDDxnIzy8paQSTS/n7zIUX4KoWTyA/7Yxj5bU4fIQ8sV87rAsZ7iNnsaO8a7eluPTrgO+/KzEewtdRmvtnmPxqR8e02N3I+WCQWhQgisbug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNxc7ERn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNxc7ERn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A872B1F000FF;
	Sat, 12 Sep 2026 07:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199868;
	bh=qvojUFf1zqspHH8LEXTE4U+iPjoWTh2/7LZvfLXpUOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNxc7ERnhaWOThKJHgqkAnSstblC8i9TR6MBudp3OhxGMScYXApSV/QCjGA8NXZ48
	 YcclbIbecw6UThqGrY5bay8CxYhTfjrvo6Tl2qemIcS4iBpUDeOKk6uSpI8rn/4l3P
	 Srgr0LTDQIxD4kV0AuNp6iW1HvLNHxNFdWH355/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0672/1815] scsi: ufs: debugfs: Reserve space for a string terminator
Date: Sat, 12 Sep 2026 08:40:22 +0200
Message-ID: <20260912065704.663241439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index e3dd81d6fe828..be527209540d7 100644
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



