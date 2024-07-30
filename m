Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED95A1A6166;
	Tue, 30 Jul 2024 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358053; cv=none; b=KYAM9gforBbIwAOx0nKi8PMYb1ouyfA0vLjzcx0Gvg88ckshOilXcmxqYWs9ysObdsG65OE8iyT4m4H7wTVfqcP7R/BV6mvBA4XLQvE2KNaSKZgsoCgWH/hD2ftlO+IQXepTeXrjp1f403xo5Hd/0LXOcw2MA3Nu8BRksBRVlSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358053; c=relaxed/simple;
	bh=3Bpmbg6EBA4FPfdKu7lOxVVu7k/FVnZ52zL3CkCoofI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So5maeIvGm8A6xSfAPemel5fc6Z90VF6+uEjx+DItCDvUwe6EpCyBcGkSr7J+TNC0DWETER+1AXMjzOdMF0jkP9zwWuGL7TgAYDLlTwbRLS7Xom9qkzwI/OjH2PUyTS+0YfsjE2Uf5e/thQKLsXwEQIkErfatWsbgdDijwGBiFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vM/KklAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vM/KklAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C17BC32782;
	Tue, 30 Jul 2024 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358052;
	bh=3Bpmbg6EBA4FPfdKu7lOxVVu7k/FVnZ52zL3CkCoofI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vM/KklAFLYEf+DlZI+sIZnJiXWkn+YZZrS7ThaWGYWxpc3vIQspUZt+I99K5k48wY
	 YUEShUCSc8CDvg+uZqdK9wmy1UdMdZCeKL9ExqbczfuyXcYxgE3JQZaT6ZqCoWv0uz
	 qRRbGGYwno0F24NvUWFAWCu6lw6Ov+V7AiFVORdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 352/440] scsi: qla2xxx: validate nvme_local_port correctly
Date: Tue, 30 Jul 2024 17:49:45 +0200
Message-ID: <20240730151629.568251128@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit eb1d4ce2609584eeb7694866f34d4b213caa3af9 upstream.

The driver load failed with error message,

qla2xxx [0000:04:00.0]-ffff:0: register_localport failed: ret=ffffffef

and with a kernel crash,

	BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
	Workqueue: events_unbound qla_register_fcport_fn [qla2xxx]
	RIP: 0010:nvme_fc_register_remoteport+0x16/0x430 [nvme_fc]
	RSP: 0018:ffffaaa040eb3d98 EFLAGS: 00010282
	RAX: 0000000000000000 RBX: ffff9dfb46b78c00 RCX: 0000000000000000
	RDX: ffff9dfb46b78da8 RSI: ffffaaa040eb3e08 RDI: 0000000000000000
	RBP: ffff9dfb612a0a58 R08: ffffffffaf1d6270 R09: 3a34303a30303030
	R10: 34303a303030305b R11: 2078787832616c71 R12: ffff9dfb46b78dd4
	R13: ffff9dfb46b78c24 R14: ffff9dfb41525300 R15: ffff9dfb46b78da8
	FS:  0000000000000000(0000) GS:ffff9dfc67c00000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 0000000000000070 CR3: 000000018da10004 CR4: 00000000000206f0
	Call Trace:
	qla_nvme_register_remote+0xeb/0x1f0 [qla2xxx]
	? qla2x00_dfs_create_rport+0x231/0x270 [qla2xxx]
	qla2x00_update_fcport+0x2a1/0x3c0 [qla2xxx]
	qla_register_fcport_fn+0x54/0xc0 [qla2xxx]

Exit the qla_nvme_register_remote() function when qla_nvme_register_hba()
fails and correctly validate nvme_local_port.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -29,7 +29,10 @@ int qla_nvme_register_remote(struct scsi
 		return 0;
 	}
 
-	if (!vha->nvme_local_port && qla_nvme_register_hba(vha))
+	if (qla_nvme_register_hba(vha))
+		return 0;
+
+	if (!vha->nvme_local_port)
 		return 0;
 
 	if (!(fcport->nvme_prli_service_param &


