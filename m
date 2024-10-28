Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC82D824A3;
	Mon, 28 Oct 2024 06:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098460; cv=none; b=g/0rgZyInFb7bUJXMzp+TJUUbDJnqtSJIqeqeuF0r2LRRbQW0jDb9el21aI7Am+3afEM+HaX0wZ8ncFQoQmdkSQ1PhgNPp0TigWKzj8gjRkSYCsGRT0OYWkrV2bXO+TKig9o0waxS54bpU7O/2p8whmPVrSxrolizouB1vPJFvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098460; c=relaxed/simple;
	bh=uIFigDd9Mg7S0pmCa0FvLm2WXw8I8ehEezrMhwGbS64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKN41/AzLWrC02CWiwB2Ojd3ne4SmrU+RYN1erLzYJYwHGo5eYCDL2GukmLSL+ubtGEE9upnUwfHqSvHGDI2qX3Adms/nG7cZjoMuQKzZZAg0z3ZG80DrISNwyHD1plonVqzSXev+TTsoPO1L0c/VqzFNOxONBwz80usHavJYOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNZeHdra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNZeHdra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E015C4CEC3;
	Mon, 28 Oct 2024 06:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098459;
	bh=uIFigDd9Mg7S0pmCa0FvLm2WXw8I8ehEezrMhwGbS64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNZeHdrazvgLd8IWA6bUqjUJvZm+A4HoddrRtcrNqTmuzTnphMnJV4adp/OX70lrz
	 aLw54YaOQTt1Ol0IR8VSfHDc6ir/2CDoNev8qOkx+MfhyS9925kqvXvO1wPGku65OO
	 shJ8WefqrwPTM4yaPjucaK3ZahKzVG23Xsb+80ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Li Huafei <lihuafei1@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 236/261] fgraph: Fix missing unlock in register_ftrace_graph()
Date: Mon, 28 Oct 2024 07:26:18 +0100
Message-ID: <20241028062318.033207381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit bd3734db86e01e20dd239a40b419059a0ce9c901 ]

Use guard(mutex)() to acquire and automatically release ftrace_lock,
fixing the issue of not unlocking when calling cpuhp_setup_state()
fails.

Fixes smatch warning:

kernel/trace/fgraph.c:1317 register_ftrace_graph() warn: inconsistent returns '&ftrace_lock'.

Link: https://lore.kernel.org/20241024155917.1019580-1-lihuafei1@huawei.com
Fixes: 2c02f7375e65 ("fgraph: Use CPU hotplug mechanism to initialize idle shadow stacks")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202410220121.wxg0olfd-lkp@intel.com/
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fgraph.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 41e7a15dcb50c..cd1c2946018c8 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1252,7 +1252,7 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 	int ret = 0;
 	int i = -1;
 
-	mutex_lock(&ftrace_lock);
+	guard(mutex)(&ftrace_lock);
 
 	if (!fgraph_initialized) {
 		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "fgraph_idle_init",
@@ -1273,10 +1273,8 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 	}
 
 	i = fgraph_lru_alloc_index();
-	if (i < 0 || WARN_ON_ONCE(fgraph_array[i] != &fgraph_stub)) {
-		ret = -ENOSPC;
-		goto out;
-	}
+	if (i < 0 || WARN_ON_ONCE(fgraph_array[i] != &fgraph_stub))
+		return -ENOSPC;
 	gops->idx = i;
 
 	ftrace_graph_active++;
@@ -1313,8 +1311,6 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 		gops->saved_func = NULL;
 		fgraph_lru_release_index(i);
 	}
-out:
-	mutex_unlock(&ftrace_lock);
 	return ret;
 }
 
-- 
2.43.0



