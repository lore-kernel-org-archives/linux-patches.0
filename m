Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF8F4E4C5A;
	Tue, 13 Oct 2026 11:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892229; cv=none; b=uCkJx4hZuLD28ZuwDPCRSWvVxOcUeevdprbDeW5HjwAtAiE5CaY8sY3hjEBbXLPMCFbCqsOlMxBk9lgh/hOlyO/MZEoTupCq05q3ooFM5levXQIvORVa3ONd8FIySbTdDVMFlWKZw++/0Unj70xw/piV+oxttosw7h5VP+abtQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892229; c=relaxed/simple;
	bh=NqBdRlFdzlICDQblAocTYry9yVHp8oAAlgg8J+9hvFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7JrvSeVVHjqKZR2kKanlGE4Rqm3J8m98HdSUlBtnXbOgOOi19RVWeL3WzF+7iUjq3O2Gub7xbWnu36r3pB3wX1arUB2tcoZ0kE7JfOfTi9avGXSud1k6chFLJEizAEWIZ9MEb9x9T6e2EXNso9G14doRGhudl+ihNnQ/vsnsYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ676j4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ676j4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7815E1F000FF;
	Tue, 13 Oct 2026 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892228;
	bh=1K7bKiVvBSlB6fc24q9I1yPq0AP50R2Ny9XcXMl/NiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZ676j4s26TkyiMwZtv+HxPYmXMnJSq/Yww3y6cuHtJ4PEsLffLh6yIUJW67d4Su5
	 /r9C47p9/QYt3P6PQQbNJJXTcA2VoH5/zgUdp97fVk4NJdSPmANKWI4U9f29uce94C
	 VA42XwuA9EoULIlytIwKP/d5x70oP63l8dnZ2lNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 103/281] scsi: qedi: Initialize callback state before registration
Date: Tue, 13 Oct 2026 13:36:59 +0200
Message-ID: <20261013112857.637816703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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
@@ -2652,8 +2652,6 @@ retry_probe:
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu = DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu = DEF_PATH_MTU;
@@ -2670,6 +2668,7 @@ retry_probe:
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
 


