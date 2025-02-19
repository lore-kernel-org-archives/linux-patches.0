Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558651CAA68;
	Wed, 19 Feb 2025 08:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954916; cv=none; b=lorLslR5ysMl3Oc95IDLFcNt74wKpCYZ3ML5FvudtDlO1hGkU6nwnwdK25PvxsW8wnwl9JqWYipJUp4kQh/MRqDaYrL9KtTSDFDm9T3L1ROvUuCzszS1oEPpz5+AVioDkqSNZ5tfBG+OUfTIN8PfJ5zMENvQzldybAO9yVe1AhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954916; c=relaxed/simple;
	bh=AA9m/YvxmtsumhrE9dpOyv5Bm9peg2hBrllaDmCRM4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0fSvAvzLSWb0mHMaGvc436yQn0D9fkG13eLwfl3JBKJFAjMIpb/2TeW3Ae8WGAQQhohHsCsWaqYjUI6XhAXJEp1jD7EleVwRMIMXWmx+sHRBWuv9echHvkcnjYWoICrVkDRjKmLVpuEm58ob1p/rouJx6lAXwq/aT8KH43KXlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXTzbsXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXTzbsXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EF7C4CED1;
	Wed, 19 Feb 2025 08:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954916;
	bh=AA9m/YvxmtsumhrE9dpOyv5Bm9peg2hBrllaDmCRM4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXTzbsXNcYbIJPYc9aUJ4lAniz4uIlfWYJN/AqDikEkReiHAlq9UYXu8hI7XWSExk
	 K6XLQOHImGgkqAmuiGxMitRO3nKLO6cYiLiPmuJJnZPCfpF7F7ZhGDCM7jcLZ1a7Qp
	 KPfZDWSzMmCecXO/XTWCIBDrJRQK/7LF8fpfWuwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/230] rtla/timerlat_top: Abort event processing on second signal
Date: Wed, 19 Feb 2025 09:26:33 +0100
Message-ID: <20250219082604.678414183@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 80967b354a76b360943af384c10d807d98bea5c4 ]

If either SIGINT is received twice, or after a SIGALRM (that is, after
timerlat was supposed to stop), abort processing events currently left
in the tracefs buffer and exit immediately.

This allows the user to exit rtla without waiting for processing all
events, should that take longer than wanted, at the cost of not
processing all samples.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250116144931.649593-6-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_top.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index d13be28dacd59..0def5fec51ed7 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -897,6 +897,14 @@ static int stop_tracing;
 static struct trace_instance *top_inst = NULL;
 static void stop_top(int sig)
 {
+	if (stop_tracing) {
+		/*
+		 * Stop requested twice in a row; abort event processing and
+		 * exit immediately
+		 */
+		tracefs_iterate_stop(top_inst->inst);
+		return;
+	}
 	stop_tracing = 1;
 	if (top_inst)
 		trace_instance_stop(top_inst);
-- 
2.39.5



