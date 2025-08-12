Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6729F2FE564;
	Tue, 12 Aug 2025 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021661; cv=none; b=kE5lmCG4vMOy2B7vIcFdAbH6bhiba8Bi8J8KLEA3yk4Qascf9bJNEwISLXcj5agZnAwj7kS1TRNeJyI/U77HzTyLiUUxmTs59hvtQfEeioEfT/Wj5l81sGbiYNuCQZg/0lHB8EwgB1AxvsXj+BZUxD3r8XBOUYFqdHHNYKELJKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021661; c=relaxed/simple;
	bh=wQ/VSnTlLvIoKXNtS7q6ky5ga0/8yw+bnq9YrFqsaS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ldfq4U6Atk0iD8tt7PANeoz2c095VmmuKsHXOH1eBF1MsRH/hTunnfFkAGZiV0/n0W/4Mc/I/GY8dtaYVlSWaWj5RG3G5wC5QDv/seBZbndqKw++TsOBApREkdXQwc0cPNG1Rt70Xfsd//zmU6IntevyoP5PKHCJCY6wvLdeKIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1L/xltje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1L/xltje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB48EC4CEF0;
	Tue, 12 Aug 2025 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021661;
	bh=wQ/VSnTlLvIoKXNtS7q6ky5ga0/8yw+bnq9YrFqsaS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1L/xltjeE1UqZpiYS/vC8JofghrhUURnGfnjIalsd7Kv+FDzc/eQLQtjhXZ/hJugQ
	 ioKJNvhjwNORg4xI9RRUdUISwh+SzOuoorpRxnfV4uy2ZMjP1nd1lK3oKWl3V6beBr
	 NfkAGTUkrBJvKFLjbeaO588Y7pgM0XKPQonGn3eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/262] scsi: Revert "scsi: iscsi: Fix HW conn removal use after free"
Date: Tue, 12 Aug 2025 19:29:34 +0200
Message-ID: <20250812173001.049308215@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 7bdc68921481c19cd8c85ddf805a834211c19e61 ]

This reverts commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e.

The invocation of iscsi_put_conn() in iscsi_iter_destory_conn_fn() is
used to free the initial reference counter of iscsi_cls_conn.  For
non-qla4xxx cases, the ->destroy_conn() callback (e.g.,
iscsi_conn_teardown) will call iscsi_remove_conn() and iscsi_put_conn()
to remove the connection from the children list of session and free the
connection at last.  However for qla4xxx, it is not the case. The
->destroy_conn() callback of qla4xxx will keep the connection in the
session conn_list and doesn't use iscsi_put_conn() to free the initial
reference counter. Therefore, it seems necessary to keep the
iscsi_put_conn() in the iscsi_iter_destroy_conn_fn(), otherwise, there
will be memory leak problem.

Link: https://lore.kernel.org/all/88334658-072b-4b90-a949-9c74ef93cfd1@huawei.com/
Fixes: c577ab7ba5f3 ("scsi: iscsi: Fix HW conn removal use after free")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Link: https://lore.kernel.org/r/20250715073926.3529456-1-lilingfeng3@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f2c31e74d8ed..22bec2453bac 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2169,6 +2169,8 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 		return 0;
 
 	iscsi_remove_conn(iscsi_dev_to_conn(dev));
+	iscsi_put_conn(iscsi_dev_to_conn(dev));
+
 	return 0;
 }
 
-- 
2.39.5



