Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE64E36C7;
	Thu, 17 Sep 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668364; cv=none; b=H6n7T5OhQCtt3NSkXKJz91HtVm+qEOdPMFh1uEtbvwrk+RF2X0XOmzDLsLXwlBXKh0Hy6mIT5qjuW54U5M3Pi+7FAMCRM8ne4u9A2elS89Ah25vtqSFOksldBKLLI096NeR/A9xZIadhiGW+D1irlO0+1iUekyXThExF48048Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668364; c=relaxed/simple;
	bh=ayv2qpEn3G8+6qJUYmQhadEQFF1YHvPyr4YqT1kBzU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWPYzm1/7Tv4RzojBW3URvoBypyniVZQ1tkv8z39+vyimcu5gI6AXw+9AZRIT0IKJdT7zYkxcjxO3NCS/f3jruR0ByWyGdyfIadEQhe9x2AU3T6sRFr0GllXh57ZdxjftoYLqicINg+6u5M6P337atmJxmpGeB0yQGR9z8Hdatc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6505X5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6505X5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC201F000FF;
	Thu, 17 Sep 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668362;
	bh=+DJls/PXni0SgiAWy90YjpMrXPqDvVogbzydj2EasCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6505X5Y+avRe1eMYY0Yo+c4mxyfY1ydwdc3eW8rZ9jkRgmJmMlMCq425sMMyZNP0
	 79U8hs6quXcKYuGrJaSLaBdlWrajlbJxCX+Jp5hDavzGkk7RtQoJvtLKojtX6aISTi
	 vPOG9tysXAgVv08w6RPjXIqzOIYaQY9J/U/dWUxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0399/1102] wifi: libipw: fix key index receive bound checks
Date: Thu, 17 Sep 2026 16:05:42 +0100
Message-ID: <20260917151549.676338340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 74ed3669f26803b1761c1f55403062bea44c3466 ]

libipw_rx() reads skb->data[hdrlen + 3] to extract the WEP key index in
both the software-decrypt key selection path and the hardware-decrypted
IV/ICV strip path. In both places the existing guard only checks
skb->len >= hdrlen + 3, which proves bytes up to hdrlen + 2 but not the
byte at hdrlen + 3.

Require hdrlen + 4 bytes before reading that item in both paths. This is
a local source-boundary check only; it does not change the key index
semantics.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705083519.23567-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 9a97ab9b89ae8..2220a9814c8a6 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -417,7 +417,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 	    ieee->host_mc_decrypt : ieee->host_decrypt;
 
 	if (can_be_decrypted) {
-		if (skb->len >= hdrlen + 3) {
+		if (skb->len >= hdrlen + 4) {
 			/* Top two-bits of byte 3 are the key index */
 			keyidx = skb->data[hdrlen + 3] >> 6;
 		}
@@ -663,7 +663,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 		int trimlen = 0;
 
 		/* Top two-bits of byte 3 are the key index */
-		if (skb->len >= hdrlen + 3)
+		if (skb->len >= hdrlen + 4)
 			keyidx = skb->data[hdrlen + 3] >> 6;
 
 		/* To strip off any security data which appears before the
-- 
2.53.0



