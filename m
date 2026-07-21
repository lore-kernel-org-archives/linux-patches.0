Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B03546D56D;
	Tue, 21 Jul 2026 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659044; cv=none; b=lhJw6jbxqqfv721a9FyXXTYWUtmcJP8eEpg99SmtPZf3OYouOsAYwnC0TsTKQ3tToKjYyREaICAi7BWHsa5syRLKARK0dDWi8ha1sJpY7H0rCdZJgI6pZv8XDBLBFhuEhyNXCcc44E+WZVmHh+em7WoTzCbplcI1TnV6cti5Ou4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659044; c=relaxed/simple;
	bh=rlrwNuk5iX+eKPQsWpmY5jpEPinM7706qiR5g3D4pqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpYEGa2VrUh3zQxO93ofFtI4BGnV509TxiLHkRN0KlP/4n/s09j7ikKQoKAok7Ho46lJsygyG1WAG1mGzhfU/JXdAgw1Pzh8xDRPQncEvrMXYKiztpYEHMDEzpmhpoSLla+utc8AqNO/QUsL49ID43dFait9ypWagvoSNSAIKiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWJXjJc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWJXjJc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFD01F000E9;
	Tue, 21 Jul 2026 18:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659043;
	bh=JaUGEvpGEtq8ol9UfIBMKLUw2+2GxvHk8aAK7JkRfOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWJXjJc7V2uH0tMWBMmsSxvabsqO5gfnOAZ3Rqzg0dmffb4gC8N2OpoaGdJMsNgzv
	 kGrYRMLipdk95vxAk3SHn7uVHdA/Qsdiz8k5Bew+B7/lojGM8WvNzUwgqpEnEKSAtm
	 vA4w6hnvJFFGOkW8HgZ73qU9EpGOmKF/SHT8dNVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 1372/1611] scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()
Date: Tue, 21 Jul 2026 17:24:48 +0200
Message-ID: <20260721152546.309338656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


