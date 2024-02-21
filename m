Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F160C7A715;
	Wed, 21 Feb 2024 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523958; cv=none; b=smjfK024yeL696K0xLSHoMAGHVZcoESKW2khL56HVlMF2Sx0NDFoz6evwdr6ITZ8sdtlooL8IqjccLTmumWQ6swvjuAPHQPjzcv6M9BZHKpNqRMvpHiV5hHU9vHz1AzmHBeQuqNDdTEW7SX57BfP0aKmeLwxrpSUPUb4e9w4jGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523958; c=relaxed/simple;
	bh=1Puf68lSKGsC4COo1wLH1BOy4YV9KKnAjSG/W93kwrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XMl35i3FnuOgtVHsWCap6IHyf3CJw2z9Q5CpGeqopLbE82Y1BC/i2XsK5WnARrQWWLHrqjgOzE+JqbZHEvJcT1GPl2UdsWyiE6DwLJht6XmFzY9BoGCTO4T+jCuNw6z3LkXGnkDKv8kBrMJ3Hx2miaetKM27uvbz2GM5bz7FIZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1qQGwGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1qQGwGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CA8C433C7;
	Wed, 21 Feb 2024 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523957;
	bh=1Puf68lSKGsC4COo1wLH1BOy4YV9KKnAjSG/W93kwrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1qQGwGh6xjYj46bKf9XQHa0GXwD3U+Jq3UZvUFz45ADyWbVI0ssyOoDDzC+GbDK6
	 8OMHm2TXhRc5fjUY+NvCzdvetnsC7GR0x6F/eOXeCJIcIiqlz7zEUCGkLkfAfXHKpN
	 UXHtVZ75a9TPKjXOBimau7qsBlxt6jqONVDMVl28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/379] powerpc: Fix build error due to is_valid_bugaddr()
Date: Wed, 21 Feb 2024 14:04:42 +0100
Message-ID: <20240221125957.966209323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f8d3555355653848082c351fa90775214fb8a4fa ]

With CONFIG_GENERIC_BUG=n the build fails with:

  arch/powerpc/kernel/traps.c:1442:5: error: no previous prototype for ‘is_valid_bugaddr’ [-Werror=missing-prototypes]
  1442 | int is_valid_bugaddr(unsigned long addr)
       |     ^~~~~~~~~~~~~~~~

The prototype is only defined, and the function is only needed, when
CONFIG_GENERIC_BUG=y, so move the implementation under that.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231130114433.3053544-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 5e5a2448ae79..b0e87dce2b9a 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1432,10 +1432,12 @@ static int emulate_instruction(struct pt_regs *regs)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_GENERIC_BUG
 int is_valid_bugaddr(unsigned long addr)
 {
 	return is_kernel_addr(addr);
 }
+#endif
 
 #ifdef CONFIG_MATH_EMULATION
 static int emulate_math(struct pt_regs *regs)
-- 
2.43.0



