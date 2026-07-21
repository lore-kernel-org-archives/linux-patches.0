Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1036446EF6B;
	Tue, 21 Jul 2026 18:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658725; cv=none; b=qlbfI1gySpXc6/ijgN3iWi3eRL1TzIh3JbbvbrEBRHBFTslNSQci3+cwsXgxerGoEA/wtqT7WsRrNFqloZvJYkM0McuvV52hYmkkvcMZG6lrsuOyryH8npb8B0UeVh+qporosuAAvY9QYaC21M4dkWT/2FEnvZjv+OycWhj0Rmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658725; c=relaxed/simple;
	bh=l4oEDuAMMbg473YtOZjg8VtYwRQ1z/4NeA193gxQEJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Of5nRKn1F4O9LTMj+6D4WkkFXbKV08TW1VF7rX9Oj64gumlhQ+AeQzhZLTlXkBOjyiZ2ZMzHu7cZXPBto/2cigoh7g6+ukb8TInYl7/nMFp9Zv+yHJ1U69PuRAssGlV8sgqMQ51GkVQo1rpusc7PFvh3Oc41fHd/FbTyYIJ6ZNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7HtTqps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7HtTqps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3078B1F000E9;
	Tue, 21 Jul 2026 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658723;
	bh=sWJV5SjxCoOKBzfKoIT0xzDwaPl8yWP2fplYxH+ngbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7HtTqpsCaBhcTp7bC4XTJOSG6atKYTXohvXJsB+gcEBaQ48MEm5FCTUTwcsVW7XT
	 rv9Sb+VRqHWtS9GW8XhGMC2pl2xaQiSa4KUtRAlXUc+6d40ck2hMvX8YriPx6/LQiK
	 h1Kq5WZ526GEze7IZ7fcltfeDvgxWgk+WT6MiJk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zishun Yi <vulab@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 1249/1611] riscv: cacheinfo: Fix node reference leak in populate_cache_leaves
Date: Tue, 21 Jul 2026 17:22:45 +0200
Message-ID: <20260721152543.537375512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


