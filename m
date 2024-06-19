Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464A6132129;
	Wed, 19 Jun 2024 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802391; cv=none; b=Mcf12BMuoGE9QYGAxOlYpn8lYbSD7s96AVzFLw7KLBKRqZz2osVJCi15lhFusZz7Bx1QaktRvb2Q1L410FIvkgkcyOOT3Z/ROMrlM4VpGcJCypsZ6IcOsZ4mDH5qxhg65ATiwA38t4hePOnUik4R/tz+6mtmmwywGihr0iG0wuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802391; c=relaxed/simple;
	bh=JmEo4Qs4L8sIOotB0vKCpKNFGExS/3l4zTWVZL8aBRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFF45BVSVlmKYsn0vhu5T7X6guXrgZYV9S2uut2vAVi+PcG8BbmN5yxZmsuAPBLy3ahi01m+uMgGm0dZSTX2GFj+9dD+ZTuTjomR04uv42qVvsXodneTPgxxNiNuJlgJD96FHgScQ+MnoqMCDQoX5I2j1MrrUizFTbyaK7eNMeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOqUsEpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOqUsEpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEA8C2BBFC;
	Wed, 19 Jun 2024 13:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802391;
	bh=JmEo4Qs4L8sIOotB0vKCpKNFGExS/3l4zTWVZL8aBRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOqUsEpONC2WqeLoV/FJlPklzPWugJ73ZKu1sBktenr2u45hv4arwl+vjc3vxgRV9
	 YaAROpVVQ9RTz5WleOw8e+3fwGelPU0zOmzsxORyaLkPFa+2KucypqkzRexy/6Vy+m
	 nYd+s0NbxqwYyXua+jkFukDk+EKzBReT77AyIo3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/267] Bluetooth: L2CAP: Fix rejecting L2CAP_CONN_PARAM_UPDATE_REQ
Date: Wed, 19 Jun 2024 14:55:04 +0200
Message-ID: <20240619125612.217481349@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 806a5198c05987b748b50f3d0c0cfb3d417381a4 ]

This removes the bogus check for max > hcon->le_conn_max_interval since
the later is just the initial maximum conn interval not the maximum the
stack could support which is really 3200=4000ms.

In order to pass GAP/CONN/CPUP/BV-05-C one shall probably enter values
of the following fields in IXIT that would cause hci_check_conn_params
to fail:

TSPX_conn_update_int_min
TSPX_conn_update_int_max
TSPX_conn_update_peripheral_latency
TSPX_conn_update_supervision_timeout

Link: https://github.com/bluez/bluez/issues/847
Fixes: e4b019515f95 ("Bluetooth: Enforce validation on max value of connection interval")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 36 ++++++++++++++++++++++++++++----
 net/bluetooth/l2cap_core.c       |  8 +------
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index f786d2d62fa5e..f89d6d43ba8f1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2071,18 +2071,46 @@ static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
 {
 	u16 max_latency;
 
-	if (min > max || min < 6 || max > 3200)
+	if (min > max) {
+		BT_WARN("min %d > max %d", min, max);
 		return -EINVAL;
+	}
+
+	if (min < 6) {
+		BT_WARN("min %d < 6", min);
+		return -EINVAL;
+	}
+
+	if (max > 3200) {
+		BT_WARN("max %d > 3200", max);
+		return -EINVAL;
+	}
+
+	if (to_multiplier < 10) {
+		BT_WARN("to_multiplier %d < 10", to_multiplier);
+		return -EINVAL;
+	}
 
-	if (to_multiplier < 10 || to_multiplier > 3200)
+	if (to_multiplier > 3200) {
+		BT_WARN("to_multiplier %d > 3200", to_multiplier);
 		return -EINVAL;
+	}
 
-	if (max >= to_multiplier * 8)
+	if (max >= to_multiplier * 8) {
+		BT_WARN("max %d >= to_multiplier %d * 8", max, to_multiplier);
 		return -EINVAL;
+	}
 
 	max_latency = (to_multiplier * 4 / max) - 1;
-	if (latency > 499 || latency > max_latency)
+	if (latency > 499) {
+		BT_WARN("latency %d > 499", latency);
 		return -EINVAL;
+	}
+
+	if (latency > max_latency) {
+		BT_WARN("latency %d > max_latency %d", latency, max_latency);
+		return -EINVAL;
+	}
 
 	return 0;
 }
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 37210567fbfbe..d5fb78c604cf3 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4645,13 +4645,7 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 
 	memset(&rsp, 0, sizeof(rsp));
 
-	if (max > hcon->le_conn_max_interval) {
-		BT_DBG("requested connection interval exceeds current bounds.");
-		err = -EINVAL;
-	} else {
-		err = hci_check_conn_params(min, max, latency, to_multiplier);
-	}
-
+	err = hci_check_conn_params(min, max, latency, to_multiplier);
 	if (err)
 		rsp.result = cpu_to_le16(L2CAP_CONN_PARAM_REJECTED);
 	else
-- 
2.43.0



