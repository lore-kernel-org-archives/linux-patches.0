Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D352C18A6C1;
	Mon,  6 Jan 2025 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177195; cv=none; b=P68iIb9BfbWfwL6YtAzNJisi5crbfCH262Hj92DwNeJYMFTpPotPvaslk1eiN9+m1xaCW0V/TSF7QOt5/9YMJ/Wk6eMiDf3CsUE7z6v0pRRrnc+zRj9PQMhO43EjfoCfQ2doHCSd3ZbF+/FSXySmdr29aqMBgJ5ihB+3fx63N4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177195; c=relaxed/simple;
	bh=Ef+WQztv9TzWRAwQp5C9qhqJ6oeKkmtoa9kAXY6AKrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDlYGadxo2X5Lw7tR6ONeZ0JCeqmxtNuMAAMyi0GbAZQC6/al72D9Grth1909V9klzxIw1PUbxHJGKmwEG6mGhN6/VO5q6t45b86c4NRbZPAtIEHwCUPNVl35HscY3TH4dFRjzMDdBVqPj1s+f1+uR6zdIxMpf2LVCz3o3IGBog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfJBI3dQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfJBI3dQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5190EC4CED2;
	Mon,  6 Jan 2025 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177195;
	bh=Ef+WQztv9TzWRAwQp5C9qhqJ6oeKkmtoa9kAXY6AKrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfJBI3dQ5xqMBSoH8T1lG+9M7+Oy8ogO4c8KtvQ4RoSdoKg7vJdGD9sk9QfYq/ntL
	 mH7aaRG4J5+MuyCYTRyqWnTMy1vHGeDZ9CrIf5OOh9ubfqTDeKATzl6FTiEpRldQoF
	 QK7EY04aM+U2xGGV7o5hlC+qwUTzmQraIxpqE93Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea della Porta <andrea.porta@suse.com>,
	Herve Codina <herve.codina@bootlin.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/222] of: address: Preserve the flags portion on 1:1 dma-ranges mapping
Date: Mon,  6 Jan 2025 16:14:47 +0100
Message-ID: <20250106151153.742761279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cdefe5a89e5d..34d880a1be0a 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -476,7 +476,8 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
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



