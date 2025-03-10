Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F4233157;
	Mon, 10 Mar 2025 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626576; cv=none; b=irv4S33vjt4ZFtarSzjEn7mKnlJvNj1gWdzt6WH88KMYynTSSRZA+KK1PjIB59FsmKWM4z1OeaIu7JGy9iZq5e6U8nTGFDqYzZJDoKzFExgmKHp+lEc3rmpVwTmoIucAH8oLdBoheWWJn26Zaz8rIaSnpVHRez3Zj1oSfpExoFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626576; c=relaxed/simple;
	bh=a813Kl5bDiRXPCnCOFC3o4BMrq/LJSnZ7aE26uC/kqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZF22NkXcLgw2zT4fVLf/iVdN7PHQg8CtygjX+juebQhmASkxTTgTzmxcJ60axVlVRO0RV/FpKNd5/vwtFpkmTr80gq5Gfw/IEwBBClX6sM5lomYQ1T9tqc4EqYLW7jUo8kdqYkyxMMpfpXBPBNjReS7/IeDup9IBbiH3DRt//Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNnT0/8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNnT0/8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90056C4CEE5;
	Mon, 10 Mar 2025 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626576;
	bh=a813Kl5bDiRXPCnCOFC3o4BMrq/LJSnZ7aE26uC/kqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNnT0/8/whqLnuIkIQY/ioHa9QtGrKYARDTQWZAtRBClst8BIbl3T0ks09hN9Jiyh
	 xhHkfZ8J1HJRjfuO9uVU2QGVEyD9Hs4bygjieT7r/YOXDprthlCoUhG0cNNLz4cPar
	 p1kqXA/i8Kroyi0l5ls2P28S6B8N8mxZevcj8m64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 008/207] tracing: tprobe-events: Fix a memory leak when tprobe with $retval
Date: Mon, 10 Mar 2025 18:03:21 +0100
Message-ID: <20250310170448.086009816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ac965d7d88fc36fb42e3d50225c0a44dd8326da4 upstream.

Fix a memory leak when a tprobe is defined with $retval. This
combination is not allowed, but the parse_symbol_and_return() does
not free the *symbol which should not be used if it returns the error.
Thus, it leaks the *symbol memory in that error path.

Link: https://lore.kernel.org/all/174055072650.4079315.3063014346697447838.stgit@mhiramat.tok.corp.google.com/

Fixes: ce51e6153f77 ("tracing: fprobe-event: Fix to check tracepoint event and return")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1025,6 +1025,8 @@ static int parse_symbol_and_return(int a
 			if (is_tracepoint) {
 				trace_probe_log_set_index(i);
 				trace_probe_log_err(tmp - argv[i], RETVAL_ON_PROBE);
+				kfree(*symbol);
+				*symbol = NULL;
 				return -EINVAL;
 			}
 			*is_return = true;


