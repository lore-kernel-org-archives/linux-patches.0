Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CF83911A2;
	Sat, 12 Sep 2026 19:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243113; cv=none; b=qIiWgLQoNZD2pEpxkvIqQTLjfC10ipMQkl8zQKWlMKIH1t7inueV+vxFRKgB+d+U3wBAmfQ0B/XEfQcYDcqOHyPqRWVp/ZbEbp53mVOeCGRUoH1F2A3xkX27jnmNrDa/5EDgIfBvq+wVG26Hza9eKl6gdMuONZ8lp8qJILa/IYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243113; c=relaxed/simple;
	bh=QgAkBzx+BWivloj1e+xwdH4TLVpiUm+NaxJCOJtnjk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtBsAwn3Bop7BCgWVN/xDpOl8t7ZUGDcqyaIGC/qwYVMbgFFD6OXoeT45HCtJKuv0pohATf3du4UCE5y6TYIYvf/U+O6LuIaQIt1G9NOAXLlpVqDiC4kO6JDWvgSVohHWazKSyDRr0BD2Fa/lTq+jv3IltzIfLk0G+804gtyZ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPrBWTyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPrBWTyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB9D1F000FF;
	Sat, 12 Sep 2026 19:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243112;
	bh=KrA9+J3XoKnEU1FDEB5n6m1V8G/qRroO+Y3AI9LT6JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPrBWTyGdIvbyTZNppHvuDRBwyKP6L/pDh2v61Yrf4TfL16TeKCakg3P5t/B6ThVT
	 p9TzvskbwIuuBnTAZQmmQW17e0MA0Jn4gzqK1JcMlMVHdWcvnmuvs+ul6h9H8octn0
	 PSPo/351IZdFOGNSxti5ExXOIUNNjq/24PtUreCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 640/798] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Sat, 12 Sep 2026 09:04:28 +0200
Message-ID: <20260912065531.787350018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Rangankar <mrangankar@marvell.com>

[ Upstream commit 5cbc49d5c4cd20c18041e86958103045216d2190 ]

qla2x00_sysfs_read_vpd() called ha->isp_ops->read_optrom() a second time
after releasing optrom_mutex. The repeated read is redundant and, unlike
the first, runs without optrom_mutex held, exposing flash access to
concurrent optrom operations. Drop the duplicate call.

Fixes: 5fa8774c7f38 ("scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-7-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ef4bd0ec21d8f..d697f532e8dfd 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 	mutex_unlock(&ha->optrom_mutex);
 
-	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 skip:
 	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
-- 
2.53.0



