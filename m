Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591021;
	b=rxGdWgrp7VHb+lYE5QpgOnr5zLre4RegIVRHE0BxowfCFRZKSC/o1+gpp86A4xs5OjbJ
	 yRAd1P7kspJ5wyCue6hUGt/i9boGzziqctmV8q5cOIYrUXMFnw/mMKbryuBOv4s5+5Eoz
	 t6iIOswB6TRZfdKouYHOXR0ZlOtKxZiXlJG+PeiDRU5+O+vDQ+C+QprnB5dpPg0W+2ULf
	 EyhP/KgwM7IZ3jelzVCGrOqna5q+ZMvVku5f2ng6Zp+qYkAoX28pUw/q8Ax3F7nKh70Aq
	 HO3V9UkuUuReDcRBfb9O8353N6QXkuEZKzBi5hYLrkFc2krPLsbQ9NXVuO2f/r7vYzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=99aAJg22zZzTFba6W6nVgC+vsEcMwzz2DHQClf+Ob00=;
	b=1xmNRt7AhIdvBJw04Ug5KOBo3jIvYx74Y/vbVSKfnjhhUMXJ+/70tX4OWq9eBvVMX/LJ
	 TvdmLhvOkm/Ll+PMoeZfmmBhIIg7pT6UbGgYF1Gd60dPFx3C3vrXCVs/M1qfO98UoHGwo
	 ViEcuwQC/EvmUu2JbkL81Fhbh0hlizdxHL7L78007iAFrKNB5Tb3PB80Vvk/fJNwa1Ofo
	 2G3pvcnYr/cghIVkM24YovgA/je3HGFm+HA51+n1SCloLivx2kErAHzf6H7OEfLEQ9+85
	 TW4g1nAwZsU6S69PMdUMWK1hqxeOFgELEgmkiDrvqDcY6Cpx30UjA6IIkTkGr9QXGag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iylLK0AL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4185D6070F3E;
	Fri, 13 Nov 2026 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iylLK0AL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0961F000C6;
	Fri, 13 Nov 2026 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591021;
	bh=99aAJg22zZzTFba6W6nVgC+vsEcMwzz2DHQClf+Ob00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iylLK0ALsxDXul9NlXSWO73ux7pkIOeeMC66DmIq0kRrwTSs3sDHphBFTl8nzUQy9
	 +ZsR5ykiWAk3PCanuNS+hOhhRvEw/OdxfdHc8z+ookigOlFvZmCYWXBLsRc8qX5KNR
	 p9odt0ETgfe7ixlIc2BX9dfyK5fT7+C+BBRRItIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/670] wifi: rsi: Skip TX aggregation setup for non-QoS frames
Date: Fri, 13 Nov 2026 10:45:51 -0500
Message-ID: <20261113153818.352983654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 71f756a4c064b0312f46617c20893ecc17c332e4 ]

When transmitting a non-QoS unicast frame to a station in AP mode,
rsi_core_xmit() assigns IEEE80211_NONQOS_TID (16) to tid. The station
lookup succeeds, allowing tid to index start_tx_aggr[], which has only
IEEE80211_NUM_TIDS (16) elements. This causes an out-of-bounds read and,
if the value read is zero, an out-of-bounds write.

Only access the aggregation state for tids below IEEE80211_NUM_TIDS,
excluding the non-QoS sentinel from TX aggregation setup.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 19844c0a9a19 ("rsi: data and managemet path changes for AP mode")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261015072010.742369-1-a.kazinsky@ideco.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index ead4d4e043280..3281fc94e1078 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -458,7 +458,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			tx_params->sta_id = 0;
 		}
 
-		if (rsta) {
+		if (rsta && tid < IEEE80211_NUM_TIDS) {
 			/* Start aggregation if not done for this tid */
 			if (!rsta->start_tx_aggr[tid]) {
 				rsta->start_tx_aggr[tid] = true;
-- 
2.53.0



