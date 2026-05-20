Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE01E372EDE;
	Wed, 20 May 2026 16:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295541; cv=none; b=RBAyr2GbxfK5RTimXjZ59US+/IVwBFlYipfn2XinVPXOCgAlD3ER0OQuKYjaBl6s1apHYioqR/4PqLiVzQ7BCIThoY26ScuriyoBUINQU40bL3bS5O+0GjnJhCszNNgq82U6p1PBOtEhTROL9iga2mJ/RqN49Z/NnVN4Vg4s+7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295541; c=relaxed/simple;
	bh=EEpL5uyuexjGKhN9JkX9mEvP3AixClF3OO3ogYuBj2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTWY681Nfuo0TRTB3w7lEARnNDSs+/LWE7XsIjKFZek58EYIVMBG59DPA3Vk+mQLsYmFaX+DZ//QC38iQezWVu7fySjmHEsEqIUgyaX5SUATEPacCruHgMNmjSMqPF638mVF/mXaq0+//dEuBZ+kMC3eEPv+8He2/jsCnLSeA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8I81elF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8I81elF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFCB1F000E9;
	Wed, 20 May 2026 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295539;
	bh=190O2ElUI8ZTXI8kGcrSxKcLFiw5MhyNc+YtSTkgeh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8I81elFAx9SKx/iHPIeirvdev6a6vDEux3XbTu6edE0geYD/WHA7bz3pbZXI/hwu
	 Gxqe1dkqWMVyzxMy5M3vOO9zS0AYwxnU9ZAUVAKcp/HBkmluB1pMEruq8WpigSwqg0
	 5yW4TDbxGieOS7AWoUIeYa6xMlJo3JjKuUGNXX2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0457/1146] rtla: Fix segfault on multiple SIGINTs
Date: Wed, 20 May 2026 18:11:47 +0200
Message-ID: <20260520162158.540982416@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit be8058f31b4e237604e4ce7599593ab68dc69ae7 ]

Detach stop_trace() from SIGINT/SIGALRM on tool clean-up to prevent it
from crashing RTLA by accessing freed memory.

This prevents a crash when multiple SIGINTs are received.

Fixes: d6899e560366 ("rtla/timerlat_hist: Abort event processing on second signal")
Fixes: 80967b354a76 ("rtla/timerlat_top: Abort event processing on second signal")
Reviewed-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260310160725.144443-1-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/common.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/common.c b/tools/tracing/rtla/src/common.c
index f310b0d59ad3e..839c78c065e12 100644
--- a/tools/tracing/rtla/src/common.c
+++ b/tools/tracing/rtla/src/common.c
@@ -39,6 +39,18 @@ static void set_signals(struct common_params *params)
 	}
 }
 
+/*
+ * unset_signals - unsets the signals to stop the tool
+ */
+static void unset_signals(struct common_params *params)
+{
+	signal(SIGINT, SIG_DFL);
+	if (params->duration) {
+		alarm(0);
+		signal(SIGALRM, SIG_DFL);
+	}
+}
+
 /*
  * getopt_auto - auto-generates optstring from long_options
  */
@@ -314,7 +326,7 @@ int run_tool(struct tool_ops *ops, int argc, char *argv[])
 
 	retval = ops->main(tool);
 	if (retval)
-		goto out_trace;
+		goto out_signals;
 
 	if (params->user_workload && !params->user.stopped_running) {
 		params->user.should_run = 0;
@@ -336,6 +348,8 @@ int run_tool(struct tool_ops *ops, int argc, char *argv[])
 	if (ops->analyze)
 		ops->analyze(tool, stopped);
 
+out_signals:
+	unset_signals(params);
 out_trace:
 	trace_events_destroy(&tool->record->trace, params->events);
 	params->events = NULL;
-- 
2.53.0



