Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6C637F8D7;
	Sat, 12 Sep 2026 19:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242162; cv=none; b=u4hCpO8q7AvfTNagttnUcf8C6Kxg1OaOYuoNv+0Q9qoZJQSNtnaWKDTFh4ktYuK/4fGTsm4S3BlB2NlPetAmmPtgA21CJOh6NI8+wrG3m7AtUBd60CJmo81wz49zy7v8BntGR0/Xx1G0PQCCUzSpsJo2v4mdFGPRV7roPGRqZXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242162; c=relaxed/simple;
	bh=gDSL90bVRpwz/Vub35SInELjKKUOqQp07vMYGeqYudM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0Uv0V+vM17aGA5A+scXLKHzavxBmE0P3xhwhTrdnrrQA/iN6n5TevDYAdwOrlQD/2JrUNTXOK9f2VN9nJp0E6JYzKFB2Xfg4WUWl1snR30noVHVGYdBf5mjQW+GUFpSUj2MHR5KJBahg/bbjNuj8vAo1H/CUAEBEUylVGzbhEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTpNcQo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTpNcQo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEA71F000FF;
	Sat, 12 Sep 2026 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242161;
	bh=WbPX6KCrYc7LfL1krKv7KQYXPKh/wXQZppr1jqMb624=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTpNcQo6LzBK3v9Bd+AGp0ucvtDRJAQPLWlMy1Q7HTmoFudlFGs0jKNDugDOXULKT
	 sipcK2wWuA/WaAu3Hs3pIxHis1MF2730skWET/fYZD36nce1kGHH+2VVc1SpKDu2Hc
	 J9XtGhkqcrav8fNl00nBMvlfdRCbfFyDHOw9/W0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 307/798] scsi: qla2xxx: Drop vport reference under lock in report ID acquisition
Date: Sat, 12 Sep 2026 08:58:55 +0200
Message-ID: <20260912065524.196029630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4105,7 +4105,9 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);


