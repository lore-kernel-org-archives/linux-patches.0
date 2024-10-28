Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E498837;
	Mon, 28 Oct 2024 06:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097925; cv=none; b=NaoVDDzdydoEMMDgwh3XeE+nvUAm/g+K6qYzQHJd6fwVvH1aFgHHuW3KeRn/by0E6YJMKYodwMqrI+NGe5jIDmKJqt9Ft91KsrMR3vt4eCFb4GOugQdJGfMBGeEgqinkKCSzAhLrVc9j9l5G98zBBb4Bdn4+iZx6wtUQAVxifRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097925; c=relaxed/simple;
	bh=dTkEsvONIwE/Qp6MIU/xJm3wtWsmUvWBT/tD8tkPvDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQQBkgiSTvtWhtWDm54/twpV9Tr6DzT09JtSCUyCjl9nFdjgU8JBjXxyEijWPrigcVtCsHjFhoXnR3ZWZBqcBCIx4VhT16BHE+/b1vnmZwu5ZrNeB/KvDqet2+Htx3vKyzneiogd9WgJa8EWEzuVKjo7Tg7fUsDNh2j9v0g30gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yg+zMlWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yg+zMlWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9283C4CEC3;
	Mon, 28 Oct 2024 06:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097925;
	bh=dTkEsvONIwE/Qp6MIU/xJm3wtWsmUvWBT/tD8tkPvDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yg+zMlWS8cKwRdUEedlwmwiE+jE/cJWUSs2mwATStgLbfysadJ4IfW3U6tz5/8+Bd
	 28tun6Acfb2s4SU5ie63332zfdrERwPC9jUzamEorYD/8p38z/s+5jd5/Z38rvBo1s
	 UZflO95sQXpayWSVmqeDQLO9uC+fGlaLwZi0aPkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 207/208] tracing: probes: Fix to zero initialize a local variable
Date: Mon, 28 Oct 2024 07:26:27 +0100
Message-ID: <20241028062311.744855440@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0add699ad068d26e5b1da9ff28b15461fc4005df upstream.

Fix to initialize 'val' local variable with zero.
Dan reported that Smatch static code checker reports an error that a local
'val' variable needs to be initialized. Actually, the 'val' is expected to
be initialized by FETCH_OP_ARG in the same loop, but it is not obvious. So
initialize it with zero.

Link: https://lore.kernel.org/all/171092223833.237219.17304490075697026697.stgit@devnote2/

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/b010488e-68aa-407c-add0-3e059254aaa0@moroto.mountain/
Fixes: 25f00e40ce79 ("tracing/probes: Support $argN in return probe (kprobe and fprobe)")
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -843,7 +843,7 @@ out:
 void store_trace_entry_data(void *edata, struct trace_probe *tp, struct pt_regs *regs)
 {
 	struct probe_entry_arg *earg = tp->entry_arg;
-	unsigned long val;
+	unsigned long val = 0;
 	int i;
 
 	if (!earg)


