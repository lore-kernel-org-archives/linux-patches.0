Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3ED152E1C;
	Mon, 28 Oct 2024 06:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096936; cv=none; b=QYGrZMRu+Nr3XP5pdUI7w0KzF/l/s7uslVqBsCV0z/Id3+d5Wg51r2+L9519OH/cArb8U8xQfeRKIBYTVYjHG8l3HCKWbgoEUw04unp23NtMZKYblX2Vq54maLi5G7pVJDTO2HS0jbcJG1z98+t71HvIHKv2+ugk4zP+g5Ba4CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096936; c=relaxed/simple;
	bh=mWRD+SQQH0lMagaQn+Pk5scPTy2nvXs4frGsO0H9Tvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiJ6xTcQOnPm7pG1FYkT8r9ZxQ1J2NcwXDahQgH6g1tpY5PXAGCfK492uSzCE8yFGpbYfirbRR4ThYrQTrZel8wgZDOgkPgAhPnFe3DtA+oVNGzWNebN3bbmGXZZtxYdJ5QkKkvks9rgyi2xFqjaeWyRpJdKhMYrpW0pDIa4Ozk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWB9vBPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWB9vBPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13664C4CEC3;
	Mon, 28 Oct 2024 06:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096936;
	bh=mWRD+SQQH0lMagaQn+Pk5scPTy2nvXs4frGsO0H9Tvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWB9vBPO9raLSwACb03kz3mi/ejEqrjRHs0A6AAdBmzvYUD31GUCx+kLakgjY5UTa
	 jBnqCGPSPu1m5s6RSzWSoXGQ1c7dcXX1KPeS1JkeRRiPhmUJdEWjkz7ccVFVg0xLdQ
	 bdR6Id5jSjYodQZ8quCtl0JKPFot0tjPPlvE7LdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/80] tracing: Consider the NULL character when validating the event length
Date: Mon, 28 Oct 2024 07:25:31 +0100
Message-ID: <20241028062254.035649848@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 0b6e2e22cb23105fcb171ab92f0f7516c69c8471 ]

strlen() returns a string length excluding the null byte. If the string
length equals to the maximum buffer length, the buffer will have no
space for the NULL terminating character.

This commit checks this condition and returns failure for it.

Link: https://lore.kernel.org/all/20241007144724.920954-1-leo.yan@arm.com/

Fixes: dec65d79fd26 ("tracing/probe: Check event name length correctly")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 0888f0644d257..d2a1b7f030685 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -261,7 +261,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 	if (len == 0) {
 		trace_probe_log_err(offset, NO_EVENT_NAME);
 		return -EINVAL;
-	} else if (len > MAX_EVENT_NAME_LEN) {
+	} else if (len >= MAX_EVENT_NAME_LEN) {
 		trace_probe_log_err(offset, EVENT_TOO_LONG);
 		return -EINVAL;
 	}
-- 
2.43.0



