Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B524288B9;
	Sat, 12 Sep 2026 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231014; cv=none; b=Z+K2s+oGDS/3zkPEgollRoQ9SGFcPrcYuUvWhq+lD14hoWVPJjQ0MEQc2e0pRXi2tthUpEkKP2LQ8fh67znoNJ+qc8T5ssU64u2k/HviElHL9RMAL3Fl4GA4tcGZc5VCuznpl7qdOERxDmyqp/S4j/6qrRyfBCgiMTwff5ptADs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231014; c=relaxed/simple;
	bh=pk9aK+uxAa93iIZQcmGXLN4KBQe9oDQhfsKpig2x/rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMJ5dUad2ye6Cqv5IXjE9pOj7Bol/Vz5T9hFdKKlyUc6XotOr1ANXRz9xal2DuPkxY9JIVOv/dim+d8dk5jPiiu/K5Tv1Bf0w/uUaHy5xUjGsqu/FvRRyrRSqLiZ5EN8MjqKpr5MjR295kbqbwEI5SRsfB0EORiT1MGeFDYeIeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iILynpzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iILynpzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197111F000FF;
	Sat, 12 Sep 2026 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231013;
	bh=AlGHU31yUHAHOICT+lemobHkCp4f4ZS6KGSDKZFsg40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iILynpzh/RIWGgFzYY+kGeK/9w8Am3Qi0YWvDFsUP38DSeN1+OJaStzbr2P9e/PuP
	 eibAzmr64MrqCcD4V7tTJRpSxgsqaT/gZLD1xbcRCuEkS2xLniYOpezJeA19NdPi1K
	 2oe7k5IlXEjPcIJ7zy3Mvk7tFn8wA50sQVvacTvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0911/1191] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Sat, 12 Sep 2026 09:00:39 +0200
Message-ID: <20260912065608.697821240@linuxfoundation.org>
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
index fd08b2d4aa33e..b1d1a0c9f6dcd 100644
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



