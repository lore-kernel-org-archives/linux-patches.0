Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637DE200D4;
	Mon,  4 Mar 2024 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587586; cv=none; b=Oqo4ttgzkRgO6TPhR6lWj0fUpLrHcIp7OmCsyr8TQyaHDVDL+SZyb9K3St6lu25uHBOQwaZmvs80H4dfzGSKuGnEWNelB/tJFGdcJstWNj/h4uuLq0MXp27a5ZDkU+GqPI9ixyVwJky0sIGO2REGo35cQUuO+nR8NaHP2QxbXQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587586; c=relaxed/simple;
	bh=THeIalGhQ2OR4X0CYzX0Zg4dwUGww1Ai4hM+Ql4zDdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjX5gukwPjsbeYFso94O0m+P12aj1vyN0iznO7PM6DSs/ot1yV2pqHwYhrJu/B2PDSNT3JEHSt438hpf0bKit52UxHqKYWv/uMDn1L/S/DOdyWKvVArzDQYoxyqF3dWhV+9tDrw9wJrRKyccGAJKmgHwlHyVVf9JwXToIdrRT3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHuLEMzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHuLEMzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED04AC433F1;
	Mon,  4 Mar 2024 21:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587586;
	bh=THeIalGhQ2OR4X0CYzX0Zg4dwUGww1Ai4hM+Ql4zDdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHuLEMzF9Fhgpy5wEH5MFsrZafGkjIa10gfV2oaBwseE+cVHjIB8/GZE5Sg2yoIE0
	 +i07DKKhLFX8UsQdqQrBUSv3TZt0rqx39whSUq+WY/K9gIiLP3a+E5VOPFp5EJWyGz
	 OJLVoq9mpzz5YHUMPtGOiz5XMh3L74gPfzWXpXNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.7 005/162] ice: fix dpll and dpll_pin data access on PF reset
Date: Mon,  4 Mar 2024 21:21:10 +0000
Message-ID: <20240304211552.013654515@linuxfoundation.org>
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

[ Upstream commit fc7fd1a10a9d2d38378b42e9a508da4c68018453 ]

Do not allow to acquire data or alter configuration of dpll and pins
through firmware if PF reset is in progress, this would cause confusing
netlink extack errors as the firmware cannot respond or process the
request properly during the reset time.

Return (-EBUSY) and extack error for the user who tries access/modify
the config of dpll/pin through firmware during the reset time.

The PF reset and kernel access to dpll data are both asynchronous. It is
not possible to guard all the possible reset paths with any determinictic
approach. I.e., it is possible that reset starts after reset check is
performed (or if the reset would be checked after mutex is locked), but at
the same time it is not possible to wait for dpll mutex unlock in the
reset flow.
This is best effort solution to at least give a clue to the user
what is happening in most of the cases, knowing that there are possible
race conditions where the user could see a different error received
from firmware due to reset unexpectedly starting.

Test by looping execution of below steps until netlink error appears:
- perform PF reset
$ echo 1 > /sys/class/net/<ice PF>/device/reset
- i.e. try to alter/read dpll/pin config:
$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml \
	--dump pin-get

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 38 +++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 10a469060d322..9c8be237c7e50 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -30,6 +30,26 @@ static const char * const pin_type_name[] = {
 	[ICE_DPLL_PIN_TYPE_RCLK_INPUT] = "rclk-input",
 };
 
+/**
+ * ice_dpll_is_reset - check if reset is in progress
+ * @pf: private board structure
+ * @extack: error reporting
+ *
+ * If reset is in progress, fill extack with error.
+ *
+ * Return:
+ * * false - no reset in progress
+ * * true - reset in progress
+ */
+static bool ice_dpll_is_reset(struct ice_pf *pf, struct netlink_ext_ack *extack)
+{
+	if (ice_is_reset_in_progress(pf->state)) {
+		NL_SET_ERR_MSG(extack, "PF reset in progress");
+		return true;
+	}
+	return false;
+}
+
 /**
  * ice_dpll_pin_freq_set - set pin's frequency
  * @pf: private board structure
@@ -109,6 +129,9 @@ ice_dpll_frequency_set(const struct dpll_pin *pin, void *pin_priv,
 	struct ice_pf *pf = d->pf;
 	int ret;
 
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+
 	mutex_lock(&pf->dplls.lock);
 	ret = ice_dpll_pin_freq_set(pf, p, pin_type, frequency, extack);
 	mutex_unlock(&pf->dplls.lock);
@@ -609,6 +632,9 @@ ice_dpll_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 	struct ice_pf *pf = d->pf;
 	int ret;
 
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+
 	mutex_lock(&pf->dplls.lock);
 	if (enable)
 		ret = ice_dpll_pin_enable(&pf->hw, p, d->dpll_idx, pin_type,
@@ -712,6 +738,9 @@ ice_dpll_pin_state_get(const struct dpll_pin *pin, void *pin_priv,
 	struct ice_pf *pf = d->pf;
 	int ret;
 
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+
 	mutex_lock(&pf->dplls.lock);
 	ret = ice_dpll_pin_state_update(pf, p, pin_type, extack);
 	if (ret)
@@ -836,6 +865,9 @@ ice_dpll_input_prio_set(const struct dpll_pin *pin, void *pin_priv,
 	struct ice_pf *pf = d->pf;
 	int ret;
 
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+
 	mutex_lock(&pf->dplls.lock);
 	ret = ice_dpll_hw_input_prio_set(pf, d, p, prio, extack);
 	mutex_unlock(&pf->dplls.lock);
@@ -1115,6 +1147,9 @@ ice_dpll_rclk_state_on_pin_set(const struct dpll_pin *pin, void *pin_priv,
 	int ret = -EINVAL;
 	u32 hw_idx;
 
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+
 	mutex_lock(&pf->dplls.lock);
 	hw_idx = parent->idx - pf->dplls.base_rclk_idx;
 	if (hw_idx >= pf->dplls.num_inputs)
@@ -1169,6 +1204,9 @@ ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *pin, void *pin_priv,
 	int ret = -EINVAL;
 	u32 hw_idx;
 
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+
 	mutex_lock(&pf->dplls.lock);
 	hw_idx = parent->idx - pf->dplls.base_rclk_idx;
 	if (hw_idx >= pf->dplls.num_inputs)
-- 
2.43.0



