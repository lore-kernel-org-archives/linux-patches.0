Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2444530C618;
	Thu, 30 Jul 2026 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423522; cv=none; b=U0qE76M4cueaRVan10uE0sD6gZmHH7sMy5IbrNzqc7+YJnBTdFB/RVsc0rsc10Q7T6G/jqtzjNKdfcKAoe/xvWCTq/Q+HVfEzac2Pz/Oxz+v460OGTvaYcahyeCwQTljOm3TUHaw3yBMfd+b7UT6OmuOlMz100nffKX2n1aPQVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423522; c=relaxed/simple;
	bh=3iqJ/6eWUQmmsWMpbJSogqjez0LMZMFzZBNbsEdvV3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYdJBDZCa5PQe2xnp9yq1tCRIG5uSSqnwSLFWF6n1agI0sysBGNAgx64S2wGTlU09NiePFSl8WrTurF0gmEZEW1+E2tRij92QZnD5DB8fTrUokyK7i/SavnFx2kfx/+HvT55lMFPPhxbbbdANjU5r6Q7cYYTT53dI6pufgnQzQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhjOe2Mx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhjOe2Mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431C71F000E9;
	Thu, 30 Jul 2026 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423520;
	bh=BDZ1WaEw7xmZ/5DGw+86QBLxc3Tuennr38CEZ+arIRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhjOe2Mx4j6E3hTf+klMnIrH3s8LbsGHP+Sp2upSX8XyUH3ebYgEjwmFX5WnxFCTV
	 KTpUNjP/mLcRgdggpmJwD8EQyJvEuXecg6R7GmVdJNN93KTxI/g4HY9iiDugSR7R3p
	 eSKHI61NFxmKLEHvLuQr5yU2OSNY2WYtPyvt8R7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/675] wifi: libertas: fix memory leak in helper_firmware_cb()
Date: Thu, 30 Jul 2026 16:06:41 +0200
Message-ID: <20260730141446.637063494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 63c2391deefb31e1b801b7f32bd502ca4808639b ]

helper_firmware_cb() neglects to free the single-stage firmware image
after a successful async load, leading to a memory leak in the USB
firmware-download path.

Fix this memory leak by calling release_firmware() immediately after
lbs_fw_loaded() returns.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
the current wireless tree.

An x86_64 allyesconfig build showed no new warnings. As we do not have
compatible Libertas USB hardware for exercising this firmware-download
path, no runtime testing was able to be performed.

Fixes: 1dfba3060fe7 ("libertas: move firmware lifetime handling to firmware.c")
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260624085343.575508-1-dawei.feng@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/firmware.c b/drivers/net/wireless/marvell/libertas/firmware.c
index f124110944b7e9..9bf7d4c207b9ed 100644
--- a/drivers/net/wireless/marvell/libertas/firmware.c
+++ b/drivers/net/wireless/marvell/libertas/firmware.c
@@ -78,6 +78,7 @@ static void helper_firmware_cb(const struct firmware *firmware, void *context)
 	} else {
 		/* No main firmware needed for this helper --> success! */
 		lbs_fw_loaded(priv, 0, firmware, NULL);
+		release_firmware(firmware);
 	}
 }
 
-- 
2.53.0



