Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B691F55E3;
	Tue, 21 Jan 2025 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483019; cv=none; b=L+7WyYG1uZTrbZbT1GiFKNOiU/u6VRefcwrKbVxKGcMSMlRUis6WpN+EYPlTgcbK97tNbV/qZct47cYzWbJYgVHUOFQ8K0AFei8UWgMyqiePbJEY2mB40fK8DeNheT/mOqkm5doGlbeyO4gIfhstAM4dNv+DQ+o+aa4oaElSOZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483019; c=relaxed/simple;
	bh=Ots7sys9kh0ggyBjHPi+9M7xNUDTFcAx9YVeV/xwyxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0FCIC9fOJjB3lPFDJtrO4kfxiWas7oze48WQqqktK0xKN0o5O2XdA4yYt9UdWYNj/SUZ4S7RX59SC6SeBMLnEVLP69TXMFl0MTb3Tv2nZLYvc/Ibge0wjjMv9KFbu8HFR4OsWQsANV+RP0dtuwwphlNMgBPVXhbJTxUeM1UI1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9cWm8Ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9cWm8Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074EAC4CEDF;
	Tue, 21 Jan 2025 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483017;
	bh=Ots7sys9kh0ggyBjHPi+9M7xNUDTFcAx9YVeV/xwyxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9cWm8Ikq+AOeMhd6EeZEoPN0IRUmmNXOvNa9WbsaI5CEVwRkneTxviCTSL9+Rc/Q
	 7sf2YL96CrTD1DlSfHJXnY0Mor765qiSg2Ssr7iSJrIsK8A2p1LTBy99YRJc11Yh1n
	 BZxbWnATXd6kzzbDwUj/8XY5CJ8S1yxhoyArm2OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea della Porta <andrea.porta@suse.com>,
	Herve Codina <herve.codina@bootlin.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/127] of: address: Preserve the flags portion on 1:1 dma-ranges mapping
Date: Tue, 21 Jan 2025 18:52:22 +0100
Message-ID: <20250121174532.367024393@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrea della Porta <andrea.porta@suse.com>

[ Upstream commit 7f05e20b989ac33c9c0f8c2028ec0a566493548f ]

A missing or empty dma-ranges in a DT node implies a 1:1 mapping for dma
translations. In this specific case, the current behaviour is to zero out
the entire specifier so that the translation could be carried on as an
offset from zero. This includes address specifier that has flags (e.g.
PCI ranges).

Once the flags portion has been zeroed, the translation chain is broken
since the mapping functions will check the upcoming address specifier
against mismatching flags, always failing the 1:1 mapping and its entire
purpose of always succeeding.

Set to zero only the address portion while passing the flags through.

Fixes: dbbdee94734b ("of/address: Merge all of the bus translation code")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea della Porta <andrea.porta@suse.com>
Tested-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/e51ae57874e58a9b349c35e2e877425ebc075d7a.1732441813.git.andrea.porta@suse.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 123a75a19bc1..9454725af850 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -466,7 +466,8 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 	}
 	if (ranges == NULL || rlen == 0) {
 		offset = of_read_number(addr, na);
-		memset(addr, 0, pna * 4);
+		/* set address to zero, pass flags through */
+		memset(addr + pbus->flag_cells, 0, (pna - pbus->flag_cells) * 4);
 		pr_debug("empty ranges; 1:1 translation\n");
 		goto finish;
 	}
-- 
2.39.5



