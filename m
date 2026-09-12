Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2437347ACE2;
	Sat, 12 Sep 2026 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237836; cv=none; b=OClbsh3iPC+DeWK+09RdqBI/ocVqJSX0bJfCIYlh9kCcQAVq/hml5gDtVtUruBm0xthvX2ZpOdAKr0G6jdDxnEF+12rkhiP4lOfUs6exC/oibLYqNT7eJ47lYgfndZFBEFLa0tmrS6QjDU1rGvCtYYo1bFXp/BbatYD4F8dFiBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237836; c=relaxed/simple;
	bh=LBJ1T/he7YwDJAxIKm7VpP2K9AcrBEGnFmzrSepNpro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWe39FAf9I4cVI/9xETfbf5DaOhitXgQnTbgSw+7/N2fZBNbe9ozqHzpeZh+HjXRw4/y1CHG6Wv+PVl7Zf1fCEF7iMjGH4F3xsYImbhCgZP93ugTm3p8jxtagHZZYv6LEXZIXfLCA89DgHmzQtyPKeSDOq+Ziw+xwjWyklXEHNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/jP47dA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/jP47dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BCD1F000FF;
	Sat, 12 Sep 2026 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237835;
	bh=ILUwLOvJkh+AyGuAby+rXByGG/QJLvvMRToOOmBEQAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/jP47dAnIXeOyKSQ9VkdKIjFMXxkWLtU9aBXlMc5vGSMbafKpCbJ/jBkVYrlS9kb
	 0d1MPbugcBXR7UPfYps/6yASDkCFaUKlLQtjnWH3W8Mmu17cDxk8YhHVaKqQDdKAPQ
	 OrOfvvZkIAqxTqK3Ie3lN8YtcY8mU2zT8IOGikVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 338/935] scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
Date: Sat, 12 Sep 2026 08:56:08 +0200
Message-ID: <20260912065534.558665311@linuxfoundation.org>
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
@@ -4270,10 +4270,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t
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


