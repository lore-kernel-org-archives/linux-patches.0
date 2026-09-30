Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C9351A156;
	Wed, 30 Sep 2026 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784760; cv=none; b=JKgU2nBgoAcyHR1SztqbZH/FpbrF1HNhYcGFW9XQqhn2yEkbaViiTDemTcGk/kQvjZVg+g4ZbnFKtkKvp8vRgc7ljNkB7oHyTrWLCd+momSbG4Ots5QhMs85qPBjPCSVV5LwhEpk+ZkEUbYVqA+BcZmVuZKCwcxxW3eB3cYVf8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784760; c=relaxed/simple;
	bh=9PUYlcTUK5uS+er3e+sPajenawies3eqXYKVmddKgdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9qc758hH2g+FfGVSGspbVsNtOu78YpBEKIVH/9c0FDRNR70zv92+ZHZm26Kn4iUg63Ni23tvcN0Ww0NCbGtY4tMPu1kZu22uBymQW/Vn6SUz3+JKRC9pB1JtjwvtjiekuPb4xEY89qYXLiXz3/ASTG+KOQk63sGbeNW3zI40RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/mLQAf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/mLQAf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599DD1F0089C;
	Wed, 30 Sep 2026 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784756;
	bh=d1cVrQQIS/mV/h3pGXyY+lC/g2AV5DrDQrf4nBRTwEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/mLQAf33ZqaSkkhT1U29iAABuUCx1R4xoe5mI9nBxZSOFSy2dyQqtEaB9aBBhGLB
	 b0GtyAuB8mA1+V/FwGc4IsRv+ToZZ0+Cfa7iq1Qg++l4UyEXI8m9d6xc4mxPwdz7ax
	 Ka1x8JKPfnKsyn+lFfKRLolQwgNz/tqtv3BieF0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 269/982] arm64: fixmap: Allow 256K early_ioremap() at any offset
Date: Wed, 30 Sep 2026 17:16:45 +0200
Message-ID: <20260930152422.581327537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit 21fc7ec93f8b633b60d5bddef2f1529ff6b36185 ]

NR_FIX_BTMAPS is the per-slot page limit for early_ioremap(). Since
__early_ioremap() maps the page-aligned physical range, a 256K request
can require one extra page when the physical address is not page-aligned.

Reserve one extra page per slot so the 256K mapping budget is usable
regardless of the initial page offset.

Link: https://lore.kernel.org/r/08fd96fa-ee3a-4904-bd11-bb08bd90436f@kylinos.cn
Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fixmap.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 71ed5fdf718bd..491b5b43c5a1d 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -75,8 +75,12 @@ enum fixed_addresses {
 	/*
 	 * Temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
+	 *
+	 * Reserve one extra page so a 256K mapping may start at any
+	 * offset within a page. early_ioremap() maps the page-aligned
+	 * physical range, so the initial offset can consume an extra page.
 	 */
-#define NR_FIX_BTMAPS		(SZ_256K / PAGE_SIZE)
+#define NR_FIX_BTMAPS		((SZ_256K / PAGE_SIZE) + 1)
 #define FIX_BTMAPS_SLOTS	7
 #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
 
-- 
2.53.0



