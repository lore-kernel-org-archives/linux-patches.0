Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774541;
	b=iVIQiClPRYE0+qzN3/sVUNQqVnQzzIU7B5nOAbtshtc7Kht4GpYl9G47PWUPIMiNmFnQ
	 KiwQEjciI6Qk9bmtRe4rs1qpq/v4Wyqzhj33XXb/6HnEXwoQ7SE4neq3qqQcP/mBv/TM2
	 qNBWeNa1b/SlK2FdWAaa/xcN4IhelrZHmE1L+/c1WEXi3nYajpZ64imRk1PjY+gmuAjLQ
	 L0Njp0YF+SWijQAXrGkpPXCfJ2yOb4DeO8LR7XOZkWiQa78wgb+IJawWDiPrsUa7UC20x
	 xZsleM4BkXycteB6XUxH3cB4rnNNv21uR3Ho6q2YocaAiViKDLhr2y+PR7EZ9FfnNfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B/CdncJzum1aWkjC2I8nIon3w1rn7WMhKBQxbe/o3dk=;
	b=3U4ESpgXA8fl0tNzsFpm1xI93VHVUcHhcUMvsDM00tj3n6/11DoP8q9drpXwzfWDI2OD
	 2/SuEKzkDCiXnFBAFPvfEqty0iKBTxJMIMHRsSjxhNpRVAhNugBZjwIZbc4RC8lNBAOUs
	 NBcP7EHW7di579rK6zZR4WP8xRMJfbsU4x8/xcIOHwUHXDidR7PQmdPCUSTYscKukpqEm
	 B6vcWNTY+pyjD3sedQuiILsafvHGrZTb7Xq/aFyZ2LW/w78sZn1qfXcdsK1rbepC7PaZG
	 NV3OfqQFmPlX4be06LsVfeVpYsaIj32TIEn+fnbDX/JLiOTNlDXZD+pBn9f9MJPkavA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NXYyShr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCB7606A31A;
	Fri, 23 Oct 2026 16:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NXYyShr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5361F01825;
	Fri, 23 Oct 2026 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774540;
	bh=B/CdncJzum1aWkjC2I8nIon3w1rn7WMhKBQxbe/o3dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NXYyShrudgqwQ5PZvoqPOxiyxwQzfaPbDJMLQw/tdj6y08oCIXiIPMBA5DFSiW9T
	 sdAz6IRJt69DkXR5LFX0ID90PkENx+S+1I1OFndOVrOoQosPqBQaxF8DgzhIPmgKnf
	 YcDH5iE2kV2XRS3Qyq9/AONIPUeVj07L6oFJ084I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 048/242] nios2: fix __wsum type degradation in csum_fold()
Date: Fri, 23 Oct 2026 18:38:10 +0200
Message-ID: <20261023163714.912930542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b963f2345fa20417401c51a69dedb6a58eea33a9 ]

csum_fold() shifts a bitwise __wsum type, which sparse reports as
"restricted __wsum degrades to integer". Sparse only checks the body of
a static inline once something instantiates it, so this went unnoticed
until a recent block layer change added the first csum_fold() caller to
a file built on this architecture.

Force cast to a __u32 for the shift, as the other architectures do.

Fixes: eea9507a69d6 ("nios2: Library functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609222053.5gjiJjtb-lkp@intel.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index 69004e07a1ba3..b6b415ae17a08 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -27,7 +27,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		"add	%0, %0, r8\n"
 		"nor	%0, %0, %0\n"
 		: "=r" (sum)
-		: "r" (sum << 16), "0" (sum)
+		: "r" ((__force u32)sum << 16), "0" (sum)
 		: "r8");
 	return (__force __sum16) sum;
 }
-- 
2.53.0



