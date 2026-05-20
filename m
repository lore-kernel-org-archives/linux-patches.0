Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755773F1AD9;
	Wed, 20 May 2026 17:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299649; cv=none; b=VBx59qgE1y7h/NwgZHTGASMVrRHjRSR2dwaNNPelW6/A5RmtQvFYug8lMfKlTNaWjpgD1wUtgTmCekQjUaiOFf+t2zkRU9MpjxrmQtUgKEZmxm7MMOI4n4/Nfy01cwLn+XmPD/0UI2M6IET2gBX5eCXR+C6NAeXPfi8Zr4h8ZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299649; c=relaxed/simple;
	bh=YCFD0TeZM1/ATmo0z/F7feyS6KZssgOnSuW3z6EfOyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg2X5MYHZO+tut2sRc5sS3uTSrhOX6619f8AovdoJ0F2X0AqYcLcd20rSVQ6hQBxtXLW6Gfg2MxiIPZdS55yGjlPjNFxMBCJEbZXbcRhfaGWWjyVT+pWSJGgCSI9yE8kEcp5KqkwSZ9VNrXPfm1nAaqCzDLJhs16zVX0w+v8uD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neB64u04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neB64u04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E4C1F000E9;
	Wed, 20 May 2026 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299647;
	bh=I0hOxCQHb9CMjApu/zcaoQWu8HJyKYuz+8YhQC4NZAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neB64u0495UYuWc5Uf2UoLNLHNiwlqrHjrx/qHiT8TaaKpYsr18E2xnruzC0YuEPf
	 6poZ7OJQuhHFVkjJjla1b8yNoLg8+QXgzHVo8LEPMrxp4THPdUINrFKBAOhPZchXd2
	 Zr0rrOC/LiObTLUtbYPSos4gq7sRX8Zf4VbsThII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 853/957] ice: add dpll peer notification for paired SMA and U.FL pins
Date: Wed, 20 May 2026 18:22:16 +0200
Message-ID: <20260520162153.065000567@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Petr Oros <poros@redhat.com>

[ Upstream commit 9e5dead140af10e8b5f975b8f04e46197d48d274 ]

SMA and U.FL pins share physical signal paths in pairs (SMA1/U.FL1 and
SMA2/U.FL2).  When one pin's state changes via a PCA9575 GPIO write,
the paired pin's state also changes, but no notification is sent for
the peer pin.  Userspace consumers monitoring the peer via dpll netlink
subscribe never learn about the update.

Add ice_dpll_sw_pin_notify_peer() which sends a change notification for
the paired SW pin.  Call it from ice_dpll_pin_sma_direction_set(),
ice_dpll_sma_pin_state_set(), and ice_dpll_ufl_pin_state_set() after
pf->dplls.lock is released.  Use __dpll_pin_change_ntf() because
dpll_lock is still held by the dpll netlink layer (dpll_pin_pre_doit).

Fixes: 2dd5d03c77e2 ("ice: redesign dpll sma/u.fl pins control")
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-11-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index baf492f5c4925..14048ac5eff56 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -1073,6 +1073,32 @@ ice_dpll_input_state_get(const struct dpll_pin *pin, void *pin_priv,
 				      extack, ICE_DPLL_PIN_TYPE_INPUT);
 }
 
+/**
+ * ice_dpll_sw_pin_notify_peer - notify the paired SW pin after a state change
+ * @d: pointer to dplls struct
+ * @changed: the SW pin that was explicitly changed (already notified by dpll core)
+ *
+ * SMA and U.FL pins share physical signal paths in pairs (SMA1/U.FL1 and
+ * SMA2/U.FL2).  When one pin's routing changes via the PCA9575 GPIO
+ * expander, the paired pin's state may also change.  Send a change
+ * notification for the peer pin so userspace consumers monitoring the
+ * peer via dpll netlink learn about the update.
+ *
+ * Context: Called from dpll_pin_ops callbacks after pf->dplls.lock is
+ *          released.  Uses __dpll_pin_change_ntf() because dpll_lock is
+ *          still held by the dpll netlink layer.
+ */
+static void ice_dpll_sw_pin_notify_peer(struct ice_dplls *d,
+					struct ice_dpll_pin *changed)
+{
+	struct ice_dpll_pin *peer;
+
+	peer = (changed >= d->sma && changed < d->sma + ICE_DPLL_PIN_SW_NUM) ?
+		&d->ufl[changed->idx] : &d->sma[changed->idx];
+	if (peer->pin)
+		__dpll_pin_change_ntf(peer->pin);
+}
+
 /**
  * ice_dpll_sma_direction_set - set direction of SMA pin
  * @p: pointer to a pin
@@ -1263,6 +1289,8 @@ ice_dpll_ufl_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 
 unlock:
 	mutex_unlock(&pf->dplls.lock);
+	if (!ret)
+		ice_dpll_sw_pin_notify_peer(&pf->dplls, p);
 
 	return ret;
 }
@@ -1381,6 +1409,8 @@ ice_dpll_sma_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 
 unlock:
 	mutex_unlock(&pf->dplls.lock);
+	if (!ret)
+		ice_dpll_sw_pin_notify_peer(&pf->dplls, sma);
 
 	return ret;
 }
@@ -1576,6 +1606,8 @@ ice_dpll_pin_sma_direction_set(const struct dpll_pin *pin, void *pin_priv,
 	mutex_lock(&pf->dplls.lock);
 	ret = ice_dpll_sma_direction_set(p, direction, extack);
 	mutex_unlock(&pf->dplls.lock);
+	if (!ret)
+		ice_dpll_sw_pin_notify_peer(&pf->dplls, p);
 
 	return ret;
 }
-- 
2.53.0



