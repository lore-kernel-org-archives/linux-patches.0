Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3753213E97;
	Thu, 12 Dec 2024 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016291; cv=none; b=r437aKr8Mz1bj+dQ2S4cgndtvREf+OVvktfN9cGG3/V6sxafeoYVTI8+nkNcdE7+TwHNEL3THrP0GXbcuG5ULlhreQkhgZpf8dSlH4JQ8rFOdC1SwcN8ixionBoH9duMXJvQ69pCHPYY1J6m2a7SOSa9yDop5aiCyV2MZRGf1PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016291; c=relaxed/simple;
	bh=llGiApNpU+Qxbmfgl8cVYhZeKlaADJfSaQkzTbqiqlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWXKdJM7a2XcG5hg2WxnMYBIkmbVKYcXgLqPDs7ynJpXmegJx4X5x0Iw4oCu1dyOK/BjSbs1u/YO8QbMAr7vAcNy7ssvk9d2BL4R28C/o1VxeLTZBcj/Bjn1vvj5duTtNwWhXwEkzM35Zzw9AgV90DgWG2A+tufbozXe5DZC5Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O0kZwoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O0kZwoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F88CC4CECE;
	Thu, 12 Dec 2024 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016291;
	bh=llGiApNpU+Qxbmfgl8cVYhZeKlaADJfSaQkzTbqiqlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1O0kZwocw3BniduM7KmI9gSvCgRvz4SXquLQrBnTRWbHxSOr2e/OZIX44MdmeD4Cr
	 cagaJWTJ1Fdf430LwMniYXBETKrxzbO6aIf7KwfZPjP7GQxJdVS9U9mN2a6QDl2SA2
	 ZUoG640p2Qa8G7IF1xdfwlg1RR8GYGIy8DCn8pUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 149/466] scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt
Date: Thu, 12 Dec 2024 15:55:18 +0100
Message-ID: <20241212144312.687243906@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Saurav Kashyap <skashyap@marvell.com>

commit 833c70e212fc40d3e98da941796f4c7bcaecdf58 upstream.

Firmware supports multiple sg_cnt for request and response for CT
commands, so remove the redundant check. A check is there where sg_cnt
for request and response should be same. This is not required as driver
and FW have code to handle multiple and different sg_cnt on request and
response.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20241115130313.46826-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -494,16 +494,6 @@ qla2x00_process_ct(struct bsg_job *bsg_j
 		goto done;
 	}
 
-	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
-		ql_log(ql_log_warn, vha, 0x7011,
-		    "request_sg_cnt: %x dma_request_sg_cnt: %x reply_sg_cnt:%x "
-		    "dma_reply_sg_cnt: %x\n", bsg_job->request_payload.sg_cnt,
-		    req_sg_cnt, bsg_job->reply_payload.sg_cnt, rsp_sg_cnt);
-		rval = -EAGAIN;
-		goto done_unmap_sg;
-	}
-
 	if (!vha->flags.online) {
 		ql_log(ql_log_warn, vha, 0x7012,
 		    "Host is not online.\n");


