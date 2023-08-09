Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5D117AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF07C433C9;
	Wed,  9 Aug 2023 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580379;
	bh=1g4NKE7ziG5yB3fVf2fTsDUzYjCajxUhRMOqE15E93E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2nybphXuyIza2TwhH37MPdKjIYgvuVnxVUk0Lcs7kl1/On/dxGgY518GEOUYzu07
	 LygICZ48CUV2E3RU2M0gzJJPNq22nuoJf2M8Nk/OdawxNQNzTCncsxCZuM4wEGYCuY
	 kzIJh2198tke0pfQlGavnmg5VizTPDG3jydYG6nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Block <bblock@linux.ibm.com>,
	Fedor Loshakov <loshakov@linux.ibm.com>,
	Steffen Maier <maier@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 305/323] scsi: zfcp: Defer fc_rport blocking until after ADISC response
Date: Wed,  9 Aug 2023 12:42:23 +0200
Message-ID: <20230809103711.996742400@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steffen Maier <maier@linux.ibm.com>

commit e65851989001c0c9ba9177564b13b38201c0854c upstream.

Storage devices are free to send RSCNs, e.g. for internal state changes. If
this happens on all connected paths, zfcp risks temporarily losing all
paths at the same time. This has strong requirements on multipath
configuration such as "no_path_retry queue".

Avoid such situations by deferring fc_rport blocking until after the ADISC
response, when any actual state change of the remote port became clear.
The already existing port recovery triggers explicitly block the fc_rport.
The triggers are: on ADISC reject or timeout (typical cable pull case), and
on ADISC indicating that the remote port has changed its WWPN or
the port is meanwhile no longer open.

As a side effect, this also removes a confusing direct function call to
another work item function zfcp_scsi_rport_work() instead of scheduling
that other work item. It was probably done that way to have the rport block
side effect immediate and synchronous to the caller.

Fixes: a2fa0aede07c ("[SCSI] zfcp: Block FC transport rports early on errors")
Cc: stable@vger.kernel.org #v2.6.30+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Link: https://lore.kernel.org/r/20230724145156.3920244-1-maier@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/scsi/zfcp_fc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -534,8 +534,7 @@ static void zfcp_fc_adisc_handler(void *
 
 	/* re-init to undo drop from zfcp_fc_adisc() */
 	port->d_id = ntoh24(adisc_resp->adisc_port_id);
-	/* port is good, unblock rport without going through erp */
-	zfcp_scsi_schedule_rport_register(port);
+	/* port is still good, nothing to do */
  out:
 	atomic_andnot(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	put_device(&port->dev);
@@ -595,9 +594,6 @@ void zfcp_fc_link_test_work(struct work_
 	int retval;
 
 	set_worker_desc("zadisc%16llx", port->wwpn); /* < WORKER_DESC_LEN=24 */
-	get_device(&port->dev);
-	port->rport_task = RPORT_DEL;
-	zfcp_scsi_rport_work(&port->rport_work);
 
 	/* only issue one test command at one time per port */
 	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_LINK_TEST)


