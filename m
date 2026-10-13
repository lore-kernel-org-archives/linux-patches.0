Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E23F4E8E08;
	Tue, 13 Oct 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893051; cv=none; b=GzT0J93lJXsehs+FtsqzcX2ApCjYVGiQzn2eFHTVktC95UTYI92Nwkmp4CT3a0TTaCrIICSNaXIt3q0jN1UzO2vimCao1I6bgHzMumvNKR+/vU1AS4EpfSV2iJ+AbymKVi+HVX943na6GyWAjxhnQY87lelwWIIMh3ZlRrAESOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893051; c=relaxed/simple;
	bh=wEWNvfWgW4MdUt3KgJTthi0NCtLpRB3ubBxxmwA1Z2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTXD0HvYVj6AITe7vmQD/d2e+ysX7S3PYpZnqMYcYDTiisL98CjiFV+2cuhW6S1ICMQPYC0UgoWE8hku+fw3TKUx/7L4zxZrcbl0ekSyAlnGS/sgmXke58FLqwNE6HQ/QYESR/YEFAJ+KPDGK4KegCOkLmkNL48M3h6LSFGiidU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUnSaALZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUnSaALZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782E31F000FF;
	Tue, 13 Oct 2026 12:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893050;
	bh=g2+jKUy/gkI9nDt1ah8uB1PVl+D78FV5J658QW6FN/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUnSaALZn0YFHJ8s+nNp4LYlLMUfxtLTNf3f3QpyFqVkyAGhYKjZr63pJ4X/HIhuu
	 dnHcbV11woBliK+EGbveTpe8Xckw7xEBOjf9LD+U19gNC6xsXwquOOGWnkzkgN7SfF
	 u8LMGYuFPFQjbr0Vsf+hyZMAFHTtQhQR7PfhMVlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 095/621] scsi: qedi: Initialize callback state before registration
Date: Tue, 13 Oct 2026 13:31:30 +0200
Message-ID: <20261013112923.104350478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2654,8 +2654,6 @@ retry_probe:
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu = DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu = DEF_PATH_MTU;
@@ -2672,6 +2670,7 @@ retry_probe:
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
 


