Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88F1B85EC;
	Wed, 19 Feb 2025 09:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956517; cv=none; b=ZKvxah06HBBlSYltG7X4kWIer8k40o1v5xibX+tQk9Oj9tFTRnkIcYceYe0C1ASYk+2LmsGt1Zkg/Y+uT4S+ol3FK1pe/hJq2TDaMrdkK9eCusXgv7k3vD+dUhKQjUrhVxX1Y6kf8oMAFCFMOahzeIao+P5pv0JscMbfnnyZ8HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956517; c=relaxed/simple;
	bh=2Nm/2cQnTXUkEUC4sRM1WM1lc9CcQ3oteTFYojS8mY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYxzPZGHW46uCVNWAJJ5JSeJ1kJWhqr33GXR+LWiRXAv2ov3EJUW5XW8rhTNR2XdtJhGKLq+mdhZRCtVlfP3JKeb3zwmI+SqLgLQb7rl8K2ArvoPKkYpWvyJTYHj6+wznsKX8fXyPMoQlzT2R5AVxX6Hc5iUyk7SCdR+QWegZi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aleNmLlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aleNmLlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A4CC4CEE9;
	Wed, 19 Feb 2025 09:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956517;
	bh=2Nm/2cQnTXUkEUC4sRM1WM1lc9CcQ3oteTFYojS8mY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aleNmLlgud0SwRD9NX6exkeT6KQBhilLXyFDWNLG4YC1ucQtS38N+6H7O4EY+IHrD
	 ijeLFq767fAT6s6HNpHwvd6eUR2afDnC1BU66mu1Yt42gJiueW0cPEelz9fW/NAyWI
	 hUMNXP9PJXgbphOnPQfAML3WVtmcxr138GjxtSoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/578] scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
Date: Wed, 19 Feb 2025 09:23:29 +0100
Message-ID: <20250219082701.121309133@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit fcf247deb3c3e1c6be5774e3fa03bbd018eff1a9 ]

We should remove the bsg device when bsg_setup_queue() fails to release the
resources.

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-2-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index b99e3f3dc4efd..87d89136cab90 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -219,6 +219,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.39.5



