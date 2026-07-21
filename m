Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA146A5FD;
	Tue, 21 Jul 2026 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655997; cv=none; b=UVvMOnLcxLioxwI3vDUczSPXWXQA3FNNcRfGKrRvfKSkmiUzYlRti1tFS7XJSMavwToaZC9AlVmpTJ0ITYSveFkqXAOZiGfeoFSqc0PORSdZ4vqREKJQiDxbwu13A9iiZiMX6YRp3G7won5xjondfuhxNtgkRJxUAidlus/ZIag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655997; c=relaxed/simple;
	bh=Q3t2cOOkEKreNIsmIa4AKxLCcJTdcGSdCAMJ807y8ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvvGp20TnapPowYj+TvBSwcZCOyxVYuc0KcE/51WvAt970JaVzieATzwsSImCopNGMBKG0v5wbdmq+ss1Co4g5k291IKUkxfwYXZRuWpqZ177GSFhlDxsTSk8+kreVv7GDiq1gdPMku09DzvrirZvlQoPG7BltuWLX6Ec6GMVQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyCwehDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyCwehDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852971F000E9;
	Tue, 21 Jul 2026 17:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655996;
	bh=IukbQ/nznn4lH9I5lOR/78EcC2rOqohpRJ5yPt9dSOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyCwehDVHWWFY1+deCscXDRRLXQhMjjgISxQl/SPTTX1vlZp49IzumifZ91kQldJX
	 kC0GV0vImYcUJpsHskDiMntomaQROp3oeFSnEPF++rxzK29mjEE3/4WPXg2GZEDe6k
	 x0ELPJmAi/UFNSQGbetu9HTYapBA5+LtKzUrZpVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0219/1611] MIPS: Fix big-endian stack argument fetching in o32 wrapper
Date: Tue, 21 Jul 2026 17:05:35 +0200
Message-ID: <20260721152519.921146110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 8e0780d30b1b51248e42895b7acc7a20f147b40b ]

Fix an issue in call_o32() where the upper 32-bit half of incoming n64
stack arguments is fetched and used for outgoing o32 stack arguments on
big-endian platforms.

This code was adapted from arch/mips/dec/prom/call_o32.S which was meant
for a little-endian platform only and therefore using 32-bit loads from
64-bit stack slot locations holding incoming stack arguments resulted in
correct values being retrieved for data that is expected to be 32-bit.

This works on little-endian platforms where the lower 32-bit half of the
64-bit value is located at every 64-bit stack slot location.  However on
big-endian platforms the lower 32-bit half is instead located at offset
4 from every 64-bit stack slot location.

So to fix the issue the offset of 4 would have to be used on big-endian
platforms only, or alternatively a 64-bit load from the 64-bit stack
slot location can be used across the board, as the subsequent 32-bit
store to the corresponding outgoing stack argument slot will correctly
truncate the value and cause no unpredictable result.  We already take
advantage of this architectural feature for the incoming arguments held
in $a6 and $a7 registers, since the o32 wrapper does not know how many
incoming arguments there are and consequently propagates incoming data
which may not be 32-bit.

Since this code is generally supposed to be used with the stack located
in cached memory there is no extra overhead expected for 64-bit loads as
opposed to 32-bit ones, so pick this variant for code simplicity.

Fixes: 231a35d37293 ("[MIPS] RM: Collected changes")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/fw/lib/call_o32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/fw/lib/call_o32.S b/arch/mips/fw/lib/call_o32.S
index ee856709e0b600..77533cfbdfc10b 100644
--- a/arch/mips/fw/lib/call_o32.S
+++ b/arch/mips/fw/lib/call_o32.S
@@ -74,7 +74,7 @@ NESTED(call_o32, O32_FRAMESZ, ra)
 		PTR_LA		t1,6*O32_SZREG(fp)
 		li		t2,O32_ARGC-6
 1:
-		lw		t3,(t0)
+		ld		t3,(t0)
 		REG_ADDU	t0,SZREG
 		sw		t3,(t1)
 		REG_SUBU	t2,1
-- 
2.53.0



