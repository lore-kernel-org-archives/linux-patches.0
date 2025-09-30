Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9F2223DD6;
	Tue, 30 Sep 2025 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245109; cv=none; b=Nf9Ux+URePyqE3qHZ5/UFdrTSgNMH45fRD+il8wfgnJzL0KUHH5yWbGMSaQsBrHfx/YfyHoU8g88CKJYVbtBhedkcwjSfmoFnksad1B38NOOMQ2k2sZCiel6mLeg97ThVDnH+TMgFzceaCEU5yGYpju9Y6dBkD7QNe9Z23YQvDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245109; c=relaxed/simple;
	bh=ZGXgjI9AOfpUSInHqUygFVpaBDz6U9fRE+AGdMi7BrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkYX6dkZ/4DnC1sjNjmdIszEZ63GH56lds0nrn7NNJQbxgjUsWMs9pScTz3UJgRLu9YUYg7fdijIBzcHgeIeZrSkVqDtOfM/Wr9JmK0T54kjvreuV9IqFblBMba33mvW2Mfh1PHnvXjv4FZrCkfyJ2L9UbEf2KeLhJPXd33Hn60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KADOQSUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KADOQSUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7F2C4CEF0;
	Tue, 30 Sep 2025 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245108;
	bh=ZGXgjI9AOfpUSInHqUygFVpaBDz6U9fRE+AGdMi7BrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KADOQSUVDMOBfzvh65ZhQxa0VJSpQ0ScE0lLj+jlDVQBFGIA3WkAg77dYyN8Q8xQw
	 Zl2kJi6fJvq01+K7ZaWaJ/2rYVCQ4072gptN5j/CagQpN+CS5DJYPlp6gBrHInQ3f7
	 oIQ6AZLR8Hk+55d6XZsGVYoxWgvpSJtLIeG2kxyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/151] qed: Dont collect too many protection override GRC elements
Date: Tue, 30 Sep 2025 16:46:41 +0200
Message-ID: <20250930143830.426081303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

From: Jamie Bainbridge <jamie.bainbridge@gmail.com>

[ Upstream commit 56c0a2a9ddc2f5b5078c5fb0f81ab76bbc3d4c37 ]

In the protection override dump path, the firmware can return far too
many GRC elements, resulting in attempting to write past the end of the
previously-kmalloc'ed dump buffer.

This will result in a kernel panic with reason:

 BUG: unable to handle kernel paging request at ADDRESS

where "ADDRESS" is just past the end of the protection override dump
buffer. The start address of the buffer is:
 p_hwfn->cdev->dbg_features[DBG_FEATURE_PROTECTION_OVERRIDE].dump_buf
and the size of the buffer is buf_size in the same data structure.

The panic can be arrived at from either the qede Ethernet driver path:

    [exception RIP: qed_grc_dump_addr_range+0x108]
 qed_protection_override_dump at ffffffffc02662ed [qed]
 qed_dbg_protection_override_dump at ffffffffc0267792 [qed]
 qed_dbg_feature at ffffffffc026aa8f [qed]
 qed_dbg_all_data at ffffffffc026b211 [qed]
 qed_fw_fatal_reporter_dump at ffffffffc027298a [qed]
 devlink_health_do_dump at ffffffff82497f61
 devlink_health_report at ffffffff8249cf29
 qed_report_fatal_error at ffffffffc0272baf [qed]
 qede_sp_task at ffffffffc045ed32 [qede]
 process_one_work at ffffffff81d19783

or the qedf storage driver path:

    [exception RIP: qed_grc_dump_addr_range+0x108]
 qed_protection_override_dump at ffffffffc068b2ed [qed]
 qed_dbg_protection_override_dump at ffffffffc068c792 [qed]
 qed_dbg_feature at ffffffffc068fa8f [qed]
 qed_dbg_all_data at ffffffffc0690211 [qed]
 qed_fw_fatal_reporter_dump at ffffffffc069798a [qed]
 devlink_health_do_dump at ffffffff8aa95e51
 devlink_health_report at ffffffff8aa9ae19
 qed_report_fatal_error at ffffffffc0697baf [qed]
 qed_hw_err_notify at ffffffffc06d32d7 [qed]
 qed_spq_post at ffffffffc06b1011 [qed]
 qed_fcoe_destroy_conn at ffffffffc06b2e91 [qed]
 qedf_cleanup_fcport at ffffffffc05e7597 [qedf]
 qedf_rport_event_handler at ffffffffc05e7bf7 [qedf]
 fc_rport_work at ffffffffc02da715 [libfc]
 process_one_work at ffffffff8a319663

Resolve this by clamping the firmware's return value to the maximum
number of legal elements the firmware should return.

Fixes: d52c89f120de8 ("qed*: Utilize FW 8.37.2.0")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Link: https://patch.msgid.link/f8e1182934aa274c18d0682a12dbaf347595469c.1757485536.git.jamie.bainbridge@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 4b4077cf2d266..b4e108d3ec945 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -4374,10 +4374,11 @@ static enum dbg_status qed_protection_override_dump(struct qed_hwfn *p_hwfn,
 		goto out;
 	}
 
-	/* Add override window info to buffer */
+	/* Add override window info to buffer, preventing buffer overflow */
 	override_window_dwords =
-		qed_rd(p_hwfn, p_ptt, GRC_REG_NUMBER_VALID_OVERRIDE_WINDOW) *
-		PROTECTION_OVERRIDE_ELEMENT_DWORDS;
+		min(qed_rd(p_hwfn, p_ptt, GRC_REG_NUMBER_VALID_OVERRIDE_WINDOW) *
+		PROTECTION_OVERRIDE_ELEMENT_DWORDS,
+		PROTECTION_OVERRIDE_DEPTH_DWORDS);
 	if (override_window_dwords) {
 		addr = BYTES_TO_DWORDS(GRC_REG_PROTECTION_OVERRIDE_WINDOW);
 		offset += qed_grc_dump_addr_range(p_hwfn,
-- 
2.51.0



