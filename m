Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEE017CA12;
	Mon, 10 Mar 2025 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629115; cv=none; b=l1F+igNPZ/wcfozscqiQszdzJxMpeXThaQbwu7Nw1RCmE1HjUp9My3etgIIY/wfFSjAV0ZKOf68GdKcINJKV8OoOPsUT1a/+e4AcQWlBB/PbzcbehL9pP8dpPNE0QCHcnIEsptu7Xf84AoiJZ/x/e5hrgUZbGXyLg3W1mMtO8+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629115; c=relaxed/simple;
	bh=LccU9hKc2md67CzNnCjkcyMMNepWTvge1RIOI9pJv1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRv+/jlZows2j35Ft5du8EV5iyVq60Ecol06uZV/pumjnq+xTaCvVpQviHOp79zodf2x06hKMu8VQ1DjI1SK7XhGV1NCXraqqcknxIBA+h9agB5/T5iUa+bGXcG9V11lbQjeu5r3M6e9pFFLVPy0YbWqBw2xavwo9+05GOcr0NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFEzyk8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFEzyk8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A086FC4CEE5;
	Mon, 10 Mar 2025 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629115;
	bh=LccU9hKc2md67CzNnCjkcyMMNepWTvge1RIOI9pJv1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFEzyk8vEefp5MYYjepy37jgn1snL35CkxuvWm8yrWvjhHsGvNcbgj4HTKrUWaU69
	 +QQQSVuCL6OfD/845EGDcdkCmabC47Or1+9C6GssgOYUjeB77i5DsIxfKugwAQrgYo
	 7yI4sDOBuL47zT7xzFD61pmrdUYun6VeEo9GG7wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/620] scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
Date: Mon, 10 Mar 2025 17:59:57 +0100
Message-ID: <20250310170551.563354617@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/ufs/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 39bf204c6ec3e..16e8ddcf22fe4 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -213,6 +213,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.39.5



