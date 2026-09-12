Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF9A4BEE43;
	Sat, 12 Sep 2026 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238848; cv=none; b=QTotWvMIXb+hzi4UmZp7YMBZfvo8gY3fP53t4owrNWJOfyTGOLon4W39eilkQc/FUGirLNEg73t7S2gd2Ez7n4oTFAvB/OPsBed4XGnH0BnkKDULC2I9i+N+qB8lP9w8VT3h/c+23ucSIQwFmTJSe+zxDmtbFv10voersf61oxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238848; c=relaxed/simple;
	bh=lAzOD02H7vAQ78H5LnJGV1T4WFSgy6LbxxJwtKbFuMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jj65FZVJ9NBP3sGZIZ9bVSv0mUp5QnqT+zoNfXuNc7ss07gWszuMVotWzXYzMjsOLbFJtqixp4Nr6Au7ABEw3uXnLwFq12wPV+0SUkqvXEl4PXNQn2cwsrXY1eFROfuvLQDbB7QPIFig4h3wI1WKX6CCCkXHDQZYl3HmuO/N8IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYG9Pt54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYG9Pt54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B631F000FF;
	Sat, 12 Sep 2026 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238847;
	bh=mLKN47AKX0ckBUMHN68sobzMg8ORcqpk+LlTiWJEuDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYG9Pt54relmHDw2YUKoCaj4fE+r61qRquRl177HpYbLZ9rpqPMeF9L25b9xE+JDa
	 c7tZN2Jxq+CvSsJS5YvkX+SsTIgybvp+Fikqqe8zcGkNWmOp2nv0uoxKNuTIun37gk
	 OwgJtXL2pyPAbCdE+Cz1R+NjX6BtrT/FHDIRg+AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 546/935] misc: rtsx: add missing write register handling
Date: Sat, 12 Sep 2026 08:59:36 +0200
Message-ID: <20260912065539.344342064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b2099bb54ac12..71644f74721aa 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1304,6 +1304,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
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



