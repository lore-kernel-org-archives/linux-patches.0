Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0091F1DE4CB;
	Tue,  8 Oct 2024 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394166; cv=none; b=OnsF8G8u5+e23jylauoV05pE7CxKpwbzaFeEWwbwwd7eN88inW8oyyPDZ/AxZ0iHk+kfUK0FEMQu+VAyijngu2qEFEdoi+JOFjqdB6XSZqZjl2qBQ5dnF/U/92clmtwU6aGOUeITge8Z6h+jtxlK6xXRzzpHpSwttSfIgOX3rbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394166; c=relaxed/simple;
	bh=DZOjwinwdbSAY5AAYdgMNz5tj3LuMmD53DS2eDXXlQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bncwe9LZ6I2MQ7TTM/Iz4ixkjHhW+qyzbH3c3DolDDwZD86ZAnNCIuGdTEtsEesBQqnzt7/g2EUuId+R+QT6lQQ478NtnxPfSDSeNpFNdOcG1YM4+INg4IL2+FxooX91HlpPmYbugO5tP56ACWcAPMIOwT8/pan3Y5bDBxyp6dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEYNyli5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEYNyli5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657B9C4CEC7;
	Tue,  8 Oct 2024 13:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394165;
	bh=DZOjwinwdbSAY5AAYdgMNz5tj3LuMmD53DS2eDXXlQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEYNyli5IkyHEsoPELm4kxU3xS9oo5krHeHqjMYxFfvKm514goZ05WiFQ/sbgMUR8
	 YBbQa3JmzJIa0TN8goq77KFYA5W0cNj7u2Ezj3aZXTza44bR+Ddy/2sy+AHswck4Ye
	 O6OhwfNk8oZABXJGoEDa2L0xrwJ/+DbYrmaM14VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 359/386] r8169: add tally counter fields added with RTL8125
Date: Tue,  8 Oct 2024 14:10:04 +0200
Message-ID: <20241008115643.510420473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ced8e8b8f40accfcce4a2bbd8b150aa76d5eff9a ]

RTL8125 added fields to the tally counter, what may result in the chip
dma'ing these new fields to unallocated memory. Therefore make sure
that the allocated memory area is big enough to hold all of the
tally counter values, even if we use only parts of it.

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/741d26a9-2b2b-485d-91d9-ecb302e345b5@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 27 +++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 382ba8b04cbfa..b499d8ea6d216 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -567,6 +567,33 @@ struct rtl8169_counters {
 	__le32	rx_multicast;
 	__le16	tx_aborted;
 	__le16	tx_underrun;
+	/* new since RTL8125 */
+	__le64 tx_octets;
+	__le64 rx_octets;
+	__le64 rx_multicast64;
+	__le64 tx_unicast64;
+	__le64 tx_broadcast64;
+	__le64 tx_multicast64;
+	__le32 tx_pause_on;
+	__le32 tx_pause_off;
+	__le32 tx_pause_all;
+	__le32 tx_deferred;
+	__le32 tx_late_collision;
+	__le32 tx_all_collision;
+	__le32 tx_aborted32;
+	__le32 align_errors32;
+	__le32 rx_frame_too_long;
+	__le32 rx_runt;
+	__le32 rx_pause_on;
+	__le32 rx_pause_off;
+	__le32 rx_pause_all;
+	__le32 rx_unknown_opcode;
+	__le32 rx_mac_error;
+	__le32 tx_underrun32;
+	__le32 rx_mac_missed;
+	__le32 rx_tcam_dropped;
+	__le32 tdu;
+	__le32 rdu;
 };
 
 struct rtl8169_tc_offsets {
-- 
2.43.0



