Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0911D1C548C;
	Wed, 19 Feb 2025 09:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957422; cv=none; b=hSThuhXBeFKiBe1BQPBmsLmNWIMBA1BrTzX6N+BVmtzd5dKhZTfPEL3omxsh/GmRCPoR5rru+Q7jTg8ZYZZElEBwSaAJaH7S18D9rwF4mL83TvqES0mujEKXqaTKZrw+X8/eTY8BaptM3dwdWK1913+V29RGCkx9vJrq9pq9bac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957422; c=relaxed/simple;
	bh=RpKCXN5YB0ENWMOBging079qXw8UizvkvUWKYxFnV2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxO5abmc/VaE+yKVxfBZUFqsPUKLqrt3ES4x8EZbJExAWze/EWvzgAfM4IkHhgpDmmefugsHMVWkeR0cL9H25yEqH5NN8EDsmbeVVzzO9IOAt48KdneDuaLctOtr8QV/MctqwI94i3pVXFzWKXNLaC5aIh6y6/Ct+CgupFie8ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TP9KiZC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TP9KiZC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F3CC4CED1;
	Wed, 19 Feb 2025 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957421;
	bh=RpKCXN5YB0ENWMOBging079qXw8UizvkvUWKYxFnV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TP9KiZC+LCmek5PZveYT2FgZTdU9hJKNlY2c1vdtF8gxiWyoSpjEtgzn5+rTlItth
	 97aM/SlJ+H/J3ou1W8ntsUJIRtai/ErQ3QYSeY48k1bj6g0jTuaGMARVwIGsvAxTOM
	 WeGkR98Y4dpeNpq2N3ISEzVAMB5s/Ii5BV1j7g9w=
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
Subject: [PATCH 6.1 489/578] rtla/timerlat_top: Abort event processing on second signal
Date: Wed, 19 Feb 2025 09:28:13 +0100
Message-ID: <20250219082712.233794138@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 08e940ecdc966..46c3405a356f5 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -578,6 +578,14 @@ static int stop_tracing;
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



