Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CDA81ADA;
	Tue,  3 Dec 2024 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242424; cv=none; b=FENLviHSNx8XKFgdudUFtB2gn6vVgveELZFwZzjhV4sVfJQO130Eqrh7ITSphHhOdQjL9h/iJlTNRyMZCRmHiaoUDZX45TaDcISv00Wg33E9maLHJ4zR5DjMfB1Lz+AnFst57Dn1OPwr1lB1+b270MWky3JwZwH4n7O0ij3A2vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242424; c=relaxed/simple;
	bh=nbQabcspMjqnpbHybBmUePtxs3sO1zW79EkNsbCORLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYKkAqPn8oxYxAajtUQkzv1xbV21QQhvLqywXBjCuhCz9x8RpNONm+JtHlPrpscs6ez7BMMe1axAPYaGtJ7UsU3Xw+YmYGpY0Ygkx9WIUx+hg3MQBki4NRVXpCl07D0sx91mXSn+x5JZfgC5YDlADvCITXpT4eFeyaV7ZEhuSjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkxkHknT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkxkHknT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AF4C4CECF;
	Tue,  3 Dec 2024 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242424;
	bh=nbQabcspMjqnpbHybBmUePtxs3sO1zW79EkNsbCORLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkxkHknTjnX/xXjZxcCqtC6+3A7uXpXWkjEG4b1MCP7PYkr1iTyRok/uBEx1G14Gg
	 ZwO00oC3MkSQVjJWBIw4oAZ/DNPSIxk/Lz/1BPlDEnql3/mkUcf6lwu/AxaMMfg4lL
	 xjkstNABrc8OB3RmGbdsDqpRwoJRNBeAWL5weqKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 700/826] parisc/ftrace: Fix function graph tracing disablement
Date: Tue,  3 Dec 2024 15:47:07 +0100
Message-ID: <20241203144811.063589457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit a5f05a138a8cac035bf9da9b6ed0e532bc7942c8 upstream.

Due to an apparent copy-paste bug, the parisc implementation of
ftrace_disable_ftrace_graph_caller() doesn't actually do anything.
It enables the (already-enabled) static key rather than disabling it.

The result is that after function graph tracing has been "disabled", any
subsequent (non-graph) function tracing will inadvertently also enable
the slow fgraph return address hijacking.

Fixes: 98f2926171ae ("parisc/ftrace: use static key to enable/disable function graph tracer")
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -87,7 +87,7 @@ int ftrace_enable_ftrace_graph_caller(vo
 
 int ftrace_disable_ftrace_graph_caller(void)
 {
-	static_key_enable(&ftrace_graph_enable.key);
+	static_key_disable(&ftrace_graph_enable.key);
 	return 0;
 }
 #endif


