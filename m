Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682F234216C;
	Mon, 20 Apr 2026 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700101; cv=none; b=np//DMcJaG9TDdNRSgAAZsOPyTIJZXJBKaOxbTMWsckTYaK/JSMb1pjxwxpypawFiOVweVdED341bnIZNuKzfvbDiQw2hwM8QcQUhiAgUZMXkQgkPUFNrGmYkTQH5Nt96Yo1dLr2Mqwd8lGeSi4IDVucxqtp/qDDuJQl53TxCUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700101; c=relaxed/simple;
	bh=UADPtQG6Y+HCyAWbfU7EcFHoF5r4mN3xse/DznQKZiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nafilkkdl4PJsPBoULsWPYhBzz5RwR8a9kB+zgPokkcIGg877SNP2do/BCNjGifU6IOHGToBSA8N0f7H9uSfuAAYRa3qrYBjv/xSm1LfBkdF9cgnftNSnXEWZiGGUYmm9QFFYl7CA7agDihDwrq0HDXU8viOd2ykUQ+BbadXxLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAhfklsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAhfklsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EF7C19425;
	Mon, 20 Apr 2026 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700101;
	bh=UADPtQG6Y+HCyAWbfU7EcFHoF5r4mN3xse/DznQKZiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAhfklsaWdPJ8JOkqlv4vkYabMT/JFNGrLsgrBZtz/7IbCVgVTk7pFwbOYmORydkI
	 d/EAmVYBjYhPaBrO/V+O31x0DciZ66EMVg7U57Nxyv/KIfoFiZcC0unVZV3huVbbOj
	 XJc9jh2eKzCi+AOhpmKpW2Sw9pSe4003fAALtZPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 043/220] wifi: brcmfmac: validate bsscfg indices in IF events
Date: Mon, 20 Apr 2026 17:39:44 +0200
Message-ID: <20260420153935.588216852@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 304950a467d83678bd0b0f46331882e2ac23b12d ]

brcmf_fweh_handle_if_event() validates the firmware-provided interface
index before it touches drvr->iflist[], but it still uses the raw
bsscfgidx field as an array index without a matching range check.

Reject IF events whose bsscfg index does not fit in drvr->iflist[]
before indexing the interface array.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260323074551.93530-1-pengpeng@iscas.ac.cn
[add missing wifi prefix]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index c2d98ee6652f3..1d25dc9ebca8b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -153,6 +153,11 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		bphy_err(drvr, "invalid interface index: %u\n", ifevent->ifidx);
 		return;
 	}
+	if (ifevent->bsscfgidx >= BRCMF_MAX_IFS) {
+		bphy_err(drvr, "invalid bsscfg index: %u\n",
+			 ifevent->bsscfgidx);
+		return;
+	}
 
 	ifp = drvr->iflist[ifevent->bsscfgidx];
 
-- 
2.53.0



