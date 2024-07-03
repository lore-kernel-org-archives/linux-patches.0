Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55A818131D;
	Wed,  3 Jul 2024 10:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003414; cv=none; b=G+ytqNcROoUvySIxEflcvhrWiPPdpVwOjYgXTs44la4L3ulOGO08MP6F5WJRw0bFumI2j+Wzl54luqRGOkbxaQsYlsakPlPY5bFY19iz3eUtFB/V73OTlCCBUxmyC7+s+uYWJqu9NAtU3V8t1jTBpYoP3YguleGcPZM9gtaIG8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003414; c=relaxed/simple;
	bh=b1Qg/vRW3VWNgvArkD6jXHRH3OGGiZokysspEE0jWBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmmexVDY6hRF5o/1+UlV/hsHetLxdpfNx7LcW6bxH5s9BUTF8Yv3yxKRd7v8RVokI0Qw6U0IQPOZNMUvCvYCvZC3twJLdGgia5jCzIbefEeVmGLSn4bc8bWiVUXcfn8liGoeNd0zTRc5dNxMD7+blJ9SHdT5FFZwiEAu4NfAb1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJr/AYpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJr/AYpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B58BC2BD10;
	Wed,  3 Jul 2024 10:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003414;
	bh=b1Qg/vRW3VWNgvArkD6jXHRH3OGGiZokysspEE0jWBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJr/AYpQk6L8aCoWG+Td78mrz/B8bATbY199PxtVBIIBO0umLDXb/CQWRtalJT/A9
	 BuNjW4HR7bE7HDpg9oLMOs6eX5odBHRWZkLAn5VrY6Rmlx+Icn9Jc2qfUHxp3wKpPo
	 7GY2XfOjPQ/RgWfXJE81/I0Qb8gpvz6fTb+8G3es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/139] Bluetooth: L2CAP: Fix rejecting L2CAP_CONN_PARAM_UPDATE_REQ
Date: Wed,  3 Jul 2024 12:38:58 +0200
Message-ID: <20240703102831.990107025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 878e7e92d8efd..7aa8e8e615812 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1430,18 +1430,46 @@ static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
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
index 3c6e72c4fdde3..3f9b2b4a62ffd 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5316,13 +5316,7 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 
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



