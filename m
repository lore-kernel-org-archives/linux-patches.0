Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F58B481B8;
	Mon,  1 Apr 2024 17:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991056; cv=none; b=SZIRhrRg5Xm2m6a/DEgBOG2Azvmj/+dToi/jMXZMgzMQUGnCi3u1cgEEHL5c60/Q2mI8xnumn2dK1yvFvDExfFHw1AugjRkDXBWR7bj41kXwhb3s96SETa/dtCWx36u+ddfsbv0D4MpwbX4WqqU38iDaUv5rQ/ob7ejxd697ZxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991056; c=relaxed/simple;
	bh=1LsX67bh+k+NJiR2MW66xSkuZB5N+ZSCN0ojOi1D/4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdVVfRfVzeU8Uq5FGwYuGCUexQwm8MUCz/N0NUkBe+CPzxmkZKjGvntPcyrvUIMqm/CDlqoOV7fWYmTjYuUml7KZdvQaxjeNdXzBzDFUuzIDxktJoPDEzFICBbM80C8rDMjldTWMPTYwu4fX2NVb10ZlkKlypwVIgQMOtyK6YTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ+yFVrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ+yFVrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B45C433F1;
	Mon,  1 Apr 2024 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991056;
	bh=1LsX67bh+k+NJiR2MW66xSkuZB5N+ZSCN0ojOi1D/4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ+yFVrM653FiM1p2lafduDyK2f8JML+rpIZw0aObV3RDqjGclPGOQu3DtmsEJmr8
	 sDubGjCEDCSWKAJPrvP1bFI+ejDhGAGj8nCGRli9Jwxij2wRpEedcAUDWumhLeZXKC
	 QoJAqidqAILY6kk9/cMWJlEDCheSXGdlMkGO9Lv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Zhang <qiang4.zhang@intel.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/272] memtest: use {READ,WRITE}_ONCE in memory scanning
Date: Mon,  1 Apr 2024 17:45:10 +0200
Message-ID: <20240401152534.416904078@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Zhang <qiang4.zhang@intel.com>

[ Upstream commit 82634d7e24271698e50a3ec811e5f50de790a65f ]

memtest failed to find bad memory when compiled with clang.  So use
{WRITE,READ}_ONCE to access memory to avoid compiler over optimization.

Link: https://lkml.kernel.org/r/20240312080422.691222-1-qiang4.zhang@intel.com
Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memtest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memtest.c b/mm/memtest.c
index f53ace709ccd8..d407373f225b4 100644
--- a/mm/memtest.c
+++ b/mm/memtest.c
@@ -46,10 +46,10 @@ static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size
 	last_bad = 0;
 
 	for (p = start; p < end; p++)
-		*p = pattern;
+		WRITE_ONCE(*p, pattern);
 
 	for (p = start; p < end; p++, start_phys_aligned += incr) {
-		if (*p == pattern)
+		if (READ_ONCE(*p) == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {
 			last_bad += incr;
-- 
2.43.0



