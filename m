Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B181991A0;
	Thu,  6 Jun 2024 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683142; cv=none; b=dJS1GFn50b394J5V0aFM2Cyeq2ooYxIlcAxfpeqV3hhfvLlfVJPpwyFGXzGfHHMavndV+/FzX//T7ZYkqOOk2/iK8Nr3bvUINjNm5qkULw7nansYTGRL2cqZmYUMvPtt/6OzeGLweh4wMhhn9jHi/ok15+5WNBbKHLbkrlErN6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683142; c=relaxed/simple;
	bh=Fepczum1cCc7sCrnl8OhaaeUrfkknnj5+4bJJj4xvWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gRUXRmKfNXWWZYG1KrosI/0+QWLbBLejWuV0cU/0Dlr+5nw3Yc5smeb0UpA/6EUZLcH5GcjvmbGMf3PbYIC7ASGwdp8xnzy5AD3hZjyFfB032STRZ0a2WsI/Q1lfnVCQ1ClBDlfPAkn+4YV9cNTxYJf3KIPv3BttpJN+qegF4h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUGgsUrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUGgsUrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A2FC2BD10;
	Thu,  6 Jun 2024 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683142;
	bh=Fepczum1cCc7sCrnl8OhaaeUrfkknnj5+4bJJj4xvWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUGgsUrcbjUmjZKGsGuQs//MehWOEtlLR3QKimESNVxJmVkxzqaJsvekm+uIGnOI7
	 +siaRr9aK6AqDi8Bfm1ssRZOGnlPMf/yKt9X5EBUQZyDz4kNB4ZYehQ1N26IYUI0nv
	 /KTg/JcufX0UoitmiUwMJX1pUxrrixpJrFG3u3NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 014/473] net: smc91x: Fix m68k kernel compilation for ColdFire CPU
Date: Thu,  6 Jun 2024 15:59:03 +0200
Message-ID: <20240606131700.300496324@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -175,8 +175,8 @@ static inline void mcf_outsw(void *a, un
 		writew(*wp++, a);
 }
 
-#define SMC_inw(a, r)		_swapw(readw((a) + (r)))
-#define SMC_outw(lp, v, a, r)	writew(_swapw(v), (a) + (r))
+#define SMC_inw(a, r)		ioread16be((a) + (r))
+#define SMC_outw(lp, v, a, r)	iowrite16be(v, (a) + (r))
 #define SMC_insw(a, r, p, l)	mcf_insw(a + r, p, l)
 #define SMC_outsw(a, r, p, l)	mcf_outsw(a + r, p, l)
 


