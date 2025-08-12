Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CF36BB5B;
	Tue, 12 Aug 2025 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024016; cv=none; b=msYQRxcKnONTX9TnBpu9unFNgebArAS14OWff+ajd4ALRM4EcRXaH9oavOLHqEvSa4J+x2Djy0N8o/UoShX2HzfuUdjx9RtxgKb6DRVSri/wI7rLPPe4jUEPfisfRo8yGhLI3uNrQ05jfbR5BjfcMt+1G5fYLidwko8Tc+Zrz/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024016; c=relaxed/simple;
	bh=oaHRcql5jAd2PwcK3tzabgaMLXnp1gRuNahmTFZo3FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmPEtmhFGZuhE+2u3tLD13kejsWHZvszHjrbHoeNJc4Q7b/zATIQdwM3mj5vWLAb4nMDgQ4821oLpBHU4Yma0y+4KuuiGOZI5RYn3ZSGgYnddcMeGFZSEfSJbGgZ7ZMiccooHSzs4YLClLvdJvrwPWsrMVbX184kKiwaf54x1Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPvMrgtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPvMrgtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F84DC4CEF0;
	Tue, 12 Aug 2025 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024016;
	bh=oaHRcql5jAd2PwcK3tzabgaMLXnp1gRuNahmTFZo3FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPvMrgtTmbodw6Y37UqzeDhU7B1ifoGvQc2OGrpaY6blLjCmk1kig9OPrBb90llDP
	 jkJPZCjIWHl+LrgvW1AXfL9VRonWJG0VJcYL5HV5vdiFUSqyEX89lIbKAbz80QxvYb
	 urViGoaUAMlaqPZoxK6F54B0sKcRba+ZbLoGy4Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6.16 249/627] wifi: brcmfmac: cyw: Fix __counted_by to be LE variant
Date: Tue, 12 Aug 2025 19:29:04 +0200
Message-ID: <20250812173428.774931927@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 204bb852863bf14f343a0801b15bc2173bc318f9 ]

In brcmf_cyw_mgmt_tx() the "len" counter of the struct
brcmf_mf_params_le::data flexible array is stored as little-endian via
cpu_to_le16() so the __counted_by_le() variant must be used:

	struct brcmf_mf_params_le *mf_params;
	...
	mf_params_len = offsetof(struct brcmf_mf_params_le, data) +
			(len - DOT11_MGMT_HDR_LEN);
	mf_params = kzalloc(mf_params_len, GFP_KERNEL);
	...
        mf_params->len = cpu_to_le16(len - DOT11_MGMT_HDR_LEN);

Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>>
Link: https://patch.msgid.link/20250721181810.work.575-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cyw/fwil_types.h   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/fwil_types.h
index 08c69142495a..669564382e32 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/fwil_types.h
@@ -80,7 +80,7 @@ struct brcmf_mf_params_le {
 	u8 da[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	__le32 packet_id;
-	u8 data[] __counted_by(len);
+	u8 data[] __counted_by_le(len);
 };
 
 #endif /* CYW_FWIL_TYPES_H_ */
-- 
2.39.5



