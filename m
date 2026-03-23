Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E0C3AF663;
	Mon, 23 Mar 2026 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274455; cv=none; b=YxiVMwrypBecuUiSyo4ngrP+tPgTzBnRP5zl0xcDsL9n6JpSGEg2w54CHWpJsaxK+0ieU3nWLPFWlsrc7WvshnZ46l0p+WTWTG9yTeSTFhbH06IZZSpKMsB/B5K48bg2UBKvZwiPRAxt2ZXevSl7c95r/sbW8aJpwEDlzy6adEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274455; c=relaxed/simple;
	bh=hzooUPDQxlACs3KtTkbKOoAgHzxlo0wDdYB8zGWXP9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbvprHq4T1Zmd0HhVgZrk4lubCTNCdm0Hs7Khv3ayF5ZJszjO9IGK6qNZKVDaUYw4NJS6YrOYrX6RidF7MbRYfvxCTjngW4aA4NqqmNiImWKgO1/xH4Euf30dYKZ4v+M91a1+KIN+GC5OlQtRU6gzPJjIDbx2mWxNqHsepcNZR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8Mdv80u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8Mdv80u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECD1C4AF0B;
	Mon, 23 Mar 2026 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274455;
	bh=hzooUPDQxlACs3KtTkbKOoAgHzxlo0wDdYB8zGWXP9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8Mdv80uu1V8wMnBb0Bd2TJbTxw+rFdAu/MXPJIGZ/nRSrTftttX+L2tleKKRoYaN
	 YrK3fFV/sUsqZiXq1WYOaWU1djb+2VRHX2beZu3LC9cZPvvyfUfKNVE12MMJQ5DOv8
	 iXgXSKII4g/2vHzDtJjtXGvifwz1RT83BoTj+N7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 216/220] lib/bootconfig: check xbc_init_node() return in override path
Date: Mon, 23 Mar 2026 14:46:33 +0100
Message-ID: <20260323134511.342093798@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0728c4a95249b..5d3802eba52a3 100644
--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -712,7 +712,8 @@ static int __init xbc_parse_kv(char **k, char *v, int op)
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



