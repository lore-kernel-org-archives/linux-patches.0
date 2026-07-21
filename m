Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45564432E97;
	Tue, 21 Jul 2026 21:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670244; cv=none; b=aT9FDnoGl0xLpwpf9aEimVMYwZnTcuYw5te3Noi9p8i6gh6PTjC8CfnrBZ/ZIAlZr3nICEYVkOc9/O/IFtHpIQKwS8YHFPgOiqVY/Y+3MFCc+0mttoDmnYoNTJnVCxomf0ojlMCWaJE3T/cHrU24uriixozdqXKxe5NxJWYvEcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670244; c=relaxed/simple;
	bh=y4TJ/MRDWQ+qgtmENrUfm65VL77RhYs3Km1I0syNCbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGrknLs8b09JlFda3WaPCHq+C8iqxUMtevmW35YIWasf2v/8+dpWkbz9tOZEVtlJv5Rx6uuPuFEYZxbTbD0ll8hhJTCswO3SbN1fkLsbKRE0qy3o1thvMd1cFc6PiZ5KQSPu2Rsb+/xuiVDGGcHGoVpU7nOBfU278ievF7x0A9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BozZyTUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BozZyTUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6951F000E9;
	Tue, 21 Jul 2026 21:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670243;
	bh=Smk96LVyWM127ddidgmA3A0k0qoKOz/ANZxpIzvVsKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BozZyTUQbAWMavCPZpZaMtgWlAiY6JrWE8thKq2txsBma+3L7JfOcSzYbciJ3G+sH
	 JoZwca3HmfAoUQMVUZEio1+K8cpp+GUKkDyEzZA7WxEZV6ABpSm2LBw1W/ndmxthH6
	 JTfrlLMoGRv9KABRxj6kO+J69qN2TOAIfbB8bELY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 0859/1067] scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()
Date: Tue, 21 Jul 2026 17:24:20 +0200
Message-ID: <20260721152443.758375087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1998,6 +1998,8 @@ efct_hw_io_abort(struct efct_hw *hw, str
 	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
 	if (!wqcb) {
 		efc_log_err(hw->os, "can't allocate request tag\n");
+		io_to_abort->abort_in_progress = false;
+		kref_put(&io_to_abort->ref, io_to_abort->release);
 		return -ENOSPC;
 	}
 


