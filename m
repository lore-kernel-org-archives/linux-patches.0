Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEDB3B52FF;
	Tue, 21 Jul 2026 22:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672551; cv=none; b=So4YX/sdkKSmz3k7mH5SEUon6FKkf6CfJ7OnCCVs77Y8adfwL0TREy2JcjBHlrahE9JegnslI/Y+9iob2bdJshus+B7P1ZlliJLWf95Xw3Wxkw6MBhZBvUcZ2q/oRS8mFVFU64946BTSw4uEMLQ9HamD3YMW6c7nTZMfckMbNwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672551; c=relaxed/simple;
	bh=b/yPJN1MS1nsGDneRiRsthjlWwcFj9PJBs15DnVSKO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFVnUFsgMG0qzLRh7bxhmABUae3zD44O84aM3BTub70UGzSxmJ2x4XVFYL9910PLyRi6TBlsfwVrOBTpxd++hwrDL6z8moXOiuTwp92B7T9Z1U3ZuT5U+yvFWnkmpwI0pfgNrKtRMR4QdPY5SzOLEvBDYPEnyze4v649U7JOYno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cf6gxN+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cf6gxN+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947451F000E9;
	Tue, 21 Jul 2026 22:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672550;
	bh=RubJ7ivOtR78MTVd5Iye4UH6SO2nO4BBj50xEl7sMuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cf6gxN+c3PhZeGCoyah3RT227OrIvvTNWoHPY5++TJ74trO3MA3i3zK5te4mhzjQ4
	 m58y4br2fYSPIrTV2QKwzFjkikPtF0uMAcZlVaWryjLK3YyZOS1xZCtwKmeEFmhAXK
	 cMnIuc+qyMlwvD4Yrlntk3tuv65whucOaX5cuwA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 666/843] scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()
Date: Tue, 21 Jul 2026 17:25:01 +0200
Message-ID: <20260721152421.042110820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 2c007acf7b31c39c08ce4959451ad00b19be4c1f upstream.

When efct_hw_reqtag_alloc() fails in efct_hw_io_abort(), the error path
returns -ENOSPC without releasing the reference obtained via
kref_get_unless_zero() earlier in the function. All other error paths
correctly drop the reference. This causes a permanent reference leak on the
io_to_abort object.

Additionally, the abort_in_progress flag is left set to true on this path,
which means future abort attempts for the same I/O will immediately return
-EINPROGRESS even though the abort was never submitted, effectively
blocking recovery.

Fix this by adding the missing kref_put() call and reset abort_in_progress
to false, matching the cleanup done in the efct_hw_wq_write() failure path
below.

Cc: stable@vger.kernel.org
Fixes: 63de51327a64 ("scsi: elx: efct: Hardware I/O and SGL initialization")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Link: https://patch.msgid.link/20260611053037.63756-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/elx/efct/efct_hw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1999,6 +1999,8 @@ efct_hw_io_abort(struct efct_hw *hw, str
 	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
 	if (!wqcb) {
 		efc_log_err(hw->os, "can't allocate request tag\n");
+		io_to_abort->abort_in_progress = false;
+		kref_put(&io_to_abort->ref, io_to_abort->release);
 		return -ENOSPC;
 	}
 


