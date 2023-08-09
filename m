Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF0F1773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAAAC433C7;
	Wed,  9 Aug 2023 11:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579973;
	bh=FjGM2ycg/tW4fkppafv/UKDkOgWU6Dbnpk12aaQfOzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9xNFFngs7p2cviEfU1cKB7DMDrEs2uOlv1PJptvYAfO5u1KKTgQf2/bosrwkE/xM
	 WTkI2i8JCFu2EuDG1aW0EFvAekwQQVn4NIULWc6lCeq838nMaHvA1dRFZ/9zAoBSm7
	 idWeOSTU74zTf+Tt+MmpEQGq584laS/JrwMmLpM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 183/323] scsi: qla2xxx: Check valid rport returned by fc_bsg_to_rport()
Date: Wed,  9 Aug 2023 12:40:21 +0200
Message-ID: <20230809103706.536870173@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit af73f23a27206ffb3c477cac75b5fcf03410556e upstream.

Klocwork reported warning of rport maybe NULL and will be dereferenced.
rport returned by call to fc_bsg_to_rport() could be NULL and dereferenced.

Check valid rport returned by fc_bsg_to_rport().

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230607113843.37185-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -264,6 +264,10 @@ qla2x00_process_els(struct bsg_job *bsg_
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
+		if (!rport) {
+			rval = -ENOMEM;
+			goto done;
+		}
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);


