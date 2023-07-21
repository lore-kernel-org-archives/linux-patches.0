Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847E31F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095B3C433C7;
	Fri, 21 Jul 2023 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955962;
	bh=VJKZ2LfoxUqY4hb7ElEbRCo2YlzAotOcnrYIG0kdE5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/tlyzgSYDHGQ3M2Nke50VrnqYa8zzGMoUWzk9Cd/0bbInFTiNB/QJifI880vQi6D
	 k8sRC3ZLs+rtHdOOUCBlJoMuQfr0JP11jjoMpUDnR72yrY4mu+FZv/RyGqh0YpJevb
	 Bh7acOTCdIkYLVBvTC1XnML/SyZYAFovcnuY2dHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang <laoar.shao@gmail.com>,
	Ze Gao <zegao@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 074/292] fprobe: add unlock to match a succeeded ftrace_test_recursion_trylock
Date: Fri, 21 Jul 2023 18:03:03 +0200
Message-ID: <20230721160531.979955655@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ze Gao <zegao2021@gmail.com>

[ Upstream commit 5f0c584daf7464f04114c65dd07269ee2bfedc13 ]

Unlock ftrace recursion lock when fprobe_kprobe_handler() is failed
because of some running kprobe.

Link: https://lore.kernel.org/all/20230703092336.268371-1-zegao@tencent.com/

Fixes: 3cc4e2c5fbae ("fprobe: make fprobe_kprobe_handler recursion free")
Reported-by: Yafang <laoar.shao@gmail.com>
Closes: https://lore.kernel.org/linux-trace-kernel/CALOAHbC6UpfFOOibdDiC7xFc5YFUgZnk3MZ=3Ny6we=AcrNbew@mail.gmail.com/
Signed-off-by: Ze Gao <zegao@tencent.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 18d36842faf57..93b3e361bb97a 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -102,12 +102,14 @@ static void fprobe_kprobe_handler(unsigned long ip, unsigned long parent_ip,
 
 	if (unlikely(kprobe_running())) {
 		fp->nmissed++;
-		return;
+		goto recursion_unlock;
 	}
 
 	kprobe_busy_begin();
 	__fprobe_handler(ip, parent_ip, ops, fregs);
 	kprobe_busy_end();
+
+recursion_unlock:
 	ftrace_test_recursion_unlock(bit);
 }
 
-- 
2.39.2



