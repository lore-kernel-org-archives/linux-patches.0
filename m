Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148193019C5;
	Wed, 25 Feb 2026 06:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002633; cv=none; b=LP8jGacP8w6ccKWLJYYGEtRAcAh1RMnAFrFR9psm+baF925XiUqimdpPf8cVXekvTejPq0ENKykpPoqOYjC4pj1FSSHHHs/19nY8l/4juVOBzo+Ztnr16gEJRpSzDf1Nd7+NUAsznAEfJRZ0oKoN0DZ7jlDy3WAQb6ZMXdHaNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002633; c=relaxed/simple;
	bh=y/SPgauuzbI0MN7YmWfkFzG7lsFqZ8tCYJCIkqfdx8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBhio7YOeUmey9KpUymDH+Oi5jBznUfrv5Z5FsN7+LKUOvhcROcwuXtiFrUHyVeNRGqY3FO/qp7/llW9Ptlv06JcZ0u3YyEvCiky1r8mRjIRVFsDZOkJlMupmp+Z8WYu5JvgU6u7JOr0WveSPNlodbAflb1sLz2m2fIRdKPJH7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bS+yubzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bS+yubzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1578C19422;
	Wed, 25 Feb 2026 06:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002633;
	bh=y/SPgauuzbI0MN7YmWfkFzG7lsFqZ8tCYJCIkqfdx8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS+yubzvUyW2XeRtcHeHj1eZ+LZJnxmvESCD4tsrp05nOjX5csaRqAERhKU0GP6My
	 p0xREsfK1YZ1sqmH8L61pDbbcuKNe48yj3Y2+nzb/Sw9KGYnbxJny5f3y2WLqRIWR9
	 K6hQqLO4dknAc93lr15StEF+hiXhxbb7ZqTW2ito=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 396/641] tracing: Properly process error handling in event_hist_trigger_parse()
Date: Tue, 24 Feb 2026 17:22:02 -0800
Message-ID: <20260225012358.168971626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0550069cc25f513ce1f109c88f7c1f01d63297db ]

Memory allocated with trigger_data_alloc() requires trigger_data_free()
for proper cleanup.

Replace kfree() with trigger_data_free() to fix this.

Found via static analysis and code review.

This isn't a real bug due to the current code basically being an open
coded version of trigger_data_free() without the synchronization. The
synchronization isn't needed as this is the error path of creation and
there's nothing to synchronize against yet. Replace the kfree() to be
consistent with the allocation.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://patch.msgid.link/20251211100058.2381268-1-linmq006@gmail.com
Fixes: e1f187d09e11 ("tracing: Have existing event_command.parse() implementations use helpers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 425ae26064bab..45727c4cf9545 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6909,7 +6909,7 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 
 	remove_hist_vars(hist_data);
 
-	kfree(trigger_data);
+	trigger_data_free(trigger_data);
 
 	destroy_hist_data(hist_data);
 	goto out;
-- 
2.51.0



