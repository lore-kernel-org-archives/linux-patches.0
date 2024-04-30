Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1215F12C48B;
	Tue, 30 Apr 2024 11:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476127; cv=none; b=fdjokKQJbFt2kogxl9RBiAIoWLQw98fCUy7VjstP2YkJDbzwNFah6su2ka7SrxFmWap8WRZoTcuj2gbf3JGW+RFjoD1oU/bWaEBCHv3VD0mD2TmhCTu+NXI0KB2DqeY2jhFWaISn4Iy4JWbmwpAcD5jAFSfye+G0qiyyXr1ytoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476127; c=relaxed/simple;
	bh=r01qXQzCioYTOwq41XnTsjEF207pFzqgiCXrRPpUvh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SX5brAJ2qUdjdjskA5p7ab0bNP4DHrCd7j8c1DjZkDFDFGSx2FngZ6vf4tS/8jkR9jsNyNDvoocZD0siGoRo7gF5BUeWUlfrbzil/VCTbD88HAdMkJ9TjwDfPMPdVL6aNhpBnpy3PdG4tidrTTAAL9s5UF2qhm3KSKW0pCdvPho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHxcAre+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHxcAre+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778DFC2BBFC;
	Tue, 30 Apr 2024 11:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476126;
	bh=r01qXQzCioYTOwq41XnTsjEF207pFzqgiCXrRPpUvh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHxcAre+ZOEMsInRSNdeAYapDUZGkbXGpdQ5mDToe19CC6Pkdsna76jFSrI7qNws1
	 LDuFIslQI5mkmm0y7UIhn+l6BhpRp/FeJ4D5kd+pfW/M2txoeeQf7dWXDkCdheOwYM
	 U04NFyWHnYoeBg0QQ+wSo/vuwOGVLWXV8/jZA3DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/107] u64_stats: fix u64_stats_init() for lockdep when used repeatedly in one file
Date: Tue, 30 Apr 2024 12:39:25 +0200
Message-ID: <20240430103044.816720381@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Tesarik <petr@tesarici.cz>

[ Upstream commit 38a15d0a50e0a43778561a5861403851f0b0194c ]

Fix bogus lockdep warnings if multiple u64_stats_sync variables are
initialized in the same file.

With CONFIG_LOCKDEP, seqcount_init() is a macro which declares:

	static struct lock_class_key __key;

Since u64_stats_init() is a function (albeit an inline one), all calls
within the same file end up using the same instance, effectively treating
them all as a single lock-class.

Fixes: 9464ca650008 ("net: make u64_stats_init() a function")
Closes: https://lore.kernel.org/netdev/ea1567d9-ce66-45e6-8168-ac40a47d1821@roeck-us.net/
Signed-off-by: Petr Tesarik <petr@tesarici.cz>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240404075740.30682-1-petr@tesarici.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/u64_stats_sync.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -70,7 +70,11 @@ struct u64_stats_sync {
 
 
 #if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-#define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
+#define u64_stats_init(syncp)				\
+	do {						\
+		struct u64_stats_sync *__s = (syncp);	\
+		seqcount_init(&__s->seq);		\
+	} while (0)
 #else
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
 {


