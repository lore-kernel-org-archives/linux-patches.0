Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2581B233715;
	Mon, 10 Mar 2025 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628977; cv=none; b=oDPEsHlNuf3r9kIBUS+Qe6jPZzmVYOvoKDSF8BsFkDB+15uGNO3ZOs85MLyIXLYGrIoLqcFdyMXRcGUPn1aqGkGvb51mmKfNUNjBOxJMAiID75SioF22+9S9taCHFoweUbGeB1N2N+f1DXg2vk59jBXD3R4shVyEY6E0golatzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628977; c=relaxed/simple;
	bh=7qAf6S62AjSc/p33NaPu+v5NdsZg7+SycwY2E+g3LFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfcbBdYcOdr5mYZZlP9aOER8mYtNchYSsP0JWXbamiOJcU/xynbzehOPJs7chQ3SR3QHzaGmZH5DRCPvc/7NwkQBU5LMwBu2onKITgV4i1KO5y74WCkoc5u6diZBt9b9v6sNS0p3Ern62Crmtlw+7UlMRPpt6/BE/W0yMsQAt6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW9cgkXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW9cgkXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E060C4CEED;
	Mon, 10 Mar 2025 17:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628976;
	bh=7qAf6S62AjSc/p33NaPu+v5NdsZg7+SycwY2E+g3LFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW9cgkXLOLyowpkbwu+tgTAsCTd3sYE6pRvF25aRPYlNFM3f3fMyU9sLYPvEpBL34
	 zsJzN2hihRBaesOK7Lf744oOrMbj0GiknpW/E93LtGz5fGlVrbCjlVygeJN0x0NA/u
	 M/rmBl2jCtHRuruMpW5p5xjA2C9hDMdgcD3SGYsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/620] of: reserved-memory: Do not make kmemleak ignore freed address
Date: Mon, 10 Mar 2025 17:59:40 +0100
Message-ID: <20250310170550.888224811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 29091a52562bca4d6e678dd8f0085dac119d6a21 ]

early_init_dt_alloc_reserved_memory_arch() will free address @base when
suffers memblock_mark_nomap() error, but it still makes kmemleak ignore
the freed address @base via kmemleak_ignore_phys().

That is unnecessary, besides, also causes unnecessary warning messages:

kmemleak_ignore_phys()
 -> make_black_object()
    -> paint_ptr()
       -> kmemleak_warn() // warning message here.

Fix by avoiding kmemleak_ignore_phys() when suffer the error.

Fixes: 658aafc8139c ("memblock: exclude MEMBLOCK_NOMAP regions from kmemleak")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-10-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 6ec668ae2d6fa..8d6ca796d9ffa 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -50,7 +50,8 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 			memblock_free(base, size);
 	}
 
-	kmemleak_ignore_phys(base);
+	if (!err)
+		kmemleak_ignore_phys(base);
 
 	return err;
 }
-- 
2.39.5



