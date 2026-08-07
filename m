Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6065F44236E;
	Fri,  7 Aug 2026 15:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116855; cv=none; b=jFNhAdBTSPPi2oVnomtM2pkvUlK53KpU1T9WT6bX68UijovpWNrunOw5A6tLuLZn9jmLGNbDIoke7tbPmWe5dkqv6a91AUUX7a3jdF2r2uVHojgizZlsoF24aXpDNqRdOEUSpuFK6hRqXYjRKscSbvTEf0uabnc7vbWfmF+G1m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116855; c=relaxed/simple;
	bh=HohsPk8SUVVIB37VyO1eJoeVOGo61TccBvPeUUbZzwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYfMhyMV6YM7shy48VHiE6xwkph4dz4ZW4jrUoSe1zOpZy+StOqNl2NYvxX5Y+DN3f0wyPPuNyL6OMNzZAD37w9mG+BP9byhw1g1t61Lln+HMPPHkqZY6W7d4+7+6YfYtcHvSN/G4kmk/DHVPhw2WZe/JUsBuam8AmBwoPh1QkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDG3nW3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDG3nW3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31B61F000E9;
	Fri,  7 Aug 2026 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116854;
	bh=d65tZAP1ki4+pLUX2pDRC/466xzc7gXA6J/MMWhfNHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDG3nW3KhSeqGw/bn68LnZPQSnpTNlfh2IX3SISG3Y4U1TNMyN9I7ZOcIL28rdCPE
	 hdZuGwOJGvDixRzb9B0Kbtm9lf2GFGy7dlPS4lr05+KukrqgxKF4HWrzAP4GuWypLn
	 +zZbmrxirVBmbpCAWH1AWGGHAgVLjjmqjjhXr1hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 112/438] powerpc/boot: Fix simpleboot CPU node lookup check
Date: Fri,  7 Aug 2026 16:35:08 +0200
Message-ID: <20260807143430.383301134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c824ab65685bb119c6c6a3a200b3428c72862d5a ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: d2477b5cc8ca ("[POWERPC] bootwrapper: Add a firmware-independent simpleboot target.")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-4-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simpleboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simpleboot.c b/arch/powerpc/boot/simpleboot.c
index c80691d83880b..27591df41e9e8 100644
--- a/arch/powerpc/boot/simpleboot.c
+++ b/arch/powerpc/boot/simpleboot.c
@@ -68,7 +68,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	/* finally, setup the timebase */
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 					     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0



