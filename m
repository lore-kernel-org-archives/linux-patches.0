Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE3110A11;
	Sat,  3 Feb 2024 04:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933700; cv=none; b=lhUPEyiV4Gu/v4u1SZKa8o+cNoFyJzAwmskpjyGXBkMF8nyTjsb2inecelr4QY1D/GXxLAOjUh3dkWzsCFQ9RxWHWKrOW7n6s5iLnDMt2qKPk7SdpT02kiaxwdaSbm/FLQUtzp/hHhlPOGgDUW79byG9t5mwEIfJesPhRx8qiy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933700; c=relaxed/simple;
	bh=CxGplyRoRQuBZ2QVJMYq5Qbj1qKQP8ki6JAGYt/3m8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCsT5hZKc9Yz4RntOdyint/vnl2eSsiVukrdiLrESl0LOMguhI3087jQp7EqfjS3Pq3NzeJAj6KogIIcVw8Y1lmxeVBv2Ug9K9HDySVa8c7ecCDggJ4Vaqr/Pb5yEkFvcNQAwTQ4w5d9YtKkbdrscYb82fRKcaMimGb63tiVYGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tvrc6WO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tvrc6WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B6FC43390;
	Sat,  3 Feb 2024 04:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933700;
	bh=CxGplyRoRQuBZ2QVJMYq5Qbj1qKQP8ki6JAGYt/3m8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tvrc6WOH5NMiAzAYDOi69MLg7Wjvn5J1LK1lTpv7A/49KUk5dQlaWSsrtnqIZhg9
	 XivUTmUdv/csq9PXyesJD/bTy61+FxrXcVGBRHw+wz3gUFnkIHvtEE7SIfSziNQFwf
	 4quYfRItQ2ivGS89PL8pxY7XCZBX9mI3LjfocZEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/322] pds_core: Cancel AQ work on teardown
Date: Fri,  2 Feb 2024 20:06:37 -0800
Message-ID: <20240203035408.754497498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit d321067e2cfa4d5e45401a00912ca9da8d1af631 ]

There is a small window where pdsc_work_thread()
calls pdsc_process_adminq() and pdsc_process_adminq()
passes the PDSC_S_STOPPING_DRIVER check and starts
to process adminq/notifyq work and then the driver
starts a fw_down cycle. This could cause some
undefined behavior if the notifyqcq/adminqcq are
free'd while pdsc_process_adminq() is running. Use
cancel_work_sync() on the adminqcq's work struct
to make sure any pending work items are cancelled
and any in progress work items are completed.

Also, make sure to not call cancel_work_sync() if
the work item has not be initialized. Without this,
traces will happen in cases where a reset fails and
teardown is called again or if reset fails and the
driver is removed.

Fixes: 01ba61b55b20 ("pds_core: Add adminq processing and commands")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20240129234035.69802-3-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 36f9b932b9e2..b58c166d438d 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -466,6 +466,8 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
+	if (pdsc->adminqcq.work.func)
+		cancel_work_sync(&pdsc->adminqcq.work);
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
-- 
2.43.0



