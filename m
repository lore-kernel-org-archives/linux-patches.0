Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4281E522;
	Wed, 21 Feb 2024 13:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521309; cv=none; b=cGkaH76OseRWfuF/GFR/6rBd1yJyrOmqHCl52wK+8vwKd+oZgzUKr6nt3+7HN8j0szlp7uviTkAfxhLLd37FcGa8GXXtw5gGVrmKl9/j9BOzA5HWld5nj2r+VexGMtV+LIxrSRE1njTeejniQNfUsXdlJwjD12Zfky7eK+DZFHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521309; c=relaxed/simple;
	bh=5gM96E//o6dLnx0fnRZuZwwEsrx0qNHwEAbqRdM3shg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLMD8SgimifR0WBmcGELvxL7Sg0zNK2EoN9/PSTp3BN2uj8zdEA4bav7yu6Q7okoU/PLvLtzSAIMpZ+kkGqJxgS29od6ZNunoHx5pL/mwcLqsKD6PyoTo/Xvn6yeAWGTAdADtPuIlFHq4lYOjrJV5ARFSm5nq7Fq06rbQz6OuDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/bC8XHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/bC8XHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB907C433C7;
	Wed, 21 Feb 2024 13:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521309;
	bh=5gM96E//o6dLnx0fnRZuZwwEsrx0qNHwEAbqRdM3shg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/bC8XHtY0MLcaW/nPN5YhUk3EOIXTmaX0+/aiTIaMSMbhTBwjZk3KsftzxvR1fo9
	 HvQXxzJSSHTTNvvJ9INHQo+eh7hqEJZdpY0OPnQuulL/N2sj6gJKskZgv4Zmn6NkGT
	 Gc0N/g+OM2uHPxExSLouPNA18vL88tTf+1V6qFig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/202] powerpc: Fix build error due to is_valid_bugaddr()
Date: Wed, 21 Feb 2024 14:05:52 +0100
Message-ID: <20240221125933.486005064@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 63c751ce130a..67a00131ec42 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1341,10 +1341,12 @@ static int emulate_instruction(struct pt_regs *regs)
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



