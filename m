Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6963918D65C;
	Mon, 28 Oct 2024 06:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098323; cv=none; b=EyitFsZa+kCs2J8bCgpW1wKCftzGOd0WyV6OruKl8hkVJVaR2Vh1NQ3QfMFivaiCTxrIfSBOo6CiAQVybAmcasU+FuR6uJ/3egD4195/nu+kInKiTxYpEAoFIHC6p7n7tYp8w9/VxY6WI8MoJijlEvsRluCA/myg+gpKnyD30U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098323; c=relaxed/simple;
	bh=wZyshJHjBFgu8d1AlN6n7LlHpjKElPi4sJG9tQ+dRpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHnY/0HU1kjOH4dAVJ8CiQASH8tnrgshXo+lqZbzmvqPhoT54bXBcDfJObTrDPLBTPTNq65VlW7S4uh/rMg+6UdJEnPR+lL1k+rvQKU58JmXTmcBCMX8yqcDaRo7CYPIHH6mFKDyE3alw+TV6TcuAkn5+UfnWkJdCq5axn4piz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzjqg1t/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzjqg1t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F369BC4CEC3;
	Mon, 28 Oct 2024 06:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098323;
	bh=wZyshJHjBFgu8d1AlN6n7LlHpjKElPi4sJG9tQ+dRpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzjqg1t/q06j+Pjs2T/VH7WTfQFjbGi/9EDZRCARm4vkdoSoyz2ll9UlicQA4dkf7
	 qETwQ+81tlPoMORTPQHJ6FCEuMTYqn0atSBid4xTcMgcMD+y47N5bTPFlB2QPSlH1x
	 iYf21FzHjsw+cB7xyZDSJciN+6Llobk54g4eNGbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 140/261] tracing: Consider the NULL character when validating the event length
Date: Mon, 28 Oct 2024 07:24:42 +0100
Message-ID: <20241028062315.551585027@linuxfoundation.org>
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
index 39877c80d6cb9..16a5e368e7b77 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -276,7 +276,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 		}
 		trace_probe_log_err(offset, NO_EVENT_NAME);
 		return -EINVAL;
-	} else if (len > MAX_EVENT_NAME_LEN) {
+	} else if (len >= MAX_EVENT_NAME_LEN) {
 		trace_probe_log_err(offset, EVENT_TOO_LONG);
 		return -EINVAL;
 	}
-- 
2.43.0



