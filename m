Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845B836B924;
	Sat, 12 Sep 2026 12:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217459; cv=none; b=PkXMwo0Opa+R70mR1h2XCcJaOskpJWVRw7ysTayury+0yiPK9Af39JoZNdhzF9+GwFlxNn0HOivSh6F5D72YzgseCcDUgzRBLv7r1lbrbNirNpDFwVjxT891Nb3G93V7PuNP2vHAhOj/dtaw+qx3y9AMWY6hBObhgAF8Y16OLOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217459; c=relaxed/simple;
	bh=bqfurgw+7o0lcqe77BKu6wXklwFdPPqU0ydvuJOUhys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3st3x2zPDL/epvJKaRCOnrmViV31qw1jUI/+w2pxMN+GawykCZduO78ICSKe5uW3oiKFn70Cdl/h0ZKQDS1CmoKcAgvKyhiMqKl4D5LgxsCmPTcXr2C8tbSR8kM5fwjamnoybTsnABeI8b9uc7Db9XeYEoHueZ+9Bq7VNYW5Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmQJVayB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmQJVayB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3953B1F000FF;
	Sat, 12 Sep 2026 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217458;
	bh=xA3oFPI8dwRKTi6eiPjvyRVkL/mlzx0M18x3OFYd0Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmQJVayBn9GQfgpS0j/eUDIGLMMB9NHwPkdAcjw6X3nRnk1zO34VqtyyilvSjmB8j
	 OfQ3LapyEFRpgYojr60Fbh3hasWumOsD63B3kZJzJrcybwMWGHIQJxzdvvCeQNccx0
	 S/q3sS+Z4qmxa13QzivgBc7ZCLznIDS+pDQGY3Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0945/1376] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Sat, 12 Sep 2026 08:56:11 +0200
Message-ID: <20260912065628.621907657@linuxfoundation.org>
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
index a8b62bf31be20..a5c031f92b0a8 100644
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



