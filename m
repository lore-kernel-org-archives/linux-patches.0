Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BC1372EDE;
	Wed, 20 May 2026 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297050; cv=none; b=lRp5LwM+AbWQ1dWYXwlKrgS2wWodn17g6xnhlMHd//Sszrb+h5EuAc9tJWMBHn8toFpUNHXM/tQ0imIa4py3Htozja1liY1MUVsTSoF5+GkKg7SgznRQZSFQpQfdciaGYMNM/GdephCvl+70Zziebumc2JB9yjFGvDPGO1fewog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297050; c=relaxed/simple;
	bh=fztoqgVzaIesVqWX6NsaxAemvlKWppfrdjRrsN/4Qak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swFEMBGX1i8xt1MjnKFGmLu+oNZFZnNmKW9tEHHVvPCGguVScWsu4py1+VpJMbaebnO7kqKdC1W2zESJhdZNd7eJRBnJPD1+ujz3T5NuCjs41O+Q5hZsOlCp8FDRiHqxdtzJ8neE7dUaME+T2fS7uEuzTiRYl3Kegc0mrtFEtM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1pDocAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1pDocAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743221F000E9;
	Wed, 20 May 2026 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297048;
	bh=SBEiP+RYS8h2pigGj3pbIJQi/0TR1ahe4Jrx9hZvsJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1pDocAVXC4viYjDrle/psOpkEcAxajsjQ8T1RuYPu9uGWsNTTd8dia8brn74C1qD
	 +0WCZEgvZOxdOVpmKqh6Tn2jJzbN5ppN/AE8Y+sOmwNKo0pVJygA5hIA9odaBZo32K
	 UAE1YPkvJkDmC/gsg+RzJNkm4A9a2mRunQ1raM3c=
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
Subject: [PATCH 7.0 1030/1146] ice: add dpll peer notification for paired SMA and U.FL pins
Date: Wed, 20 May 2026 18:21:20 +0200
Message-ID: <20260520162211.539255464@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 721a3f4d6a28f..27b460926bace 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -1154,6 +1154,32 @@ ice_dpll_input_state_get(const struct dpll_pin *pin, void *pin_priv,
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
@@ -1344,6 +1370,8 @@ ice_dpll_ufl_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 
 unlock:
 	mutex_unlock(&pf->dplls.lock);
+	if (!ret)
+		ice_dpll_sw_pin_notify_peer(&pf->dplls, p);
 
 	return ret;
 }
@@ -1462,6 +1490,8 @@ ice_dpll_sma_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 
 unlock:
 	mutex_unlock(&pf->dplls.lock);
+	if (!ret)
+		ice_dpll_sw_pin_notify_peer(&pf->dplls, sma);
 
 	return ret;
 }
@@ -1657,6 +1687,8 @@ ice_dpll_pin_sma_direction_set(const struct dpll_pin *pin, void *pin_priv,
 	mutex_lock(&pf->dplls.lock);
 	ret = ice_dpll_sma_direction_set(p, direction, extack);
 	mutex_unlock(&pf->dplls.lock);
+	if (!ret)
+		ice_dpll_sw_pin_notify_peer(&pf->dplls, p);
 
 	return ret;
 }
-- 
2.53.0



