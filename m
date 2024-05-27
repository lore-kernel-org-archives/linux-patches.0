Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C0015FCFC;
	Mon, 27 May 2024 18:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836365; cv=none; b=vBc1gDJwOj6cFnjCo5gLq2B4+548R1KZZ8aqja6cmec5cWRlcHu8rCb5tbs1qT1ReG8XVG404LUN232JaWj8sfZM5pdB3h4TxZb8B/C88q2b6wLpFu6OV3mHA1pP7zyo8Rjj688C2rGJgEYTi4kVfUih2MKLZPJj+NZ9w8dW3Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836365; c=relaxed/simple;
	bh=/oXz8Qk14dYfhFl7+4P/C+0glsJNv2Ux/GphCrg4tQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+y90WaE4un2mIzua1p9NNzV2OXIf80k9DH3ZjTOqWigka9fLFzn4jWVHI0QJVEyn2FtN7widVZBRvia8sjtB5gI9iugHBtVWg7t6hqBcaeLGEG+/15U+EoRRrFVVfwCWMxGzEzy3gHYnCzysMIJ74l4bAJpL05mLHliVIqpFs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLQ9/SOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLQ9/SOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A22C2BBFC;
	Mon, 27 May 2024 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836365;
	bh=/oXz8Qk14dYfhFl7+4P/C+0glsJNv2Ux/GphCrg4tQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLQ9/SOqA2evejNYmSFBOCIrQFIkKAgv+wb8gPVI82ALcRIacgv5InJGa6qMALVsi
	 XZoDCXNOO/ElG/Hywfmo2yj0kBLyAPcO4d41xgnMkyOBBYBHAssm07XNvPcA3w2KLY
	 xKvjF1XFxGwMaaWwYEChQqYqbmKaLlwDWeYGbQK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 025/427] net: smc91x: Fix m68k kernel compilation for ColdFire CPU
Date: Mon, 27 May 2024 20:51:12 +0200
Message-ID: <20240527185604.031930594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

commit 5eefb477d21a26183bc3499aeefa991198315a2d upstream.

Compiling the m68k kernel with support for the ColdFire CPU family fails
with the following error:

In file included from drivers/net/ethernet/smsc/smc91x.c:80:
drivers/net/ethernet/smsc/smc91x.c: In function ‘smc_reset’:
drivers/net/ethernet/smsc/smc91x.h:160:40: error: implicit declaration of function ‘_swapw’; did you mean ‘swap’? [-Werror=implicit-function-declaration]
  160 | #define SMC_outw(lp, v, a, r)   writew(_swapw(v), (a) + (r))
      |                                        ^~~~~~
drivers/net/ethernet/smsc/smc91x.h:904:25: note: in expansion of macro ‘SMC_outw’
  904 |                         SMC_outw(lp, x, ioaddr, BANK_SELECT);           \
      |                         ^~~~~~~~
drivers/net/ethernet/smsc/smc91x.c:250:9: note: in expansion of macro ‘SMC_SELECT_BANK’
  250 |         SMC_SELECT_BANK(lp, 2);
      |         ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

The function _swapw() was removed in commit d97cf70af097 ("m68k: use
asm-generic/io.h for non-MMU io access functions"), but is still used in
drivers/net/ethernet/smsc/smc91x.h.

Use ioread16be() and iowrite16be() to resolve the error.

Cc: stable@vger.kernel.org
Fixes: d97cf70af097 ("m68k: use asm-generic/io.h for non-MMU io access functions")
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240510113054.186648-2-thorsten.blum@toblux.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/smsc/smc91x.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/smsc/smc91x.h
+++ b/drivers/net/ethernet/smsc/smc91x.h
@@ -156,8 +156,8 @@ static inline void mcf_outsw(void *a, un
 		writew(*wp++, a);
 }
 
-#define SMC_inw(a, r)		_swapw(readw((a) + (r)))
-#define SMC_outw(lp, v, a, r)	writew(_swapw(v), (a) + (r))
+#define SMC_inw(a, r)		ioread16be((a) + (r))
+#define SMC_outw(lp, v, a, r)	iowrite16be(v, (a) + (r))
 #define SMC_insw(a, r, p, l)	mcf_insw(a + r, p, l)
 #define SMC_outsw(a, r, p, l)	mcf_outsw(a + r, p, l)
 


