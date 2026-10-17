Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D942C3B813A;
	Sat, 17 Oct 2026 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260644; cv=none; b=SpxDVP4WwPPgbB+Cl91SKmwg4xvuJs0Mfxn7F+/sag1LIlG8pS57mG/iY3F/4SiTJsPYYsdn9PVp/GhdWzcZalod8RFBLVE9obP9En6VJ/Lg+sxGJorXYCLGGoi52LE28oG7WJdagYMr9V1WUL7BcT3MRMzFUwH5Xsj7iycD8ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260644; c=relaxed/simple;
	bh=Xqv3/0oAdca8Hvp8yGoplpFnmpd6dbP7elhUtlwfECU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGp8S4CaD4USA4IjErh9bQqABidPWzavxK3tdPMRSapGtu+iZxMGbV5Pf6KtbJJoEt1pOLiRhfV/1kYMa79N4ke+4FrDV2jiVwYFi1MPxqav0B2MVkN792iKlX8K/OVpsQ+2iO2Mzh6bKh1a2R1ruggcRp+FTOVypl0RgJ+/1pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Haq9EANP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Haq9EANP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322301F000C4;
	Sat, 17 Oct 2026 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260643;
	bh=jmTxNeAb/qb89MBG5o4a7HUrkmwq9rHArmcgOFVWPMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Haq9EANPlJs6KDi//WnyiVWoddmnDwWlliQYPKpElOI3eBA/8oyWRLym0HpWmljQS
	 tAyrN9wiEzAVxjrL3zi+ia3pNt4h9pz7TMfX9C8Jl9p9ly3J+YD4xE9GzaF8QTGz+r
	 m8HEZI2jQL6e3rbiT1Gce86Uwsl5yEsNLtQ1qquk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1586/1674] scsi: qla2xxx: Skip vport under deletion in report ID acquisition
Date: Sat, 17 Oct 2026 18:04:18 +0200
Message-ID: <20261017160511.799011777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 23582731afa35031c94fadb71a4f3b4afd094649 ]

qla24xx_report_id_acquisition() format-1 handling walks ha->vp_list under
vport_slock, takes a vref_count on the matching vport and calls
qla_update_host_map() to register its port id.

A vport teardown via qla24xx_vport_delete() sets VPORT_DELETE, then
qla24xx_disable_vp() removes the vport from the host_map btree and zeroes
vha->d_id (RESET_AL_PA). The vport is only unlinked from vp_list later,
in qla24xx_deallocate_vp_id(), which clears vp_map[idx] (RESET_VP_IDX)
but does not touch host_map. In the window in between, report ID
acquisition can still find the vport on vp_list and call
qla_update_host_map(); with d_id already zeroed it takes the
btree_insert32() path and re-inserts the dying vport into host_map.
Nothing cleans that entry afterwards, so once scsi_host_put() frees the
vha a later host_map lookup dereferences freed memory.

Skip a vport that has VPORT_DELETE set before taking the reference, so it
is neither re-registered nor scheduled for DPC re-registration. This
mirrors the existing guard in qla2x00_alert_all_vps().

Fixes: 41dc529a4602 ("qla2xxx: Improve RSCN handling in driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-22-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 56db436894661..391a69878705b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4147,6 +4147,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			list_for_each_entry(vp, &ha->vp_list, list) {
 				if (rptid_entry->vp_idx == vp->vp_idx) {
+					if (test_bit(VPORT_DELETE, &vp->dpc_flags))
+						break;
 					found = 1;
 					atomic_inc(&vp->vref_count);
 					break;
-- 
2.53.0



