Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881CB18E03A;
	Mon, 28 Oct 2024 06:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097752; cv=none; b=Z8A/zGWWg0o5php/L4PdsRbKbPvYYKzA8TRyYmOS8gpbpYAAhdY7LrD6dNdH10hjvVPn/8i18U3X6QloAPJx/gRLMZkKeY6qe7GDnfDdMtSkr7+UaXsU3aGrMuZUyTHYmMPKNZLHqKL33AmuXK1o4Fr7WURYllMpPxHLExWlBBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097752; c=relaxed/simple;
	bh=r7JkawT2qQSm3WraJNQCDjhm3MryIuogz4oZ5rqb/JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfbWR3Y4osTD76Ny0wRJrrlYPG9fAzk/+t0IIUrMYrpnvATWMXz0tASww+IQVPbaW6Adbroijj6pr5C4zII4jf5uO3wrfN7h+MWPByZ+uPDdtKE6RvQHRokSxBubeJQ30HJphAZX/yEGgX10MdoXNp/+l793K7oDcrsvN2h0MNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCiBGPlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCiBGPlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28937C4CEC3;
	Mon, 28 Oct 2024 06:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097752;
	bh=r7JkawT2qQSm3WraJNQCDjhm3MryIuogz4oZ5rqb/JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCiBGPlItkkJvdi9cBAnXI6RzYBcIPFcApu14Hw/BJ+e8HDOIQMO9Te2omHEhjswR
	 woeII7hwCgzuhJc+Lwh4F1H1m5FwZZB/al0JZTKh4AQwdH8FwuuXYThZC5cM2u4feN
	 XCM+R+21Dsz+vG+MPT/sn+48wSWt2OUW+4IzrFRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/208] tracing: Consider the NULL character when validating the event length
Date: Mon, 28 Oct 2024 07:25:10 +0100
Message-ID: <20241028062309.843093504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58a6275c7f496..a1bc49de648f2 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -275,7 +275,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
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



