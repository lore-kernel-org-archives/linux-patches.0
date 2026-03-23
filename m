Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25222798EA;
	Mon, 23 Mar 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279381; cv=none; b=HHoEuGq95XyuidDp4gBDDkUnYL4eAQ9pKDALjiEmTTdjGWc/X+30miTXFEDJgR+WUjNCCU71t+d6KM/OBQzN6D6skesx6p5DiGYBqdeUNLSbLOnaFLTb4cWLybJdzH0YnXWGeSLCYx1sBDx88KMWaMGNWPe1B1mWtuT0jKiorMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279381; c=relaxed/simple;
	bh=rH8H45XR/jsBU6tocEnGDrbi+T4XXSm94uLLKTIF2ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPoz9xeoTlhDyXeLaPGD2QtK2k0PGqdRcSsnDT1tMls/gF2rh6wH2zg4EiW7y4iNh9PXmQpoMQvRq0P+cGLFwddH7drwfWFpcsTATRLoGUhJKzZvj4QIGXVCkxD/z0h9B2hVn+ibLWNBx6YSZ16kQ9z+IN/+Lkup6rjyEsneNQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a626mswN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a626mswN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267AAC4CEF7;
	Mon, 23 Mar 2026 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279381;
	bh=rH8H45XR/jsBU6tocEnGDrbi+T4XXSm94uLLKTIF2ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a626mswNM1ZcRoKntwTyubkmf36k8Z1qKVSTvnoVVXWvZ90N+j/PpujKFRscUmKyI
	 sQ9JhimL5r+BnjLaAK1iUV0am/J2u46i7vVMhSw7fHJqq7keSd8m5do8hTvlEn+eUU
	 bWoZKCNPYfXtfrSpfbIyrNZbzgf2swcglN8J1woQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 566/567] lib/bootconfig: check xbc_init_node() return in override path
Date: Mon, 23 Mar 2026 14:48:06 +0100
Message-ID: <20260323134548.024512476@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 82f21a9b0aaba..675f34cf32f0d 100644
--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -714,7 +714,8 @@ static int __init xbc_parse_kv(char **k, char *v, int op)
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



