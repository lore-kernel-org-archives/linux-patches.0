Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136A46A5E7;
	Tue, 21 Jul 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654898; cv=none; b=pMmb/sgpJLDqUkQECnd2BmJ9YF5RP5UwLxQ6MVqlUWq7vA1ZENd6xfKl3jRgpafoe/SvfPqwE+1TqnGamqYIXrcSUgEiOWWGfV3gMB3Ewvkd0IEPb5PuBqlYuf/BGwexWgn/k6/H9Xa9FjPSctTFERWJVzo0eMCZNmHWCx7oAbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654898; c=relaxed/simple;
	bh=2JyHpuxAe8dQFF5Nd7J59FUj8JuQaoHNoHybLGcbQmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCCozFr1K7yQTzRaNmYLxBddf76kYddTgFqi7af+qpe8o4szqkEyHrhmZQFgOUnnbTjxDt1HXua7GNw6YY5EH0wBzAmPWmJTPgzBZSlF8ja81d/tAlnGO2KehLvjVbOF1MdIJWH2DjiuARWOjTty3juqzN+laW7tSm1CWC0TNm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYpfrL8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYpfrL8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AB81F000E9;
	Tue, 21 Jul 2026 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654894;
	bh=52L0JpzafYZUzTEidnGPb8/1vJ+GMJ7R2S1EnoElbTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYpfrL8JY3wqys0UO8vu3fkvIwmUw8wUhNVyJiK0PUZ6DftHT6H4awyOiBD2sSzKz
	 TAwDL9XjSwTTisLK8avnCfyjsoyecaZs4ZGhZO89E4Y1Jm/zw4GiaL8CuT0D2DMcYX
	 nABz/sgE+i4lKCYcYQLQTCOL4L+c3E18UFHwU1QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.1 1877/2077] scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()
Date: Tue, 21 Jul 2026 17:25:50 +0200
Message-ID: <20260721152637.000804361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1997,6 +1997,8 @@ efct_hw_io_abort(struct efct_hw *hw, str
 	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
 	if (!wqcb) {
 		efc_log_err(hw->os, "can't allocate request tag\n");
+		io_to_abort->abort_in_progress = false;
+		kref_put(&io_to_abort->ref, io_to_abort->release);
 		return -ENOSPC;
 	}
 


