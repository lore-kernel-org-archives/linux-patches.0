Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C1F3F825C;
	Tue, 21 Jul 2026 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654487; cv=none; b=YszfLocSYx2Aw4KROA0pR5PpwEE3bHRfnTvHQAhS/MXFPncsKCq5sNnVeO0ry0xcXsCmsQwp8gYRR/4hD/TTjcLkN0dS2ubXIk19qQR8VVSAKC0Y/siTeyQtYz8YWg+cBTxUMUDJeE3fhJ+9X18pIiAvrwP9lVlwcgCz7at9VBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654487; c=relaxed/simple;
	bh=seGiAKdZw+2GQNFKmQZlckUPlmxUCAhFmTHhuH85f6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trkKagxwK2y1jCVxuY6NHWohB7gJUQcLXVCWevchEbfDYJIZrj9P4UzLJjWPzfUuuCo3sq+qFeVMmn7VMdiDsTiRMHm+ktFrZun5ITiucAGlAlIBaGWcuLljHVMKRpLw4HlOCxZl0nUks1tunRStW+XUvRw8h2k7vGAALOuJHls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIoVB1wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIoVB1wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120071F000E9;
	Tue, 21 Jul 2026 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654486;
	bh=Nj56VOkbJL4PMSvg6O6xnoyBYl9cMtSDdLlld0bhjaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIoVB1wgPDrGVH3izFh6agtGXgpuXwYNCXtVzHVDq71F8N6bzPQuQXLe7GckLGL2b
	 zAq/nXCN2mGH8GkpQIYRIo+f9BCypOQMIA1sHH0GNpyK5FSd1gytoDfOdccnNCyDay
	 xkc4WEX5UymHlM6QhRoDo6qPWBnnOfsVJ6EQnGAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zishun Yi <vulab@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 1724/2077] riscv: cacheinfo: Fix node reference leak in populate_cache_leaves
Date: Tue, 21 Jul 2026 17:23:17 +0200
Message-ID: <20260721152633.415348298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,7 +133,7 @@ int populate_cache_leaves(unsigned int c
 			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
 		levels = level;
 	}
-	of_node_put(np);
+	of_node_put(prev);
 
 	return 0;
 }


