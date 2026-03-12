Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0B43909AE;
	Thu, 12 Mar 2026 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346488; cv=none; b=tVgJJyEZ/9iC7Yb3CZeAcpFhO8Dz7aA+vRVrbIxeV7Q1LofVXzj0b0z+J6KYSa2o1nMwxrGxCLucnp9hrGv96KhS8je/Tbyi1BhTBuoyFxVdQPWTCW2nN2g7q9tfWoHV6tKOH56Sak75QQiTKg+jFthET2pGZUUI2ZiERi//lRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346488; c=relaxed/simple;
	bh=JJMFpdeTMJe/eHsKFSFWJH4gxZYmVgZTdbjmlivxsao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9/8x8JAUQ2z9MKLhjEjbyFSJ2wxzH3734Z0+GvgcWcRzQXyBRdwyeyYwrdAfaOvpgV3LR9+vNCKgXNY+xllN+RGY1WxyT97MC1RQjQdYGf1oulmgFioLxwQZhRmrtA1IVKD1eQyWNfzVPe2unXgsoFLPgz+ERFwjbnZuJKI+b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJZaVZi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJZaVZi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0C2C4CEF7;
	Thu, 12 Mar 2026 20:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346487;
	bh=JJMFpdeTMJe/eHsKFSFWJH4gxZYmVgZTdbjmlivxsao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJZaVZi2c13oz+gtXkGkMMV6jspFfRIHxpSQG2SnIWeyvrBLxELxcto1GJ4e3rX02
	 Qgwj493wvDsVv34UQFGucO6HAk3MwdM/rFd3KMpidX6zkL/UO/Od3XNwYAz9omemMS
	 qmdRHr4OZvB5d8X1f0hLQbOjjF0o64lXRAc5dJYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/265] x86/fred: Correct speculative safety in fred_extint()
Date: Thu, 12 Mar 2026 21:06:39 +0100
Message-ID: <20260312201018.610631591@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

[ Upstream commit aa280a08e7d8fae58557acc345b36b3dc329d595 ]

array_index_nospec() is no use if the result gets spilled to the stack, as
it makes the believed safe-under-speculation value subject to memory
predictions.

For all practical purposes, this means array_index_nospec() must be used in
the expression that accesses the array.

As the code currently stands, it's the wrong side of irqentry_enter(), and
'index' is put into %ebp across the function call.

Remove the index variable and reposition array_index_nospec(), so it's
calculated immediately before the array access.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260106131504.679932-1-andrew.cooper3@citrix.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_fred.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index f004a4dc74c2d..563e439b743f2 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -159,8 +159,6 @@ void __init fred_complete_exception_setup(void)
 static noinstr void fred_extint(struct pt_regs *regs)
 {
 	unsigned int vector = regs->fred_ss.vector;
-	unsigned int index = array_index_nospec(vector - FIRST_SYSTEM_VECTOR,
-						NR_SYSTEM_VECTORS);
 
 	if (WARN_ON_ONCE(vector < FIRST_EXTERNAL_VECTOR))
 		return;
@@ -169,7 +167,8 @@ static noinstr void fred_extint(struct pt_regs *regs)
 		irqentry_state_t state = irqentry_enter(regs);
 
 		instrumentation_begin();
-		sysvec_table[index](regs);
+		sysvec_table[array_index_nospec(vector - FIRST_SYSTEM_VECTOR,
+						NR_SYSTEM_VECTORS)](regs);
 		instrumentation_end();
 		irqentry_exit(regs, state);
 	} else {
-- 
2.51.0



