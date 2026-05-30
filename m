Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72012D9787;
	Sat, 30 May 2026 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158119; cv=none; b=nOD/ggXLuNNEjVlCUdXcI/L6Hl9/J8I4jR5NpU4ihH4ml2AoVHAt0buvMBsjFZOzR4PlWz5YXQPLQkqaLSYDyXewq9uv/6MsFAd87WIx1HrtPekcsuYrhQLTuV891jQFwj25mrihIGnqUT/7D1z0E30nrbkAZy7YGRBqPVM//0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158119; c=relaxed/simple;
	bh=anVR8RlffYq3Cmp1idvYSh4hc8Bys5XBPPwx8R3Unq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhYTUBHIXAW15tTqu3REtUJQR3uTpu//maosqR+mn03xPP4LyokUaCBQ2/sPcwS+x2GmtbaZbOkbeqtLq1vGWkxeIlh60dNX9IzSBnmeOTeufNCkhy+3bd5BCVCcF2Q3bxsUAkxGeTcitv/GjT43lGMUAdgAgVSOlSkxYA4ZERk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dp0r08ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dp0r08ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E50D1F00899;
	Sat, 30 May 2026 16:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158118;
	bh=Xr++PCTNXdhmpk6cuoJTKP0u/E6TeuG3vCUW3GgOorI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dp0r08niZTpsyoe2TTG3QuY05xHgN0fvFmlwWRebl7iT8VQUrhkgsZ89PhfriVkop
	 cqRzNhVB8a50w40f8Fw0JnMsYrV10x31vG9G0z/p3wvWTTClZBj4BI9cSpHfeg23Bx
	 SVsIWF4V8JRRu47gXLt2UVKbM4Y7txDhk45Q69LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/969] wifi: brcmfmac: validate bsscfg indices in IF events
Date: Sat, 30 May 2026 17:52:26 +0200
Message-ID: <20260530160301.068406488@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dac7eb77799bd..e6be192dc0af2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -151,6 +151,11 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
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



