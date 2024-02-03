Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B0E2BB18;
	Sat,  3 Feb 2024 04:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933962; cv=none; b=ktOxjclDpbyRIQA/ASrauYytPFr/8WQpxeE/SniM1Q90QZ9115ZF8f0MWWQg7AwF0aH4eiuVfPgalYSxNYGw1xxwsy17Rl8yivn5UMhhihXOBuFpp96zc8fMrlRDoMqUQBAZO6W7u2N5BN591oHKgq6faUntGcMQwnYW/RdgTXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933962; c=relaxed/simple;
	bh=bwG7drlwkkyv1E200nlRDrEx3+ZtJqUTO3Y0dF1SuYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQzx8SNJrdf8+7vPJ4UG/Xk+LK2R02+3bWTlnqonHjHREaz/TR0emWHYEjKTqTtEcrpEhBaBR4UhBC8lqC7gIXvMAu7VcOZuyxVWAwZSQQ+wjWcubCuEGGBypoVGie+q8Lu8rRZ4Og+/OZ2p57XYXUNGM1S+Q2ehRSTsbXUf2To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZS3F2xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZS3F2xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C008C433F1;
	Sat,  3 Feb 2024 04:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933962;
	bh=bwG7drlwkkyv1E200nlRDrEx3+ZtJqUTO3Y0dF1SuYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZS3F2xs8qgFRpPkwGAAqo7HzPWEbA1yUTwBa7Mmf0AUHzKJ/focmP6IidgciLsR1
	 RBSdRoq5kKQoMYclDZNDunE9ksYR2qfxz598QgKk5+ZGlS0gVY5jYDRVzvy6efmv60
	 3hS6nT37IxVMHxN4glnsdzGurykEn8+O2TdhZfw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 332/353] pds_core: Cancel AQ work on teardown
Date: Fri,  2 Feb 2024 20:07:30 -0800
Message-ID: <20240203035414.291656602@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 0d2091e9eb28..b582729331eb 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -464,6 +464,8 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
+	if (pdsc->adminqcq.work.func)
+		cancel_work_sync(&pdsc->adminqcq.work);
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
-- 
2.43.0



