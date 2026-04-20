Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AA117A31C;
	Mon, 20 Apr 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700757; cv=none; b=b+ZZuqLa8D3AViJwItpRx4dE24az7xW1ZvR5wzHxMQw+QY8iuZXTktEJGxDDMB7g+wmfcd6U7YHYLJ63lv6mf3XO4aZ9ujtC1b52tTioiOYQSrpDIjzEZ+LFeWWPjWs0D2IPhZcSioPc0qQH4SDs2FHNBNnditaEq1tODr/7avs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700757; c=relaxed/simple;
	bh=Fu+O70sG49NzNVCtGynls38FJEDdbILwzpOwCDik/io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJRpCQGUrRnLZoSopJkmELpR4RkgzSe5UlmhCNit7+JhMmqO7hSC3oNOiJOfMFSosf5SpVPddvB+W6G2x47K7FqKNI6CHmHw/eX+KHAZ6GNF3uA9aVdbcJHon4U1+lmwg25NeVAwBnX48K/iFpvkDgrIOTtTQniRrCJjgL/Qbh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2mCSZ1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2mCSZ1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFEEC19425;
	Mon, 20 Apr 2026 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700756;
	bh=Fu+O70sG49NzNVCtGynls38FJEDdbILwzpOwCDik/io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2mCSZ1EFE4CHtRb9eRlQY9MbYk9KQ4KYp9IogpHSUD8e7UxPT1aIi2TBusDyrmUb
	 r9xMPxpGMK5Z4AbJu+2c9DdgfF8ZuaJX2vjh1FJwSdUdO3B7r6D+C/+JCcaxQxKQZX
	 v18UulqNOZd++iy2C49modYfWWjDcuL+Qwg8WnsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/198] wifi: brcmfmac: validate bsscfg indices in IF events
Date: Mon, 20 Apr 2026 17:40:21 +0200
Message-ID: <20260420153937.133224509@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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



