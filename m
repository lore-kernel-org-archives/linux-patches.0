Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD96376;
	Wed,  5 Feb 2025 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767630; cv=none; b=qzYvrplLNdOMeaVBv5rgSb6xx3b2e/wC1QxrGDUbCBowgZdC3l/+FFTpwz4PNl0OWTqo5IVW2fynLh9rEPpI4gPL4McS7MlVp3mYplv1v7I8ji+VtuH2y+5EPhTSRKu6Otapdv2yZ48aCOCQ9FX7T3fGT3OUkUpk0CtkyIGzNLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767630; c=relaxed/simple;
	bh=OIQDxZqgJ74IRM9d3XHhhJ+isQMuF5hyXTE3JWGuFqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5IqZfD6kwqoePJsaaK15J6awGWpO00wjZKgrLmmF4+3+mdYa1gnSCw4+VRQNGgKFeUpSWT7SgsNRFKHyv5ETxcVTieLmjUq+uArQh8fb3Orc6gLyMpWDGYeJWnYT4XPw1TkQRVD7s1XKamFKEg1jRDNlFjhqnwOWzbr5yehRGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlAdhTkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlAdhTkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEECC4CED1;
	Wed,  5 Feb 2025 15:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767629;
	bh=OIQDxZqgJ74IRM9d3XHhhJ+isQMuF5hyXTE3JWGuFqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlAdhTkgy+CmXsnBluEWqQ9jQP8P2KxJ4x4XvdOx5vOGvfEeMFOhFrhUN2xS8ZQRN
	 SO9A8/etYvfpb725DmoLmLNEm+qjJQsVd/icM5igr7oKxHemT0Zq+SbqnrHQQ/XSPG
	 JY1Z5Kt1jUP+79sMZ2Wa/gUkwUibKmspkoKSS8jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 431/623] of: reserved-memory: Do not make kmemleak ignore freed address
Date: Wed,  5 Feb 2025 14:42:53 +0100
Message-ID: <20250205134512.711005779@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 45517b9e57b1a..b47559f11f079 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -52,7 +52,8 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 			memblock_phys_free(base, size);
 	}
 
-	kmemleak_ignore_phys(base);
+	if (!err)
+		kmemleak_ignore_phys(base);
 
 	return err;
 }
-- 
2.39.5



