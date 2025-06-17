Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB2B2F2346;
	Tue, 17 Jun 2025 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175778; cv=none; b=MJiHHaxzPFaerihopZWprToT1kuimoU5/77Y/OnTGjUsn/cs3y0VrRVTuNtLaADFh2ZP8TfS4PTsGUXkfTrbAyK7xt1/SgN9vUOW5NOZQrncej+I3rQxMiFSju+iAR6H7tIHadTudsjSddoCnAzqDDBXs4PHVRwDlwP+m6kzaP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175778; c=relaxed/simple;
	bh=G5MN/iZD1LKRlprTmYsjKyHECPe3O3zVSKvk/6/dOz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw6yv1EJL0DIRK+eJ7aIwEgvPQaNXYZULJgBBmXF+4MMahBCouy/Anjb7olRkC2eAAafDRQkNkPxnZ1EJBX6AF33kAiaM8MiA2iWrjH5Ho7nUeP16J+IuqfAlBpbkGSDDlDLbSha2omtLkIJViwP6EDtO2bFFtDNwVgh9NRpG18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRhlqeDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRhlqeDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8E6C4CEE3;
	Tue, 17 Jun 2025 15:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175778;
	bh=G5MN/iZD1LKRlprTmYsjKyHECPe3O3zVSKvk/6/dOz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRhlqeDnRB1UF+lIQVBAaBuZq/Afthq1ml/QjzCDI1/TaoBE1HqdhuZw4+OwLCBWX
	 CsMoTI4C4lEVZdTrDZg82QKfLlJAL9onxpmvPrMu4008v6eNhyPaSOQxcTaOh59Ciu
	 rfIrsJhIczWYmFGxdzd8ZG+NKhZjQqY8USQ1bYp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/512] tracing: Fix error handling in event_trigger_parse()
Date: Tue, 17 Jun 2025 17:22:08 +0200
Message-ID: <20250617152426.178055157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c5dd28e7fb4f63475b50df4f58311df92939d011 ]

According to trigger_data_alloc() doc, trigger_data_free() should be
used to free an event_trigger_data object. This fixes a mismatch introduced
when kzalloc was replaced with trigger_data_alloc without updating
the corresponding deallocation calls.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://lore.kernel.org/20250507145455.944453325@goodmis.org
Link: https://lore.kernel.org/20250318112737.4174-1-linmq006@gmail.com
Fixes: e1f187d09e11 ("tracing: Have existing event_command.parse() implementations use helpers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
[ SDR: Changed event_trigger_alloc/free() to trigger_data_alloc/free() ]
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_trigger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index e85d434f176a0..d5dbda9b0e4b0 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1016,7 +1016,7 @@ event_trigger_parse(struct event_command *cmd_ops,
 
 	if (remove) {
 		event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
-		kfree(trigger_data);
+		trigger_data_free(trigger_data);
 		ret = 0;
 		goto out;
 	}
@@ -1043,7 +1043,7 @@ event_trigger_parse(struct event_command *cmd_ops,
 
  out_free:
 	event_trigger_reset_filter(cmd_ops, trigger_data);
-	kfree(trigger_data);
+	trigger_data_free(trigger_data);
 	goto out;
 }
 
-- 
2.39.5



