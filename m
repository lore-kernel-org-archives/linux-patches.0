Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01913AA9E2;
	Wed,  9 Sep 2026 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964219; cv=none; b=sRjrX7tEuGOu7XEyMmbKLYDYMLzE5g4b1Mm06QgSID5g99FCk7TQ8AzZWoLJS+NQlz6Bqr1IvpXsEknSRwaV+prjtc1t+Iou8cYVnJD7EZec+dG0O2ZJ4r7Q9tnrCpQ3E0KxchIgCIleP/PZIUdXMDnDLhnmPTB3R1U70NkZGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964219; c=relaxed/simple;
	bh=163pdNxGFYM6p3EwWdSE+55YqLAVP1banVZKVLSbnaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv/Kbc9XYa4zqP2bwWTDnheIKJMy0FjGAssn/NUlPF7ILbB3v3LIvzyNoRezxI3/mI7SVPLBCqt7dq0iSVsAOgCMpvfzbULkB5mCc6aTLpr29o53s3N0B+82UrcRMx4qHpH17WN/HOKroSLI6+SpAXnW89e2P5ATFOUABeRhXTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mh+pWaUW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mh+pWaUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0921F00A3A;
	Wed,  9 Sep 2026 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964217;
	bh=rCfn6l6J6OU2OVj4+KsrKZALsBq0PhLpGpQPR6ienY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mh+pWaUWBedzlgwm7elhXidu8Yh8XAuTaPsFECo/WMcUdbzNpopTe1qjlxU2v8KBJ
	 nqdDbLUDZjhRj1vuo0QqpE7hNr/AU3AZJTMgmxyokCNcbQCt5MZtZwYamQ8cQZdxTg
	 kxiFjiYK2H6To7geDxpKxlFDJdD8F4Qtekn+kY7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 346/583] scsi: qla2xxx: Drop vport reference under lock in report ID acquisition
Date: Wed,  9 Sep 2026 15:40:31 +0200
Message-ID: <20260909134249.967358179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 1154b16439ffc562f9461494c4508c63446eb684 upstream.

qla24xx_report_id_acquisition() format-1 handling takes the vport
reference under vport_slock but drops it outside the lock, after setting
vp->vp_flags and vp->dpc_flags:

	set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
	set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
	set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);

	atomic_dec(&vp->vref_count);

Neither set_bit() nor atomic_dec() imply a memory barrier, so on a weakly
ordered architecture the decrement can become visible before the flag
stores. qla24xx_deallocate_vp_id() polls vref_count under vport_slock and
unlinks the vport once it reads zero, after which qla24xx_vport_delete()
frees it via scsi_host_put(). The poller could therefore observe
vref_count == 0 early and tear the vport down while the pending vp_flags/
dpc_flags stores land on freed memory.

Drop the reference under vport_slock, as is done for the matching
increment and by every other vref_count user. The unlock release pairs
with the deallocate poller's lock acquire so the flag stores are ordered
before vref_count == 0 can be observed.

Fixes: 793cedee296f ("scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-23-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4167,7 +4167,9 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);


