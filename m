Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE280344D9D;
	Wed, 30 Sep 2026 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794729; cv=none; b=o/2K85+aucWTMpa3nGygi1f8CfYp1ZilaVP7U+y9pve48SLhuq3nutPJ/BR3Nlf/+QHDjcLujE2uLdkqxcnVy6ug8D+yHKSsaFTS94gbtlHcIAeWID/r6+NP2DdVnfB+vmB/ascBa+UNYvTZgxIiJK66mlhc1C/DBXIEdM08oss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794729; c=relaxed/simple;
	bh=sfvrZ7cExWpDiapZajlDGZCMJLscoxSG9M/Ge8sG3TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRCSsuU0DdtC3B+7nWYkjzwujErrSpp042Z31n1elIeAahCrLmCs3MG4xHog9n5aUmrg+jYF2ZZcjAuSVfeGQMCI3QQoBGUmu1kYdBG3lrZ/vg9M8aTdvcSDvsgLT8p7gdUcsyvQ3VPMWdb4O/r6/fcTxkL5WrxCOwGsrJmKF48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdQp9wMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdQp9wMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6EA1F000FF;
	Wed, 30 Sep 2026 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794728;
	bh=n5vrXccyI+c/TQK+KzMD3dO/uCkKQBnrBVmBa69sDWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdQp9wMT//xzhGyRco7uP4Tkp8+Af3cmq24Tdc8VBLAKNmUPMu/ur9wtt81lzXjg2
	 lSQO7GfMqicUvbJebPhcXa0B5I/mFXnlYrSRZty1jSi5jlhxZazf7JnExI1CNVupQR
	 csgwJchfdLWjEg+HpfYJHxRAHqWEUWPieWMpF/VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0312/1193] arm64: fixmap: Allow 256K early_ioremap() at any offset
Date: Wed, 30 Sep 2026 17:16:36 +0200
Message-ID: <20260930152441.073143969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58c294a966768..42339f311bc0c 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -72,8 +72,12 @@ enum fixed_addresses {
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



