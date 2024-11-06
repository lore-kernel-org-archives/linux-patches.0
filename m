Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA251EC012;
	Wed,  6 Nov 2024 13:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898941; cv=none; b=LMSqK1Zwxpx9D+s+ci0bf4hqmAigeZ0HETCO6qXGbEi0K2vF4x6EcyROSi2xz10sW063g+qdSyaWPrJKmMRCKOSaSoGmmlK54eigdFbZOy2jhswF6PKiJdBTyVltDYXE+vv4K/WHIiYwo/dlZX/ihZ0Y8stYWWWcheuH3m/6IOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898941; c=relaxed/simple;
	bh=t8gItfgTXcNe0ov2nbUhcJNbSAlqYvSVyZSt9kTuHdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9TcoDdJxf2RDLMWqXYYMms394CtFj1z/n4AqlGOdDi4VtVtdE7q/6kzy7pkAuHC7O6UsBBulWX2eCvJxjc++ZoghJ3eKEdPgeDQS3QI072+M3TY6tyRceJkSTZtgMUn7ZHKgiy2cnMwlq4DlPm1UeMpAnta5OVO4PtudWxjf9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHHoRc9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHHoRc9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DFDC4CECD;
	Wed,  6 Nov 2024 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898941;
	bh=t8gItfgTXcNe0ov2nbUhcJNbSAlqYvSVyZSt9kTuHdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHHoRc9qAPbSN38d95a/ngMKlOpABuyLKR7QH8UroQfNeatgwTYVlxqvthdFyMNk+
	 vpShtcn+jOAoCwknUNg77nBiXVrBPvdt9aG/9cL9lXeq8/6TNrQLS6HuaX7GuHO5J5
	 ahpQGrU2W8GiYcSXUk1rNzRHAknu4+MNFMsV5pOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 407/462] tracing: Consider the NULL character when validating the event length
Date: Wed,  6 Nov 2024 13:05:00 +0100
Message-ID: <20241106120341.575749777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 476a685c6b6cf..0fef4bf83172c 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -256,7 +256,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
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



