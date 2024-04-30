Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317A812B176;
	Tue, 30 Apr 2024 11:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474811; cv=none; b=FGDtYpHGzgvwb6lqtT0VV8i9cI54UVm3O9J2r1upAoavxFBXD9YJG8UkULfA9RFN/gBfaXRYT4Uv12TsUjcymunbbwZqF7Wtv2OGYPpZ69PvD8+JjCEKwuepOS1wFlspSpHpYSOu50IJgE7nL162vNiGZ4C51uG4kPsG/nZPPBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474811; c=relaxed/simple;
	bh=BNwzCBwBI1HVIXt2fgxgTCmZbNyNveGeW3myR31XIVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxHSIigcDXTsI8iSr+y8rBJsciGq6CXKfk40AbGjrIwfJKqHso5a0H5hT/adfboqrXBYJ917Q1C4lQxP86NMMdqNWIht34joU2Qy/t3vUrD8XhCGuh+L2lgq5nQ1U3yySUhvuhpNpEKXgqyG5rXRkSktU35iBOYsfnDU2NIxlpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfHrddD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfHrddD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E1CC2BBFC;
	Tue, 30 Apr 2024 11:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474811;
	bh=BNwzCBwBI1HVIXt2fgxgTCmZbNyNveGeW3myR31XIVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfHrddD5U5ra+wbR95hk7WKY/VmCk9sT9AaYkmKUhvMnub/ykQvrjRgUMj0WPgvXs
	 eAK9w1JvmajR5Z6a2D4Nu6HreSIK099x0MSCMzFw3K5AkOOa6xKnjVdtxlL0OD2rxZ
	 v+re8+Twws6dgl6rkuN2wK6GlCruAJnTJheMAzuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/138] u64_stats: fix u64_stats_init() for lockdep when used repeatedly in one file
Date: Tue, 30 Apr 2024 12:38:11 +0200
Message-ID: <20240430103049.612359405@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,7 +116,11 @@ static inline void u64_stats_inc(u64_sta
 #endif
 
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


