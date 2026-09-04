Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF7726159E;
	Fri,  4 Sep 2026 06:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502486; cv=none; b=DVKx9j6PO46HA5gXLGq5Z1WJQjTHqzlF/JlmoUhK1b5v+ZHyi9sf4JMPKIl2/tasjL/Y1UQ6w85Q2c1Zh2e+Hng5ueU0p19QVT5whXQNV2d1DoysChXD0YOQnDPCHal1o5PJ2wqeKMPxBG07gYrb+s85G07P5GAF9GjEI01/3+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502486; c=relaxed/simple;
	bh=Kh2In1rvu7BWR3JOAtuG8fwr9wxa8Bodr2PnDZZ/vH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzxyPzCllvuTcY/eJo2F8bKAWvWi/2RlHP+jS4+h3yb8jTWg49ONPXYRwhiMQSxLwFS+g4YIQY34QxEk0irRXS4ME3DWy1NZPwVZuuATS8eZOpqxQt5cpEi8phiF+xZS8Ut1Cw5nUFQUMg/ORXUH1t4xNLFyt/MaKrUusSDmlrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hq+gFCB8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hq+gFCB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A1D1F00A3D;
	Fri,  4 Sep 2026 06:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502485;
	bh=KjP1gT8fxWlETFyvj4uboi0h/h/sNmE16BRSAXsD2rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hq+gFCB8t4hWDBS0Z8Nhy6vamF6SwX/nk0FEmXBK93fJNKvLEj/HpZVlCOysBUZWd
	 I+lUFMHDHPGljP6hjduMqVraiJhvpSG281tujyi5WrUG2xAk8BLkslbn7E+jyW1zb/
	 NOKAG9w5phLBYuIzJLmmZ/Yli1ro69uOfchlJsHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.12 222/403] wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets
Date: Fri,  4 Sep 2026 07:00:25 +0200
Message-ID: <20260904045739.913480846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 3bbd05723d15dd06f0560bcd94fbf9a91b5f5613 upstream.

ath6kl_cfg80211_connect_event() subtracts fixed IE offsets from
assoc_req_len (-= 4) and assoc_resp_len (-= 6), both u8, with no lower
bound. The aggregate check recently added to ath6kl_wmi_connect_event_rx()
bounds the declared lengths from above (their sum must fit the received
event), but an assoc request/response shorter than its fixed offset still
underflows here: the u8 wraps to ~250, and cfg80211_connect_result() /
cfg80211_roamed() then treat that wrapped value as the IE length and copy
that many bytes out of the small assoc_info buffer to user space via
nl80211, disclosing adjacent slab memory.

Clamp both lengths to their offsets before subtracting.

Found by 0sec (https://0sec.ai) using automated source analysis; the
missing lower bound is evident from source. Compile-tested.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Link: https://patch.msgid.link/20260713213251.21161-1-doruk@0sec.ai
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -753,6 +753,11 @@ void ath6kl_cfg80211_connect_event(struc
 	u8 *assoc_resp_ie = assoc_info + beacon_ie_len + assoc_req_len +
 	    assoc_resp_ie_offset;
 
+	if (assoc_req_len < assoc_req_ie_offset)
+		assoc_req_len = assoc_req_ie_offset;
+	if (assoc_resp_len < assoc_resp_ie_offset)
+		assoc_resp_len = assoc_resp_ie_offset;
+
 	assoc_req_len -= assoc_req_ie_offset;
 	assoc_resp_len -= assoc_resp_ie_offset;
 


