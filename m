Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7AC41612A;
	Sat, 12 Sep 2026 08:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202299; cv=none; b=K6Zb98TCRTxrlXli25yHdkq+0FGS1RswYqao9RBT+SJdrlvQfeUhvDHkdX6I4+lYGd46OOtcpzsxA5LinwzYf1+arUeZ3s+b9rxAVOvLuJIzfI2FQClUWtVG3mZu12yYXwlLECPvt8LfHW59kWPX2sHKvFfkpXrNEmswLhxD8Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202299; c=relaxed/simple;
	bh=U4joJ/j8FE3uIIAtZgo2w+9OPVzba4e9yKwiAoV+f0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNU8N8WD7ACb7BP9w3m5Ej+4cRPnHS6KUW6MVR8EHZc+3smcCBpjJafgGDJhA7GQHLSVlISPayiUdO5ZgV0mG7t8yt7A70KPp4pg/O8b0ZkAidKsZ1CD44Mu0Hxo/2cI+2w+CLR6z6uKuo+3I9EBuGL8Accq5ELfmpjJDJL98gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iO3E75vy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iO3E75vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5991F000FF;
	Sat, 12 Sep 2026 08:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202297;
	bh=LUM1qu9xwaQtqHIhXVm6znbzz3xR9pVdDJgviww2dJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iO3E75vy93OR1rT6iOENZfUhvPlm3BhOIW9+uqIHTcCi7qMW0B8izAJgB6y1V9Qr1
	 QIUHBBsrMSoutiDeAdZptKrt4ZL+Cly5NcBFf8JFOGo7VkyDStP3YBKahbawuCfcWU
	 kBcwvLqj80tGVd9FgFcFaMM37cdOLwrOtnKPXd/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1173/1815] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Sat, 12 Sep 2026 08:48:43 +0200
Message-ID: <20260912065716.553814469@linuxfoundation.org>
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
index 14c3efd0e2109..b3b7cdf0cfa90 100644
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



