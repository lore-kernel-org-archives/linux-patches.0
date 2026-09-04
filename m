Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3973F7873;
	Fri,  4 Sep 2026 05:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501151; cv=none; b=c/2gJvZzt5bSSlUhcJSnbm9nzcH5Gfn2oFbOU7nlL9O3c8O5ZN21+uFMn9HpHyrd6uKTmEb0PZHJNtPWMa+jdPhh/iFga2ry2+ZH4z3jCdExeKeerVutJwNJo1n3oL13wHsT48bfITP3E53X+WUHVxMvbCtmlG7Kw1ITS46u1qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501151; c=relaxed/simple;
	bh=surVgFxeyC1QQKpp7gEfuIjV0tQbCBjWm0ELla0IzFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJAxS2KeGdp1oUJBKm+d9DdUaDEB2p+tFTFE8Ko2mU3PJXkt94digzYQCi1lbEpNJAADOy3YjlTHNus4b9W3EikG7GgJRI585fcttsPY8JYdKrFtPIEaB7iUlPCHqLEc2lIsVEcVdNJH3s0atcWGPxO1EG9N42nNlHZzLnapnds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDQvd5S/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDQvd5S/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F4F1F00A3D;
	Fri,  4 Sep 2026 05:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501150;
	bh=CxK8LlPiCdOSlVshY5VlcX/kAkZe0jZ/LMpbpUapmBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDQvd5S/H/Q6FiEsyOLK6XJxSZ4km1K6b8+bkcGxYkJEZzAB+EFXLN+lYGXPiy4xd
	 z9GFtLXJvgWVIK3grgEE3BPIDZfg6UYDe3W8Bj8GhhGCXVHtDk3R5ZsJFbX2Lw9hGk
	 Zdd+wHpcCR1kxlJhxTLN3TVrpr7BYy3ExhpUnFHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 301/552] wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets
Date: Fri,  4 Sep 2026 06:57:38 +0200
Message-ID: <20260904045756.986126228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
 


