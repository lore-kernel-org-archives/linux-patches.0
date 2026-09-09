Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF69355C1D4;
	Wed,  9 Sep 2026 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962816; cv=none; b=nUWPwADq8K1Ekt79IdWMFDYZw8kwk4eMbioPTJKdw05S2/n8e2Z3wtnGAlHURg+31ovTnZtNyYM+xPYG7TiWOEMvbqoFHFr42oBBOgCIAf/iXztK2yoNP+OTM9e1RkmxT6qxdS6QDwTg9t2mi2peU95M7QlPDmTPqSLAPxoSgNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962816; c=relaxed/simple;
	bh=KzXFs7fvUrRlnUuR7VY38vc/OsWxpAXx8l21lGCpFD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb3NzO1WfLJLF1dL6ewSXQhMQIiQlBBtR3vIIOPo0RlgCxDS0ghwuBOwmpRotzsV9II7iWlmvNDWtMr97ZC13fDDDFX5eGZLTPFtJlcc1lbbwXLWZdbdVusN+cjrdBIUnXAg7xyXqTjIxhJXLKEmFLfEyNu986TwiKbpgsnvVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtbpy0MB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtbpy0MB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C9D1F00A3D;
	Wed,  9 Sep 2026 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962814;
	bh=LKJpefIShhLu55NHeU2vpB8PhKtQ1cNrN2klOdewq+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtbpy0MBsKHgcalMvSGAIPFMkU3H7vk8Gl5sTVYph/vaNIB9pHA/ZsM+Kz0YJA9/U
	 KGKIWect+EpBoSfSU4WvLUkGdW2n5iqlL+PUHQ+3i6breLln4i9lgthpnSlckhI+Xb
	 bNmp8qZD+F72lhGghbeUZltXusudVdoZBf40meUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 420/556] scsi: qla2xxx: Fix BSG job leak on validate flash image error path
Date: Wed,  9 Sep 2026 15:41:40 +0200
Message-ID: <20260909134245.377496159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 0fb52cc632464b0cd07f970341330466d772efe1 upstream.

qla28xx_validate_flash_image() returns QLA_SUCCESS (0) unconditionally,
telling the FC BSG transport (fc_bsg_host_dispatch()) that the driver
owns and will complete the request. But bsg_job_done() is guarded by "if
(!rval)", so on the error path (rval == -EINVAL) neither the driver nor
the transport completes the job. The request dangles until it times out,
leaking block layer resources.

Commit c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double
free") added the "if (!rval)" guard to a batch of BSG handlers. That is
correct for handlers that also return the error code (the transport then
completes the job once via fail_host_msg), but this function returns
QLA_SUCCESS unconditionally, so the guard turned a correct single
completion into a leak.

Always call bsg_job_done(): bsg_reply->result is DID_OK and the error is
reported in vendor_rsp[0], and since the function returns 0 the
transport will not complete the job a second time.

Fixes: c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double free")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-55-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3377,9 +3377,8 @@ static int qla28xx_validate_flash_image(
 	bsg_reply->result = DID_OK << 16;
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
-			     bsg_reply->reply_payload_rcv_len);
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
 
 	return QLA_SUCCESS;
 }


