Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653A55C1D6;
	Wed,  9 Sep 2026 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962872; cv=none; b=kdQB8OsmBr1/XGdiqXfnu5rOo6gDABpLz7PQ49sCy47wNCPNASm/84/UULoL1flW2kZnm88xLer79t/PkarXoVVWLBwaCRxgQ3Tp4RRI5RjByTQosPwwUdj+JtMdx0SR6Dg2/Lz12yB5jBN3wnWcpqSyDQzC9v7O15SDAyKn/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962872; c=relaxed/simple;
	bh=/lgNKy/SpQ9Vl2K7xoLsEO7Bg2a7G37QZ9EJn232soU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqpRSlmTcvSF9TWP2hBox6VoulNTorQkBcL+ZzV9KN/Etz4J8HIm9bJvmvhrFn7VDrt7Z2bQl2jKlbnEkHOcdP7rGU20pIgVV0o27YQaMfoND7zJxTjUrvoe2syJNa8Ou+yoCVpGIhOsQ2l89x91++bys7qAYqkHGKPvx+U7H/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QueSh1ED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QueSh1ED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA781F00A3D;
	Wed,  9 Sep 2026 14:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962871;
	bh=n6zlFjoiiMLZe0DPoN8gnnssSCwqTJKfT/HD7Yf0KXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QueSh1ED+HRfxdzPvLHWNSiSVN5Op9Rcq7IsmFRPW0oCHPyeazKslb2ESkekFsWju
	 0McUvfPN40KXrkXDsTroUBaydmh3KTpeUjS/aZoieerQlFIwenBXZggAiBr/lnZ1Dy
	 TzDNWh4125btdqiNkKtI6ojjDz3caqraVtNt1byw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 441/556] scsi: qla2xxx: Drop vport reference under lock in report ID acquisition
Date: Wed,  9 Sep 2026 15:42:01 +0200
Message-ID: <20260909134246.118847439@linuxfoundation.org>
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
@@ -4224,7 +4224,9 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);


