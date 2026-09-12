Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D160399342;
	Sat, 12 Sep 2026 18:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237936; cv=none; b=eb7nYokb+oml0HltESoYWrJ+3gnivKRypxY4sy+QZMmq9WrN0i4ZHZRmDkRTepZVxyUKs2AnRqdNqyjHDWqdZ10aejmXoi7qeONOvWeFX9LtefOXuV0Wy7n5OLjqbDWyLb/AauY8TCY+cJ/Ecq4BJMtresERL6dNOZSW9QI0/IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237936; c=relaxed/simple;
	bh=VeB+kzMfTGu7FLXajyoHJZrLGjjIXIRaoNz62Z7uC/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiXfohyY8sGozgsQ5uiN5/r7SSe6d7IA7xbr86HTVdJ6/jlgGvXLNC/geP8Dp9F451mJ3ngPPNUtaGn+vI9+utYAuJfuep8XEHKnNJzywN2qaRnIpBXpZ9N9IzjRKdm+wDzUFSR1Pnw/dlAjxpJvHs7PPhr2xJhe+XyQkGrvbO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZa1f7rf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZa1f7rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C071F00893;
	Sat, 12 Sep 2026 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237932;
	bh=Set/EzQR/CaBf1CPkA5o2W93l6VtKbzzQpG1izR0ZAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZa1f7rf3eK3QcZztqzpCZN6OCIjuMbF0NzwiAUr3tgnTUlblkgJzOh5d7q2rjt8R
	 yDeqMKLw54u/dV/MmQDKbSGwpTI2NtRuOH+kUsjYOuZwcjMqyZCctTDwwFBzgDqIT3
	 C60gXlCbg+3eObJ83fPIZpSbl3ej7GJ2BAeAN7Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 352/935] scsi: qla2xxx: Drop vport reference under lock in report ID acquisition
Date: Sat, 12 Sep 2026 08:56:22 +0200
Message-ID: <20260912065534.881121080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4161,7 +4161,9 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);


