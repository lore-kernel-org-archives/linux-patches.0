Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7FA3382CB;
	Sat, 12 Sep 2026 19:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242247; cv=none; b=ayk/4fC6BGrJ1vOwM5/jzua/eWE3i5UZdvuIZshM83sGF6S/6HrZPVxVeuqcQhs7p6QcXzarRR2+HqowHPrnIpstB/LrRn6E34BuiNxB13vZ5uX6wb9NJk3HmcGiuUNLKZs3tTbNdxGe5Ye1BL3uhIz4LeNTGM5UL3apItmv+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242247; c=relaxed/simple;
	bh=Laza08uMr730+DHdgufnTYN3rRDTlhWqq+gKF/rzu8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgsrucZENfGkOdDsgbcynT7ehVD8dOCUP1CdOsVBwUhXyCRZyqs7/IWEJPJlizBhEtcm43l/VJOZf39A8aa/NtbopDSN2c9rs6Z7iYUfM9iqjdwhaRLVUU0tMvgbb5jJSZCrDG1dVBil3HRb7ABCcJGBK4ucn1BoX13xmsSy4rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvZ1AywT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvZ1AywT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580B71F000FF;
	Sat, 12 Sep 2026 19:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242245;
	bh=Lw3Hv2yFy6TZI/JnmRmToB/M7VRDd2zXhOBSKyPmw8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvZ1AywTh9zPwMcnWVuaZy8mkoH7ktwqxA7oGnaQAGXyAfZ9LnuKY5k5LkdcKsytt
	 KmsiGUQ4m8DXK7fBl1+6SwGklVqtHCNuB29Habsc4z7JQ0mdBnuZaDIjV6Mxmengbh
	 5inHgXSQuADI0RH7osnFPWdDLjByKCKp7+Cy95vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 294/798] scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
Date: Sat, 12 Sep 2026 08:58:42 +0200
Message-ID: <20260912065523.902202629@linuxfoundation.org>
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

commit 793cedee296fd819bfadc2a7ec4d52faf9c09a0a upstream.

In the format 1 path, the virtual port is located on ha->vp_list while
holding vport_slock, but the lock is dropped before vp is used:
qla_update_host_map() is called and VP_IDX_ACQUIRED/REGISTER_FC4_NEEDED/
REGISTER_FDMI_NEEDED are set on vp. No reference is taken across that
window, so a concurrent qla24xx_deallocate_vp_id() can tear the vport
down and free it, leading to a use-after-free.

Take a vport reference (vref_count) under vport_slock when the matching
vp is found, and drop it after the last use of
vp. qla24xx_deallocate_vp_id() waits for vref_count to reach zero before
unlinking and freeing the vport, so the pointer stays valid. This
matches the reference idiom already used by the other ha->vp_list
traversals.

Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-51-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4084,6 +4084,7 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			list_for_each_entry(vp, &ha->vp_list, list) {
 				if (rptid_entry->vp_idx == vp->vp_idx) {
 					found = 1;
+					atomic_inc(&vp->vref_count);
 					break;
 				}
 			}
@@ -4101,6 +4102,8 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
+
+			atomic_dec(&vp->vref_count);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);


