Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD53364EBB;
	Tue, 16 Dec 2025 12:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887024; cv=none; b=gVH8SWpZm8DaR8M5YiXUPZIVpclWV+heWvzK2GSRyK3JcoWmFf18H30dymI4euQXXJM27So0lV5XlR7Lpvs/bLvy547uLfeHaEm8WLZRbECVBgm2UtIxsqo2fmtKIAQh0dAXAs7JGW6l6aB5ANPQA3W1M456r63AWUyyKCrUrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887024; c=relaxed/simple;
	bh=GzvTFH3FB58w8S9/DCzkrC3EI9J98HidOONCQiRZNJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8w4xUIyvMuFkmPPjAj6GkfO5rZ+oe6glbWW3fLEEKLBipcwr2z3QmmnyKnR7gO1HIwYwqZyCB5Jqsctb6M+aUw9kEhV92TA8Amy/kIJ/7Nfar6Pa3/2/uc6pPciZosGKTRlK6Wx1YCvtJPgyozPULCoKOxrRq3F5yCxZ94VhqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAh0YdpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAh0YdpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39465C4CEF1;
	Tue, 16 Dec 2025 12:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887024;
	bh=GzvTFH3FB58w8S9/DCzkrC3EI9J98HidOONCQiRZNJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAh0YdpYijK8iO0ML8zqDjDqVHX18PzYtF3aef3K0cuIMTKTzKV596BAH06IKAgnm
	 j5FlD16ov8z4JYyrgBDVcmu0oTKbX9n1fFUnyN8M4l140xMYAFYWUmFxgPBGmMoFGB
	 /8QN/q2nRfhsvetZL60I0W6O/luwH27JTul/zZpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 105/614] ice: remove duplicate call to ice_deinit_hw() on error paths
Date: Tue, 16 Dec 2025 12:07:52 +0100
Message-ID: <20251216111405.140281583@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 1390b8b3d2bef9bfbb852fc735430798bfca36e7 ]

Current unwinding code on error paths of ice_devlink_reinit_up() and
ice_probe() have manual call to ice_deinit_hw() (which is good, as there
is also manual call to ice_hw_init() there), which is then duplicated
(and was prior current series) in ice_deinit_dev().

Fix the above by removing ice_deinit_hw() from ice_deinit_dev().
Add a (now missing) call in ice_remove().

Reported-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/intel-wired-lan/20250717-jk-ddp-safe-mode-issue-v1-1-e113b2baed79@intel.com/
Fixes: 4d3f59bfa2cd ("ice: split ice_init_hw() out from ice_init_dev()")
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f1ebdb7dbdc73..b0f8a96c13b47 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4784,7 +4784,6 @@ int ice_init_dev(struct ice_pf *pf)
 
 void ice_deinit_dev(struct ice_pf *pf)
 {
-	ice_deinit_hw(&pf->hw);
 	ice_service_task_stop(pf);
 
 	/* Service task is already stopped, so call reset directly. */
@@ -5466,6 +5465,7 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_set_wake(pf);
 
 	ice_adapter_put(pdev);
+	ice_deinit_hw(&pf->hw);
 
 	ice_deinit_dev(pf);
 	ice_aq_cancel_waiting_tasks(pf);
-- 
2.51.0



