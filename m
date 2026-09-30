Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5B51CAA6C;
	Wed, 30 Sep 2026 19:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794831; cv=none; b=rh8vfNr14bSPBKl01wwWl0nTY9s5CvSimFnWiOBDSkR7HXBStwHfFaxbRpYPKYqHK76v4zFuvk6y3731rLoQR7pYN3W13d62jevDSx9Xrd+OkAbLcHpb8DA69Hv3xqqfQ0cNfiGRX30VcmXrlM6cTggKInxntkfbTmPqcyfJdno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794831; c=relaxed/simple;
	bh=yiL0u2dWtQFEidrIS2g7XxZApTVD1oRMZt1879rMSN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIxKJRpOte/nWVj9/tivW/H6OKfoXu7Ks3o6Y8DQEkM2qVeRLavc51J6i+FkRdoG/nH9f9w+M7OEx8N7X5skKr9zGDPyxxMhAAeq06t5a0nka5rCUdN9bEO7GZLxry4wascfysfHKJZ97IEPn6FdtdyZvSD+UuAlPdKJMGTWN7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHiFrgVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHiFrgVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B217D1F00898;
	Wed, 30 Sep 2026 19:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794830;
	bh=VdPq59skueefF6N3Z0MEvFeAUltl9ddkCJmex4CrCnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHiFrgVPHfrYCREm4KrMv/F6r6jXH/ovjJF2pFzpMT13se7tW22BcCIDJsD7a9UG8
	 EDlkuv8y2UtfWHi1W5un9d1EJg4w737ckwOzTjdPl/ZzjBXN9jP4k8dxAEsMUUttra
	 UIppIujvwue+p0IaqPOBjauPHc1KMSROFoS1zQsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mukesh ojha <quic_mojha@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0348/1193] tracing/histograms: Simplify last_cmd_set()
Date: Wed, 30 Sep 2026 17:17:12 +0200
Message-ID: <20260930152441.896207183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 545db7e21e64766e6b7cb987fbfd3e79419726ce ]

Turn a kzalloc()+strcpy()+strncat() into an equivalent and less verbose
kasprintf().

Link: https://lore.kernel.org/linux-trace-kernel/30b6fb04dadc10a03cc1ad08f5d8a93ef623a167.1697899346.git.christophe.jaillet@wanadoo.fr

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Mukesh ojha <quic_mojha@quicinc.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index d7e8018559938..73041a75f0f29 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -775,23 +775,16 @@ static void last_cmd_set(struct trace_event_file *file, char *str)
 {
 	const char *system = NULL, *name = NULL;
 	struct trace_event_call *call;
-	int len;
 
 	if (!str)
 		return;
 
-	/* sizeof() contains the nul byte */
-	len = sizeof(HIST_PREFIX) + strlen(str);
 	kfree(last_cmd);
-	last_cmd = kzalloc(len, GFP_KERNEL);
+
+	last_cmd = kasprintf(GFP_KERNEL, HIST_PREFIX "%s", str);
 	if (!last_cmd)
 		return;
 
-	strcpy(last_cmd, HIST_PREFIX);
-	/* Again, sizeof() contains the nul byte */
-	len -= sizeof(HIST_PREFIX);
-	strncat(last_cmd, str, len);
-
 	if (file) {
 		call = file->event_call;
 		system = call->class->system;
-- 
2.53.0



