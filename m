Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811E4FD260;
	Tue, 13 Oct 2026 12:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895938; cv=none; b=qizEMrhds4wQus4GpuONn3fj9Dlhisgvh1Qi/BmJTIqoYEOCj+UzHp2l2EQuwuA3QiWvZSjJZSInzLu+4QoKHNp6JyTKeTF1kq4SWZQ/fhmMNtnsVzsHFXGhHp7bDrJgrIWfuTtoZLbzZilOv4wb8QLSdCwvv/NqAWHIFUxrRZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895938; c=relaxed/simple;
	bh=6HfCUQAinyQ7kUEvV6p2ampsQEt5APXqEP3OxdSpDEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwQk+5gb7cAz7/N7WKr6B3yjKoI/RxNkn8UfoRqmDiIrV3cIablT7tjkyJHsFR9Tpj7Bs3GfRKGh+DZeFiLICqmQFuXxlP29sJ28LIZy28MgPL8ycx7hn5kaG+Oo3tduRtutl8ccOg1jZAkUN2dbkJcGFFoA2CWv7AH5DQTuV+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKeOzFW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKeOzFW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CB31F000FF;
	Tue, 13 Oct 2026 12:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895937;
	bh=MJ/KeMWjbCf114fBD8pkrq5ds+cQU/mn3VyeB43GjsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKeOzFW8VaQRKTjibMra7ax5fh6mJev2UPjYZsnIPSObnvum1ke6qv1l/GZJLfrc9
	 IZT0C67liAMGA8EhjClPJVdw5smBtgYpkx1XueCLz1PEEkdUU2/geGdxC721qvd6ZL
	 JE0XDYOZRIScY8piHwI1lS57w0igpArui7ASqz1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 416/497] scsi: qedi: Initialize callback state before registration
Date: Tue, 13 Oct 2026 13:39:43 +0200
Message-ID: <20261013112917.763169585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 85de8b3a5eaa23d153aff4c7c83dddbc949064c9 upstream.

qedi_get_protocol_tlv_data() can be called asynchronously by QED after
qedi_ops->register_ops(). It takes stats_lock and reads ll2_mtu, but
__qedi_probe() currently registers the callback before initializing the
mutex and assigning the default MTU on the normal probe path.

Initialize the callback-visible state before registering qedi_cb_ops. Keep
the recovery path from reinitializing state because it reuses the existing
qedi context.

Fixes: 3cc5746e5ad7 ("scsi: qedi: Initialize the stats mutex lock")
Cc: stable@vger.kernel.org
Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260910092405.1300129-1-runyu.xiao@seu.edu.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qedi/qedi_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2664,8 +2664,6 @@ retry_probe:
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu = DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu = DEF_PATH_MTU;
@@ -2682,6 +2680,7 @@ retry_probe:
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
 


