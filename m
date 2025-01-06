Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC8E7405A;
	Mon,  6 Jan 2025 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177629; cv=none; b=gz+US8UIvDymOW96s8f6Oa60rNbQ/zCC3TnRQzjsJsCWRHwDD+4zYcZJ9y7oXtM0ZP/xQrAoKLCSFzK49Cs5xADF0bWexu+s9Ew7Dwx0OpTeoqF28nos6LBclT70kmW9KG+rc1Fbw1lwlkg6jKxzdwJQ5b1cmOZM/F8gJ8jq3Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177629; c=relaxed/simple;
	bh=mCdEhtJ55N4cy4O8F6i9fSZ4IvCa4szkwtMh2y8EqQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQNzTRJ0imjfDK6L1M5zz5ci+keC9wa3kGjPBoKWIy6NsHE0LAe6agC8I98w+tW22uIXLvOfCLRJiY/FsvuUsuK5++YQacXS52k273ymozWZFGA1MQ/x+qiXOaTMhLHVBQcf+gIboQUCCN1C4lr2KpV2dntZlLKS0G5u5KD3Ir0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqOEfzMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqOEfzMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D498AC4CED2;
	Mon,  6 Jan 2025 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177629;
	bh=mCdEhtJ55N4cy4O8F6i9fSZ4IvCa4szkwtMh2y8EqQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqOEfzMvK34G6rCxPfCcswtvoXCpHR7CEskCAdV48qwGDQmAzidUTNpF9vcopsTzO
	 nI9CY+KLB65nnKSQFNfALorpqgOXW105xapISo14skPgfcLKDzJe6+PQh89fGjcVJk
	 399fkyWh/bRl+brdLwty02GNdwg847IXPfDoSo58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/222] modpost: fix input MODULE_DEVICE_TABLE() built for 64-bit on 32-bit host
Date: Mon,  6 Jan 2025 16:16:40 +0100
Message-ID: <20250106151158.180834407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 77dc55a978e69625f9718460012e5ef0172dc4de ]

When building a 64-bit kernel on a 32-bit build host, incorrect
input MODULE_ALIAS() entries may be generated.

For example, when compiling a 64-bit kernel with CONFIG_INPUT_MOUSEDEV=m
on a 64-bit build machine, you will get the correct output:

  $ grep MODULE_ALIAS drivers/input/mousedev.mod.c
  MODULE_ALIAS("input:b*v*p*e*-e*1,*2,*k*110,*r*0,*1,*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*2,*k*r*8,*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*14A,*r*a*0,*1,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*145,*r*a*0,*1,*18,*1C,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*110,*r*a*0,*1,*m*l*s*f*w*");

However, building the same kernel on a 32-bit machine results in
incorrect output:

  $ grep MODULE_ALIAS drivers/input/mousedev.mod.c
  MODULE_ALIAS("input:b*v*p*e*-e*1,*2,*k*110,*130,*r*0,*1,*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*2,*k*r*8,*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*14A,*16A,*r*a*0,*1,*20,*21,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*145,*165,*r*a*0,*1,*18,*1C,*20,*21,*38,*3C,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*110,*130,*r*a*0,*1,*20,*21,*m*l*s*f*w*");

A similar issue occurs with CONFIG_INPUT_JOYDEV=m. On a 64-bit build
machine, the output is:

  $ grep MODULE_ALIAS drivers/input/joydev.mod.c
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*0,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*2,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*8,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*6,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*k*120,*r*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*k*130,*r*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*k*2C0,*r*a*m*l*s*f*w*");

However, on a 32-bit machine, the output is incorrect:

  $ grep MODULE_ALIAS drivers/input/joydev.mod.c
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*0,*20,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*2,*22,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*8,*28,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*6,*26,*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*k*11F,*13F,*r*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*k*11F,*13F,*r*a*m*l*s*f*w*");
  MODULE_ALIAS("input:b*v*p*e*-e*1,*k*2C0,*2E0,*r*a*m*l*s*f*w*");

When building a 64-bit kernel, BITS_PER_LONG is defined as 64. However,
on a 32-bit build machine, the constant 1L is a signed 32-bit value.
Left-shifting it beyond 32 bits causes wraparound, and shifting by 31
or 63 bits makes it a negative value.

The fix in commit e0e92632715f ("[PATCH] PATCH: 1 line 2.6.18 bugfix:
modpost-64bit-fix.patch") is incorrect; it only addresses cases where
a 64-bit kernel is built on a 64-bit build machine, overlooking cases
on a 32-bit build machine.

Using 1ULL ensures a 64-bit width on both 32-bit and 64-bit machines,
avoiding the wraparound issue.

Fixes: e0e92632715f ("[PATCH] PATCH: 1 line 2.6.18 bugfix: modpost-64bit-fix.patch")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: bf36b4bf1b9a ("modpost: fix the missed iteration for the max bit in do_input()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/file2alias.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index efbb4836ec66..96f37fe1b992 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -743,7 +743,7 @@ static void do_input(char *alias,
 	for (i = min / BITS_PER_LONG; i < max / BITS_PER_LONG + 1; i++)
 		arr[i] = TO_NATIVE(arr[i]);
 	for (i = min; i < max; i++)
-		if (arr[i / BITS_PER_LONG] & (1L << (i%BITS_PER_LONG)))
+		if (arr[i / BITS_PER_LONG] & (1ULL << (i%BITS_PER_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
 
-- 
2.39.5



