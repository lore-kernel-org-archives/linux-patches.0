Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2988925F780;
	Mon, 22 Sep 2025 19:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569852; cv=none; b=l+06WXrhnsRvohzh5bE9VXPvsaqL92CMG1YI8yPE3YXMdHhB9JdSRM6dIix+uwVsmaO/z5j5SCZ+vBwWGmz0KhcE6PzTsFGEHeDRX1ycU5Xb7TDEQYmpP0Af8OPd8+eiaL/GLGjM9cpGY0T8oDesU2JpdsTzgFpPHpMufuRgsCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569852; c=relaxed/simple;
	bh=fpSHHZhK3CRGYAvW9wuJZvB451PJx/GcJSmu/hAeZAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOmndsyz6G6f/1NSP4BttNf7EBsSX+Lx/VuYqiY97KOX/pnMNGuuY5NwtXkbA3mjbTIJuiY9cMEkr0Hd8b2UscTxjvEh2HfvLX8ck2PMKUeZlMOWzqpvORtzdiKo2MDM/hzk8f4X+8lNXO1IozvREJB5ufaD1PILAtP58cOWIZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUkv9zKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUkv9zKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50AAC4CEF0;
	Mon, 22 Sep 2025 19:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569852;
	bh=fpSHHZhK3CRGYAvW9wuJZvB451PJx/GcJSmu/hAeZAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUkv9zKdecQxRQ0rqkejj/O+1nHIRjC6VuzwIxDdsCNmQjbo3TrMblFXYAVcG/Syp
	 r4N8AiE+bqqamvHqwtouEQokMOHat60Acirgy4C92D5xuChDsu1AUNhO7NXYABLCEp
	 i5054MaxP02fgUqUfzBFFeelhw9csUO68R/COc2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/105] qed: Dont collect too many protection override GRC elements
Date: Mon, 22 Sep 2025 21:28:56 +0200
Message-ID: <20250922192409.251469636@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f67be4b8ad435..523cbd91baf49 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -4461,10 +4461,11 @@ static enum dbg_status qed_protection_override_dump(struct qed_hwfn *p_hwfn,
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



