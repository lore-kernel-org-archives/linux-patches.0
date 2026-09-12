Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A2138F92F;
	Sat, 12 Sep 2026 19:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243017; cv=none; b=H2WuKR/8TP0fIoj8+W6w/lsoHayfyaD8KAHkp/qzz7ezT0Yi/xNrIudtH5DkXqjExa0VyZ0JYUxPHCBFh5dr135CRz1BDpeE98M+WsY5ioRVB2t/JKfMzchQp2lOiFcShpjyouE/pSEaRGrPro5d/PPlvaT75pGVcwMzf/+g38M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243017; c=relaxed/simple;
	bh=kaV7EV45GIPydbnHDUwNtgtDXhl1ybq+E9eYS/U7yYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0IcBojw2Za0YvYbyo0TRUNWGVob95f7/q8SaHfq6zLc6g2MN53P5IkgoH0D90WfqiTtpGy/hGn7yYom600pb69bnKPKopyqFoVyBMGaLh01bp261SYygkoHbVWhaUNZ2VcezslS1FHS8vIXkAqLvId8LyLm33UcJOnyMbqPL78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9g1gBR3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9g1gBR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3587B1F000FF;
	Sat, 12 Sep 2026 19:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243015;
	bh=6Mql3TCq9e9B3gYAZ9vA6J6amH6dpcEW5mgCJl/3hfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9g1gBR3sZU9aXwlVdfNNtOQy9SHBcdNcsonNl8gWk9EULNuIMlhZPwvCCA8hy8VV
	 ZzXs1DYHS+HZGOwdHMIBap/wdrLQFll9Px6aBaQ5dE3ZhtC6qusiBmP+gzJErD3eOG
	 OxxNnzxDxIBbQY5X6y9R3EBpDZWQwNvBXt6rQqnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 564/798] perf machine: Check snprintf truncation in machines__findnew()
Date: Sat, 12 Sep 2026 09:03:12 +0200
Message-ID: <20260912065530.054900199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cc6abe0012bf8c04af8275266f8ed7c55ba4a5fb ]

The guestmount path is built with snprintf() into a PATH_MAX buffer
without checking the return value.  If symbol_conf.guestmount is long
enough to cause truncation, the truncated path could match a different
directory, causing the wrong guest to be associated with the pid.

Check for truncation and bail out early.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4907459639b6f..be18fd39813f6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -347,7 +347,12 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
+		if (snprintf(path, sizeof(path), "%s/%d",
+			     symbol_conf.guestmount, pid) >= (int)sizeof(path)) {
+			pr_err("Guest path too long for pid %d\n", pid);
+			machine = NULL;
+			goto out;
+		}
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
-- 
2.53.0



