Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B0546D09A;
	Tue, 21 Jul 2026 19:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663833; cv=none; b=bkRoaJ3Ub/3hgKAkXplCzNBXGG9Ho4ghMRIUtqaEqYT6+WGhOp8yRLQK5ZDgRErAQtycIZ7ysaegXytiTHiOI8fH+lAGG/stwTfEGB9HRPhu8Xi2j6r2LSJW0NXC1aJQudXPL/JfdYK4H0qatSAOcYz+XgpyZFr6cucP2ZCK+RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663833; c=relaxed/simple;
	bh=qf8bjx+tagyzZZRIk/vRdmA14zXst95E68YWKjOieDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taVSH5QVWth1a3AZRQFaJio5YDfywl0VicfZ7QyfMoeq3Wo0HAweBG3x8xioF4M0ziIXa8Vy0jyUgQKMW0qyQpmI5aU6UamUsTLVXzgNrLjTrScGdt4lDccdbOmDAC8r6HddBFqWAzAVdhUncAfaKv1zEzk9rbyHBaCm309mI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8UjrCQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8UjrCQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9DB1F00A3F;
	Tue, 21 Jul 2026 19:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663832;
	bh=o0dpw2VUZJvbxasH9zH/rOes+JQJKqpAmfw/avaKLfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8UjrCQuF2XyHForDv2U/ZeXWqA7m/ykJw0t6o1zwkX49fWC/POv4wA2THEIpb9m8
	 D+KN9feX/h5i0k74OmVpSd09/ns4yvmU8YxD3Zr0CYAMFunsK6SFdbaZ1orQojVP9N
	 oX2PU3Whjge8+6H9gusTZFjW9TSo8ObbBPMT9vQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zishun Yi <vulab@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 0929/1276] riscv: cacheinfo: Fix node reference leak in populate_cache_leaves
Date: Tue, 21 Jul 2026 17:22:52 +0200
Message-ID: <20260721152506.820309420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


