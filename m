Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0A0313550;
	Thu, 28 May 2026 20:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000233; cv=none; b=aLSGAmszP3RgiOwLS9skDkqqL3ls13LROKyEGIIhifb8JT5jEtc92IIvVimjy7ln+SaI1OT+rxCUPqE83NujJeiHHeSZUEdXKnzTKSHO0RoX7k0xNNZn0FYs0RIwCcOfPOGivkWfP7wq35ZsjNLwkpH1RyB3TqWsza2TVi37WOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000233; c=relaxed/simple;
	bh=HaWm83QVNkKiL2JFk+KY5QafciSBpEdWAOt9TUsJaFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2+i6TEXV5MMlnApyCJeZUxxloLjETBrnZS+VECJ0zVdcDT9owinblMs/LFj1IRqWemluopp68RuikwxJushVj1FPXP6SsJwNr7nRY7wZCRaf3UvPCAI+275Idc8Ay0iV4NjvIGAJUi/au27vFscbGSA2wcqBIYA5b9U6t0gk1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybXF1BXr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybXF1BXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB061F000E9;
	Thu, 28 May 2026 20:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000232;
	bh=RYT5ndn/RsDveTmsK88sj0fdhrILiBY/BceaPOW9umM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybXF1BXr+ctxGnQSxTwmiQRrSkEgOWe1jf9QunIHW+g68qG5ZtX/I4fnMP/Lk8Z10
	 b50oChQsxiRF4UtsBKPbdOEDAM3ApXXMNEzBjogR/raeT3fMyFML8kytJ1pZGW5Svo
	 6qU6YrFPH+3R9rcBuroTAh0A6wiNKM3CvvDHI10Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Simon Horman <horms@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 348/377] wifi: wilc1000: fix dma_buffer leak on bus acquire failure
Date: Thu, 28 May 2026 21:49:46 +0200
Message-ID: <20260528194648.499008459@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>

[ Upstream commit dd7b6a8671939708cc4b7a46786d8c11297e8f69 ]

wilc_wlan_firmware_download() allocates dma_buffer with kmalloc() at
the top of the function and uses a 'fail:' label to free it via
kfree(dma_buffer) on error.

All later error paths correctly use 'goto fail' to route through this
cleanup. However, the early failure path after the first acquire_bus()
call uses a bare 'return ret;', which leaks dma_buffer whenever the bus
acquire fails.

Replace the early return with goto fail so the existing cleanup path
runs.

Found via a custom Coccinelle semantic patch hunting for kmalloc'd
locals leaked on early-return error paths in driver firmware-download
code.

Fixes: 1241c5650ff7 ("wifi: wilc1000: Fill in missing error handling")
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260511042732.998311-1-shitalkumar.gandhi@cambiumnetworks.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index fedc7d59216ad..1cc4ee62987d4 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1265,7 +1265,7 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 
 	ret = acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 	if (ret)
-		return ret;
+		goto fail;
 
 	wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	reg &= ~BIT(10);
-- 
2.53.0



