Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E44BEE5C;
	Sat, 12 Sep 2026 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223914; cv=none; b=hNX2E63PyQDNW8P/ZTi1uPDr42H9PMCJV+KTJn7PvmawegFgbcNu+pO8byJKagNqB+TJPB6mG3Xnp+Vj0sW4QP8UD4hlp1EBrLzvuX/fS+szM7v9CcQ4/VPh5CPYqohALqxBim7eQ026tiQ4mp+BDB3o2g3tJVKOMAAZUN9PXTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223914; c=relaxed/simple;
	bh=Bx0DxaTs+KEqEh4KP+5zIZ4Y4i7av/dnLWKejABQHE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiNQ6+4fT2NZRs9BIA8BEm2+aO/jHqVtGoPnbUqiKVvmNUw98dLLxrbpY+1ji8HOB1I3qQMXYU+C2Ys+4TJ1YZYVHLDVsGLIAZ+c+EBG00u3ZQX6BMNKa5xzZor4zhfw50+wdxXTTCBTrC1dt6RGc/epFA+uY9Ks1z6LIIa9AUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlJeVQnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlJeVQnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA7E1F000FF;
	Sat, 12 Sep 2026 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223913;
	bh=Ye2xdB8e7/8y1KK9PTXLgv35Tbp74mMRAd4+pmW6CAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlJeVQnVP9GwO4IE5xpzx2T61UGqh9RuI1P6qRd2UQyrjxH5WjgLz0VPzOp0ptPhP
	 KPCHfm/T4Gaz8FLGz7j+a/CXFMBoo0mKiUNS3vBPp+zULxjljycppwIcL37AWmmpd3
	 pNj87XkMNrYsJIQEd29hz9y7utWrnvB2qHZy0qMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0886/1424] scsi: ufs: debugfs: Reserve space for a string terminator
Date: Sat, 12 Sep 2026 08:55:18 +0200
Message-ID: <20260912065627.168446363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



