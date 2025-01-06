Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8942186332;
	Mon,  6 Jan 2025 15:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178992; cv=none; b=jmcFoKoqTuE/moJzEAzX2MAo1zOHrmHhU/Y4yWhETFVvgQuyiY8+QHhkczbWNi5i30XgT3DiLKsl9rfnNPKLym8KDZuaj9onehFnxBKdjQzh2NUVKAATKeVsbhSGubvQrvHnuG1hNnvVyxsCsL6NVyPi0tTQoDPRzWXhbg+SmdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178992; c=relaxed/simple;
	bh=V9f0zbSmswK12sNXLvuM43kKBuj6R7JYlPqbiJy85O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/DfuwpUHMt0eOb0UjriAVpTdXjP+APIwVZRwABGy1TGAHL6LP20VPLcUd7iK6wp7KotMtmXNWbjKF48FYkYOfEhF2gzJqxbZ1m8kRUmV5fmbR2L50Bx6rUTOv7uPeI4MhlqZXKjj6Opw5nEOd/zVfsgZVbpilC7138P5Z3S9VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvDVsr9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvDVsr9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3A9C4CED2;
	Mon,  6 Jan 2025 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178992;
	bh=V9f0zbSmswK12sNXLvuM43kKBuj6R7JYlPqbiJy85O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvDVsr9bQEefuqZT9jCHIbPY2bGDhRyKqUvBhwFjD9+bpFmATg9O4bAYFctzikL4Z
	 7/Tw1Wk9Eo1GoxDjqpk+RJbn7uQNmWLE/SkhfsrnyQmy03wFym7cqwIwEQhv4WxyN8
	 zeI0IGwK7JoMHhMozBPtb6e4PBZ4atw7T2Y1x/H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/168] modpost: fix input MODULE_DEVICE_TABLE() built for 64-bit on 32-bit host
Date: Mon,  6 Jan 2025 16:17:47 +0100
Message-ID: <20250106151144.436251029@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d911485646c5..68a6b029397a 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -733,7 +733,7 @@ static void do_input(char *alias,
 	for (i = min / BITS_PER_LONG; i < max / BITS_PER_LONG + 1; i++)
 		arr[i] = TO_NATIVE(arr[i]);
 	for (i = min; i < max; i++)
-		if (arr[i / BITS_PER_LONG] & (1L << (i%BITS_PER_LONG)))
+		if (arr[i / BITS_PER_LONG] & (1ULL << (i%BITS_PER_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
 
-- 
2.39.5



