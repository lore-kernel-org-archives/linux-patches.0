Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9603382CB;
	Sat, 12 Sep 2026 19:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242125; cv=none; b=W/QZzAh62+8bQNpBzC72id+hZVsFbAZVahhiz29Z7Vdp7ZHRxzewB0vFAcsj11D6Xe7qe1PWqN+/VReq+s9+6Izj/9bM1gIFTFd/mVl0nT4MUdrRxoCu4i0LQg4pIwWIcY1r6YIp1PQm83KDidxVGEZa/58gEzjYpJkdIpKFMhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242125; c=relaxed/simple;
	bh=hHJYzu1rO6IqYGWgZM4R/r0sFk2KLJTPzNPYQDnQ2gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtVYJAFya8uYx1rBzDHA4TZyylZPogErpEPXhJ+3b1lvPKAAHPisudZvnEC40HailGIlKH7Y8uPyE/KmlPQgNg++uboBZ105K3a6BpKsKuczSOa/I6oe6+m713mhypMwVT2G7sQnLZ1BPkiCwABfM33jCj79ZUZ27tq0Z44gljw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZWXXD7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZWXXD7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959B21F000FF;
	Sat, 12 Sep 2026 19:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242124;
	bh=0IWbDF+8t/o9/1Tvj3K3HSSSbGdULrkmy1veo69RHhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZWXXD7Fx6PkDuYqRwa44IVEUrwMOJ/EL9a7ujbDp7Bqj1Hn6eA6HZUViSIPDdPYS
	 O+vQhsZPOprn5w/FLzq/f5q0fHX6N7u/cYv77v7jftoeuPkvL/QHvE0rUHTNJvMRVc
	 5A2cCcKOJl7aNx++KB0whswCGS3Cayi/TxGk/gHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 295/798] scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
Date: Sat, 12 Sep 2026 08:58:43 +0200
Message-ID: <20260912065523.924397304@linuxfoundation.org>
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

commit 9101c51649f5b6773a97bf5271785c948589ea1d upstream.

The Modify VP Config completion handler labelled its first error branch
"error status" but tested vpmod->comp_status instead of
vpmod->entry_status. Because CS_COMPLETE is 0, the following
"comp_status != CS_COMPLETE" branch duplicated that test and was dead
code, and entry_status was never examined at all.

When firmware rejects the IOCB early it sets entry_status while leaving
comp_status zero. As the IOCB is allocated with dma_pool_zalloc(), both
comp_status branches evaluate false and the handler falls through to the
success path, calling fc_vport_set_state(FC_VPORT_INITIALIZING) for a
configuration the firmware never accepted. This can leave the virtual
port enabled on top of an invalid config and surface later as login
timeouts or follow-on firmware errors.

Test entry_status in the first branch, matching qla_ctrlvp_completed()
and the login/logout/abort/reset IOCB handlers; the comp_status branch
then becomes the live completion-status check.

Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-50-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4204,10 +4204,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
 		    "Failed to issue VP config IOCB (%x).\n", rval);
-	} else if (vpmod->comp_status != 0) {
+	} else if (vpmod->entry_status != 0) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10be,
 		    "Failed to complete IOCB -- error status (%x).\n",
-		    vpmod->comp_status);
+		    vpmod->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vpmod->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bf,


