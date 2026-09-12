Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A4434E74B;
	Sat, 12 Sep 2026 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224945; cv=none; b=E2KfNg+naJ0GVNVgX3Vm76OtkYq5GCkXI5m+Ylaf7XXpuCNDty8fDGg7HWKQe78CJ+OfM7VMbHeomSgSudYNzsBlBpUjgg7ZDukGSd77jO/UP0guSfVjUFUWsQoI2Kiat2A1FlntQuef/VQ2H8msdbY20NBr6gnq6rbX9fSOOPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224945; c=relaxed/simple;
	bh=AC4diMI0/4IDpNyPueO5EbSMV5WPXgP8l7oy2MZrfjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP6QbKXIkOT8dB4N7Oc9PqZkcNoGsDPL9MnAyOhDQHE7IVlUjmuWiraab9EzTzJyKFhYYg3f4xD7Sh6QhemMCvi7OFUVgYOc7aipr3e65IRreJZJy1Yd71sRt+pM19780+cuZU5uoLhuZmbYZ4Y4bss1zUZFiyeBQJvQihs6TSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaOfx0C6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaOfx0C6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BED1F000FF;
	Sat, 12 Sep 2026 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224943;
	bh=EF1GhzifbwV2lj1HEq4trs/nUceOAZvWBDkkZfoI0p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaOfx0C6nkznZmdRJ16JyoYaI5AB77Aam2aDRXvCkkmQyUm/kPnlOysOmI8fRI93U
	 TsLizVsdYvNK/P72is6R6hiDJndjDxM/EB+AA9uoef8EQAvv9XJ43dseUyuEGlLVpM
	 AulYTulzpwqV7lUQfd4cpChVfSVH9OWX725BsHus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1098/1424] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Sat, 12 Sep 2026 08:58:50 +0200
Message-ID: <20260912065631.895449694@linuxfoundation.org>
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
index c4cc92de11061..83a1fd47126da 100644
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



