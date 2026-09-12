Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6108A38E8CB;
	Sat, 12 Sep 2026 19:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242610; cv=none; b=efBiZs+xNOcYhJl/ShTXGrvVJJaq2S58IMrVxrM3Yd4QvFT5QfKBoYJ6qi3Kr57xwYyRWawCY2bYX3pOo9YkPVINE2RSdTV4ehNZhKN2OioH8XDl1ESYS0xqEcjv0MC9BEQfy1aKqfuIhQIvtywPWoIGUgJgUmDs5vXK89HVz8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242610; c=relaxed/simple;
	bh=vCwsZV9hOWU4L0OxqiAmx4pcZOzaCpVnzgtnybTM42M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkB6bWBmPL73CzztTBi4CMIWClduAMAZszCW/vy5Yc5zjFCohDAp9GTEvID6c/tz1Iz9vipk1ZPD1hlZHCOaPsGePjTF/L0a9zpqnAxzvWdBHSFdCBUOHSg+Wgj5iMkFHLQpiLb2ECiJfORvoc8lOaR1/oxcP6qj0nyQoxUx5Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6P3jyFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6P3jyFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B871E1F000FF;
	Sat, 12 Sep 2026 19:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242609;
	bh=TyATLUFotOn5Xy6bwsPhWEtaiUTz2tvXMOBuZ20DPsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6P3jyFhAtZm/K3GYEW2v860U+LCagDYz2kp/RLEApETGNw9d9wWzy1nITYWW4b3s
	 oDl8mPfRPRlfZA1pOraU5t4ayPkg4LBYlgnkNP13wAkgP9E6fAWcHJd4ZudcdZGygE
	 /zM6cmTNBlUuNGPSsOiKcvyIRg5/FGpBpM/8vpkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/798] misc: rtsx: add missing write register handling
Date: Sat, 12 Sep 2026 09:01:30 +0200
Message-ID: <20260912065527.734086473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Markov <markov.gi@npc-ksb.ru>

[ Upstream commit 655faba1ccf195e22a7a83146ef6015e3271233c ]

If an error occurs at the stage of working with registers in conjunction
with MCU_Block, it will not be processed.

The occurrence of errors at this stage may signal an impact on writes to
the device's PCI registers and is a more global problem than a
driver-level security problem, but adding a handler would be a good
practice.

Add a missing error handling.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c0e5f4e73a71 ("misc: rtsx: Add support for RTS5261")
Signed-off-by: Gleb Markov <markov.gi@npc-ksb.ru>
Link: https://patch.msgid.link/20260629130920.1260-1-markov.gi@npc-ksb.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 4c57ecb2be404..f650221da35d0 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1277,6 +1277,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 		/* Gating real mcu clock */
 		err = rtsx_pci_write_register(pcr, RTS5261_FW_CFG1,
 			RTS5261_MCU_CLOCK_GATING, 0);
+		if (err < 0)
+			return err;
 		err = rtsx_pci_write_register(pcr, RTS5261_REG_FPDCTL,
 			SSC_POWER_DOWN, 0);
 	} else {
-- 
2.53.0



