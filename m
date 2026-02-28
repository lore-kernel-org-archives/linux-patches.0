Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B14373BE1;
	Sat, 28 Feb 2026 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301530; cv=none; b=W0eiX6YI3ClHhUHkd5k1yW39yjyQlxM+NPGKIg3fCVStIBod8DY3nMg7zPf/NtiXddTghkyzGFOnts7YDh17AWz6qyYpd4//aRedUdGuKgo7zAwmRRS2FZSGq4g+Mu+sbpnjHrO1XER9EvOoiA7rNoTB7bkaUQlFUqby8O7IBYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301530; c=relaxed/simple;
	bh=tnOlQx/gRBuAvLxzGv/ocDXTRdJuzWXZPh3n12vKSOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r12xQC5xfGGgTqk1NPKDMduRGanyPlomcRJpWV6rIY6sBtLj+A87JFK6Vvx2NNrOP2Q1bVnnkkY0hvuVWRssZo7C5r59uy+yVKmMAyt0BNrukoQKXApokbSPlytMXWF/gGyIB3Ru1OgqalwPDZ2fyvH1q7/9XUDnk9pc+Pj892s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c51k+mYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c51k+mYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A68C19424;
	Sat, 28 Feb 2026 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301530;
	bh=tnOlQx/gRBuAvLxzGv/ocDXTRdJuzWXZPh3n12vKSOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c51k+mYk33P19MzxV5WnBEgtBV6xbz3X9nhjGNrZhrY7gFkJn6qWxBTAVvWfhHFSG
	 VyTUVjeXgk8isoxKhyb08VTWOe7RpUinXzwI/VLKBnx8a9bxbwCAcHe/ywDCLSX93E
	 LC3V6nepCplEGk0WJODwHno/fGqX10XRc2WaiiP7PdoRxgqZbITqiSIXplJhZBBKxJ
	 8D6zaVwK7ageQefCg6poaJxOlBxPpSrDobQc9qDmeKnrPFvIQ5x/ijt78RcM0uD4zA
	 LcyUGhk2cpoB0kaQbhq6F4M4z3BUcmSkOKuKh+jXKox18xPHBfgBWq8Ng70WxnTf2+
	 JaFCMmwK8Z6mw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shengming Hu <hu.shengming@zte.com.cn>,
	stable@vger.kernel.org,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 712/752] function_graph: Restore direct mode when callbacks drop to one
Date: Sat, 28 Feb 2026 12:47:03 -0500
Message-ID: <20260228174750.1542406-712-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shengming Hu <hu.shengming@zte.com.cn>

[ Upstream commit 53b2fae90ff01fede6520ca744ed5e8e366497ba ]

When registering a second fgraph callback, direct path is disabled and
array loop is used instead.  When ftrace_graph_active falls back to one,
we try to re-enable direct mode via ftrace_graph_enable_direct(true, ...).
But ftrace_graph_enable_direct() incorrectly disables the static key
rather than enabling it.  This leaves fgraph_do_direct permanently off
after first multi-callback transition, so direct fast mode is never
restored.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260213142932519cuWSpEXeS4-UnCvNXnK2P@zte.com.cn
Fixes: cc60ee813b503 ("function_graph: Use static_call and branch to optimize entry function")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fgraph.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 599f2939cd940..13832ff06c96c 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1311,7 +1311,7 @@ static void ftrace_graph_enable_direct(bool enable_branch, struct fgraph_ops *go
 	static_call_update(fgraph_func, func);
 	static_call_update(fgraph_retfunc, retfunc);
 	if (enable_branch)
-		static_branch_disable(&fgraph_do_direct);
+		static_branch_enable(&fgraph_do_direct);
 }
 
 static void ftrace_graph_disable_direct(bool disable_branch)
-- 
2.51.0

