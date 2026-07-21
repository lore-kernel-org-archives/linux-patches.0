Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B04A386C1C;
	Tue, 21 Jul 2026 20:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667248; cv=none; b=GQD1t/LBhtJwYGq/CrQ3QhxAli6Ipc1QB6+wg9BESPrg7LfzcBDarKun9tY+s2kF+ZEY8/6jpl3RLx9Ua+Ykh5I6Kj0tYUtbqoTIYMpLFlc6Q8cZrUf2O1apVPVF9awulovTVA9UmHVL59aCyzLqZ0Gq0gr2Xa7cg/gTDPI6ONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667248; c=relaxed/simple;
	bh=ayBPE9GxJbENZ3XtrCarAO0AotfNAG7qAPVopJWP/3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJQOHEJxICqWo1Z7n9XhsVAGqX//nZKjWbtuxZzhECqKE7K2wM/p89/ZTLWd5E06CIDTj7GqlfZhDkzR8XkytFUDK6GAIEr7SBc1nfcNe/WmwuLK/4GZZXF02pp6mAODY8fg9rreyGgK6PL79TAZDjQIT8Gz2nUOyKwXvg9sKp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srODm3qj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srODm3qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07651F000E9;
	Tue, 21 Jul 2026 20:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667247;
	bh=QEwnK3D8qW104WJdahxgFwqEilbASXlIVxOSD/gJ5gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srODm3qjf10hOZDR2AdgOy4ACdW74+CNgRHCvxOzTZ3PyriooRjtUo68bNRLHMKvy
	 v7UiSLRBN/DQpCKUhjSX3tCGjrC7D9zTmSgTpJ2Gt2Klp3jEBDEgnuAmjkgb1oEWP/
	 cIazae379psZwlD4CUZAuQbrYLz/avZkhEiRV4yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zishun Yi <vulab@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.6 0989/1266] riscv: cacheinfo: Fix node reference leak in populate_cache_leaves
Date: Tue, 21 Jul 2026 17:23:46 +0200
Message-ID: <20260721152503.965606718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Zishun Yi <vulab@iscas.ac.cn>

commit bf4a195f063b0a0805c1417f6aad1dd32ea48f0f upstream.

Currently, the while loop drops the reference to prev in each iteration.
If the loop terminates early due to a break, the final of_node_put(np)
correctly drops the reference to the current node.

However, if the loop terminates naturally because np == NULL, calling
of_node_put(np) is a no-op. This leaves the last valid node stored in
prev without its reference dropped, resulting in a node reference leak.

Fix this by changing the final `of_node_put(np)` to `of_node_put(prev)`.

Fixes: 94f9bf118f1e ("RISC-V: Fix of_node_* refcount")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Zishun Yi <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260509074040.1747800-1-vulab@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -128,7 +128,7 @@ int populate_cache_leaves(unsigned int c
 			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
 		levels = level;
 	}
-	of_node_put(np);
+	of_node_put(prev);
 
 	return 0;
 }


