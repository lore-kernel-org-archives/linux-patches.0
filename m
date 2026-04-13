Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4D3225A38;
	Mon, 13 Apr 2026 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097832; cv=none; b=pUiWPDHqNElGf4PXazemOR3P8PctZcqI6ZuBWKZKoQi4M+x+pYQ8gZL287cxk9rbcWTVpl2L4ocsBJaOR26NRVz+1dfKYLHGW3khI5ITzimIH/RPAQ14rdExtlDfEgOnRp2X9zGUjoRygVmOvz2HBlAuwkqiHRl9vJtKwILTBvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097832; c=relaxed/simple;
	bh=waBgr2b8lMFGt7F225g3CKNb3zdmRsbZP20npuYyfFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Npji2pDziEKDR9aiLV04+kvtFBVV1JmPhBNOmjZaNYF7H+tV0DCkc9uXrfIy+Z0CZ4Giq7xMjJx9iFJEKtX5gmrDwt9SNnKYatiAOve4R3FZbFHpyuEFA9mlheAw1+Qmb+zAAKvNh8z94WoraywyQ5+oTb4PgO7/yKkSiIv1WaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7V2t/kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7V2t/kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF69C2BCAF;
	Mon, 13 Apr 2026 16:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097831;
	bh=waBgr2b8lMFGt7F225g3CKNb3zdmRsbZP20npuYyfFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7V2t/kt7xqcv43/hZvkCy20cxNeN13dNaJuUf/8YCYNu+yxrGH8gg0GyykdlUivc
	 NX3cFV9pkMq2Rq1x4TIzAvt9szGNnmI5wvqTn+Vnv/by2Tgx5Mhx4UrfU/c7EK0Lz9
	 awxahiDsSQ3l4wpSv7bT3JlGGPryzLJRCR2dzmig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/570] lib/bootconfig: check xbc_init_node() return in override path
Date: Mon, 13 Apr 2026 17:57:00 +0200
Message-ID: <20260413155841.317923236@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

[ Upstream commit bb288d7d869e86d382f35a0e26242c5ccb05ca82 ]

The ':=' override path in xbc_parse_kv() calls xbc_init_node() to
re-initialize an existing value node but does not check the return
value. If xbc_init_node() fails (data offset out of range), parsing
silently continues with stale node data.

Add the missing error check to match the xbc_add_node() call path
which already checks for failure.

In practice, a bootconfig using ':=' to override a value near the
32KB data limit could silently retain the old value, meaning a
security-relevant boot parameter override (e.g., a trace filter or
debug setting) would not take effect as intended.

Link: https://lore.kernel.org/all/20260318155847.78065-2-objecting@objecting.org/

Fixes: e5efaeb8a8f5 ("bootconfig: Support mixing a value and subkeys under a key")
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bootconfig.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/bootconfig.c b/lib/bootconfig.c
index 0579a93cb163e..9873c6372adca 100644
--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -646,7 +646,8 @@ static int __init xbc_parse_kv(char **k, char *v, int op)
 		if (op == ':') {
 			unsigned short nidx = child->next;
 
-			xbc_init_node(child, v, XBC_VALUE);
+			if (xbc_init_node(child, v, XBC_VALUE) < 0)
+				return xbc_parse_error("Failed to override value", v);
 			child->next = nidx;	/* keep subkeys */
 			goto array;
 		}
-- 
2.51.0



