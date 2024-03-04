Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158411F5FD;
	Mon,  4 Mar 2024 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587589; cv=none; b=ZQjVXJs2tJB8x79exXhuK0chTcxcq87My2WLnvovTBW7JtLyhVFVhjuOG3Kg7JI2At408J35GHTvlR2Pz6jO4R0sQ2tL2aH75x64ofh5W/UPq1Us8L++e7ZAnKtB+Qp1lk8zMTBe4d7N82t/IxurCrWhTNfdewV4XM8tcxEDL/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587589; c=relaxed/simple;
	bh=953cv5A9yd1ap6C3pCE8hbVFD2VVSET6sC7owSfQdY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0+Ep0Id4nwuYDpP63mX6IrBKEeVxon27b/acCilBnHPeS8cFAdb8p/0gUk54zV/i6vw5h8IrLbYbHjrfdDzMYcLMKPYBRm/LLsYEqvPPmsKcyqSpRfq2FARQUMfcjAr6e0odFOavkFqrmxSnM8MkEbk6mXHl/RuAmOy46rAAqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TapBc6+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TapBc6+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7D0C433F1;
	Mon,  4 Mar 2024 21:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587589;
	bh=953cv5A9yd1ap6C3pCE8hbVFD2VVSET6sC7owSfQdY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TapBc6+sGJ/ERxw9ztZ/5TDJk+ClNSM3I/T02XSsSx+W/r9RFboEvXWt3AemX36I2
	 sG/Cj+aL2GFgLq+1UM7/IT/vktfOP0IYeK8o7+IxhaMtke3hJ+SUa/dTOi7LM1XyPa
	 PqPz/IqFEXCLT4tGplQ1Emga4VxavzudAuFiqviw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Bagnucki <igor.bagnucki@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.7 006/162] ice: fix dpll periodic work data updates on PF reset
Date: Mon,  4 Mar 2024 21:21:11 +0000
Message-ID: <20240304211552.041076822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 9a8385fe14bcb250a3889e744dc54e9c411d8400 ]

Do not allow dpll periodic work function to acquire data from firmware
if PF reset is in progress. Acquiring data will cause dmesg errors as the
firmware cannot respond or process the request properly during the reset
time.

Test by looping execution of below step until dmesg error appears:
- perform PF reset
$ echo 1 > /sys/class/net/<ice PF>/device/reset

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Reviewed-by: Igor Bagnucki <igor.bagnucki@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 9c8be237c7e50..bcb9b9c13aabc 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -1390,8 +1390,10 @@ static void ice_dpll_periodic_work(struct kthread_work *work)
 	struct ice_pf *pf = container_of(d, struct ice_pf, dplls);
 	struct ice_dpll *de = &pf->dplls.eec;
 	struct ice_dpll *dp = &pf->dplls.pps;
-	int ret;
+	int ret = 0;
 
+	if (ice_is_reset_in_progress(pf->state))
+		goto resched;
 	mutex_lock(&pf->dplls.lock);
 	ret = ice_dpll_update_state(pf, de, false);
 	if (!ret)
@@ -1411,6 +1413,7 @@ static void ice_dpll_periodic_work(struct kthread_work *work)
 	ice_dpll_notify_changes(de);
 	ice_dpll_notify_changes(dp);
 
+resched:
 	/* Run twice a second or reschedule if update failed */
 	kthread_queue_delayed_work(d->kworker, &d->work,
 				   ret ? msecs_to_jiffies(10) :
-- 
2.43.0



