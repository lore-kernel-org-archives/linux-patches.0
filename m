Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0AC235045;
	Mon, 23 Mar 2026 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277488; cv=none; b=Hy5fVCLfM99xf3DMSl3+6MvJAst5dtaI1hMEzALlWGOWjAWoh+DlYkF7zytYFfzFarkmF7xGhLlbVY/Rk4naTFJacwRHEpLZkRfjzD2xj5S7XzmPIAjAqmfoExQgMAQioI1nfeA+rCrlKrgdbUWFZoFgsdI4f7CEdBHU6AB1vFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277488; c=relaxed/simple;
	bh=zGXWkGWg+NRAQ0Ts9lNXxo5bDRUnFP1kjALYpxlIr/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmHiiwaQVoemcYhcr/uR/VJ/bCXHgGs1ApdDstT3THG01xxifeAwzn3piYE3+k9vLk//+Z9YeP6b2P/bpUEPkux2BY1KSuc1WQd0jC7OnCWgd//UIYL5RRF29yCRduCoKJZBUt1zJB7CDEMY6YrMCDThakWQMvwCMWLJ/Pp7I24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1dcYu7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1dcYu7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2097C4CEF7;
	Mon, 23 Mar 2026 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277488;
	bh=zGXWkGWg+NRAQ0Ts9lNXxo5bDRUnFP1kjALYpxlIr/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1dcYu7jHmQafaWLKhpV9ITk71BLokSSm5meMVxmG3ngMb0gr+KANpckI6kyDFGBS
	 qUpxmwFpZGaP1wUN87hUnCVwSem/ZEJg7suFa7KJItnVFK9Fz6oWWPYzyBVUngEez/
	 0FEMdJPw6G/647EdvO3VyQsX4pj0oY59MqkJ6KNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/460] lib/bootconfig: check xbc_init_node() return in override path
Date: Mon, 23 Mar 2026 14:47:33 +0100
Message-ID: <20260323134537.805805516@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



