Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8E647254B;
	Sat, 12 Sep 2026 16:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229706; cv=none; b=pX13lCNvuVCLghFV4psNy9X/zWzkUHsVSPcXR+HRcmESREZQdFuA6As/tEXtO2OnHiX42vu6qrMVmlaF6hItnJ4Ikt9ekbiFG8RZfcwu1iFvoJ2e5ndXQy02e/RSo1tSmE7pKi4in8uVbjO5WANW3C96h3o5n8rse6pRt5JZt3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229706; c=relaxed/simple;
	bh=7VgMVdvFLwwCB5tvacBsyGg0itWpTMKa6b6cwHdqTA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgXHrF8WMdej0k9Cqim2HeyxYEcnKfJ7POHFWcZHj5RUF58MxB4ZpbOAUbyYJuNTxtmgXGOeVtpwjaGO/J/PvgCC6OwZOYbNskrG9/kk8t0AE8cKBb0GIn0YTqqhxfeK+N97fbdbomL2udjy9BYHsse1qLHeZRixve7Zi86yxyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zhUwOnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zhUwOnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815761F000FF;
	Sat, 12 Sep 2026 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229704;
	bh=5y+SBOi62jVIXz8PeIbWr7pPPWXKaDxCU6UVlikrMBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zhUwOnFt7uxQ/GWBMQ05LutoIVThq/3kzqvf88PfZnQlZHeJF2hiGCMRk4L5az+3
	 4A+o/K+RvAinHqOeqP3U3JQe0eaSKb3F7YNezkohxQ0F4ClSxL7pUTczYKe+oZF7Ju
	 NAJ7Y3I5ALmZWRBLgW0YK1Tx+WfLBUwyr+9C5qfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0642/1191] misc: rtsx: add missing write register handling
Date: Sat, 12 Sep 2026 08:56:10 +0200
Message-ID: <20260912065602.674026685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index a30751ad37330..7979ec7d7333b 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1230,6 +1230,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
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



