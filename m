Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8A563D5;
	Thu, 15 Aug 2024 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732405; cv=none; b=F5alFcK4mS3FBcL+SE4Mksc0nmphIHbQtfdHe6ew3jAOT5x/7utFcHoxE1mcRTQX6HoAOhao6Z18ifW1IoA0dHGgNIr0h+DDpea/yTNB85ZJdVuvd4nLegL9rnf6yKYkhK20+2ZF71u8wsMmFtdEXJk9+T7sm8dYrhLTYB+G1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732405; c=relaxed/simple;
	bh=vacCgvnPoPSQplGuVfLelwq1A/H5eSWmKh2tTJzO/Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeyQ5ZMVH/qSYljvFd31/6SHpOLsHebG8bb8fzM6t8IPxF6DufBVBECCzy6rm82whHx4M7wNZiXZeer2h7/oOBVN0t1EwVtVQNnMmD8D61VCMFMsnE9lwIU0Nu0ky5hkxaniKedwVk96L2cJCg3cGXA+id+813SX1y+6jq51wT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBmOkj8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBmOkj8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6F8C32786;
	Thu, 15 Aug 2024 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732405;
	bh=vacCgvnPoPSQplGuVfLelwq1A/H5eSWmKh2tTJzO/Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBmOkj8rG46HKQ7sv4mrjQTqGl/Ujy1z6pOHuz1OqfQ2dkTHL73RB/GOYUDZspQ5v
	 AI9J0wItUL+5N8klKrRsexlrTK1VWWZGZJ9XrAqUecovJvDeE56vmGrQycRMq9fyfC
	 6gdlwOerxUR0R008egFgScN9ApW+IFNryT9s1RbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 169/352] scsi: qla2xxx: validate nvme_local_port correctly
Date: Thu, 15 Aug 2024 15:23:55 +0200
Message-ID: <20240815131925.806860105@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -27,7 +27,10 @@ int qla_nvme_register_remote(struct scsi
 		return 0;
 	}
 
-	if (!vha->nvme_local_port && qla_nvme_register_hba(vha))
+	if (qla_nvme_register_hba(vha))
+		return 0;
+
+	if (!vha->nvme_local_port)
 		return 0;
 
 	if (!(fcport->nvme_prli_service_param &


