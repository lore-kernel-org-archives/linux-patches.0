Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCADD379C38;
	Sat, 12 Sep 2026 10:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207646; cv=none; b=owsPZoiMr81EkjU7stju+keQpzBHKgKVKl87AI5Uz6l28wAmlyz5sb/YfoiMEAejn89JM2x08I12tKgYAYfDuVjSziCWT6XuKhVcJjKvELqNKSHYW2EHBGCHv3DefHYcoQilAtan/k2YGsLjDc3ZusArtlf7PZm46MVdwChFtKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207646; c=relaxed/simple;
	bh=EdurR0p7yZUjPIqgnB6o6Qbc5qBvLNWj+nivGAL2kd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVq1/zjUjTBbVkGwoHx2dsX/xeM4uJjQtkse3FkY30RybK/jcTkp95F7fiiNzHv51yDeOi3kVQcAEpjfRyV+RVkf/SFQcgaFmxb5gFUdjwwKRhsaUFnymssYIdsg9VHAsRzotJfGRG6QsL+ieEx2e8EFU2md2XQLlR7Wi0HviMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9Sbt0cr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9Sbt0cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8F71F000FF;
	Sat, 12 Sep 2026 10:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207645;
	bh=xFpDuU84mTlGhRrAP2QY/iwlIHPEJpPFC7kvg8eu0mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9Sbt0crFnl6Bm8tIBjr5EIFKQRy+iaoaRiWo0LFh1px82dkUda7lwz2rHpBCZb2D
	 X4rxoewLrdzo0MYeSZfcwdHQFw5z7k1+Ai1JRf55oOj6iO8YkfBvH+5WnZms3+uf/B
	 pUa+oLD0HCFP7MQP+Rxt8kmfTq9JetH72mk2hneM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0453/1518] misc: rtsx: add missing write register handling
Date: Sat, 12 Sep 2026 08:43:42 +0200
Message-ID: <20260912065633.696876787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index f9952d76d6ed7..84a49156a2475 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1196,6 +1196,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
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



