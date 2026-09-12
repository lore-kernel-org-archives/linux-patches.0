Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645012BDC0E;
	Sat, 12 Sep 2026 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215684; cv=none; b=UfQ/13mnxx81/snk1Y1jPlYNyHCGla3pOPLy0tILzg5wfh9kisQJeKZlJbLpb3BzGttgpipkjsF43RKjPqSNv1/TKQc/zvVdlR4Ro0Y2sVgtPEAM6losmCDmAxQE8emyRGEtiaUBlkjUcKIwk/3su6rRSXe0VrRAhusYM9H53VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215684; c=relaxed/simple;
	bh=k5pz6JJ4+rFwqh+t51g7uDSFN/kda+3axRDNQZtBX+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMsDU9aq3zIBjDVMDNKNUf2fFSdVcqlgzGTZIf5QqSzFwHEc4Nz8hKrdfZ3nC2Ck2Kv7o9InqVowqnhRwDfcov3NcIbpf0sQ7zqYxzKIhAJp1SCC/WGzobm6+WC+zEJ6jcIRA/Kuk2dbratJzqmgKVNZA/eIcfkdqV+GqzYpi18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcoRiaFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcoRiaFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A971F000FF;
	Sat, 12 Sep 2026 12:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215683;
	bh=xyZxLG/WiLSSt3Wjp1Ovov7WfTfTtC52WohAWLedk54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcoRiaFgIIL9IUICxLSafnPjJxnpQxCYBkE7SdiXG7OTaSMdl6RVxooh9FsmNr7PA
	 69UrlJT3zvqLqm/XdNqSzyE9RWtKmgFA/IegE4WopEdYOtfoZ9b3zVCFPn3IM9gMZS
	 SR8oEphgtwDW4tihHxoVq2GQdbyl5fWWrDswrbj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0582/1376] misc: rtsx: add missing write register handling
Date: Sat, 12 Sep 2026 08:50:08 +0200
Message-ID: <20260912065620.503960312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index be3d4e0e50ccd..6a1cfa948bdb3 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1242,6 +1242,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
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



