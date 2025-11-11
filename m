Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1C9337BB4;
	Tue, 11 Nov 2025 01:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825312; cv=none; b=jnnQmn2JE3fNeBn4ldUb5vMWZ4xkikRNN06XZ+eZZ+RwI81RdswEiMLFJcxYz7/5gOhFLEV7ysdStjJKlpzjkc83jxVzGKAdOF7LEZmSk3GkgdT7PQrC/7BsarFWEpw6eru+Gh9WT5iixRNNAPduPcBGj2TtRR+YCQE87ypHnX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825312; c=relaxed/simple;
	bh=2jhp47A2ZnYUS3WAGFs0mKespybatzglls4I4lxxhm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USBDBrC+xVF2L5lo2EJ6izmYcrotNdviFxCihbRlG7zyiBTL6MNa/YxlxFfWbbOL0jPLVydPWsXNTMhu8hsiw5CdP+3WcAN8lkzs3IDBFc807GUI9vCi3yAMgTBAzFNO6Us/DnCAIBhBUiNS0yMBl/ZUAG8y1PqjKLRFGgrT4Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmKJeUBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmKJeUBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2681C4CEFB;
	Tue, 11 Nov 2025 01:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825312;
	bh=2jhp47A2ZnYUS3WAGFs0mKespybatzglls4I4lxxhm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmKJeUBzL7ihvbFKHpFWg1DNJmoAQuC3Jsbd2g1+wwlGb+3PlAR92IoI0UeuML/aP
	 ykPlEVADr8S4rE2EH/54peFTg3vQNPNnybx5jzqnbM/id6TEjrOx4ixNSqR5PRcN90
	 R4cOSIVpMS5yypNO+tPN2W6fi7He9yih16yHix1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Beau Belgrave <beaub@linux.microsoft.com>
Subject: [PATCH 6.17 748/849] tracing: tprobe-events: Fix to put tracepoint_user when disable the tprobe
Date: Tue, 11 Nov 2025 09:45:18 +0900
Message-ID: <20251111004554.520308026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit c91afa7610235f89a5e8f5686aac23892ab227ed upstream.

__unregister_trace_fprobe() checks tf->tuser to put it when removing
tprobe. However, disable_trace_fprobe() does not use it and only calls
unregister_fprobe(). Thus it forgets to disable tracepoint_user.

If the trace_fprobe has tuser, put it for unregistering the tracepoint
callbacks when disabling tprobe correctly.

Link: https://lore.kernel.org/all/176244794466.155515.3971904050506100243.stgit@devnote2/

Fixes: 2867495dea86 ("tracing: tprobe-events: Register tracepoint when enable tprobe event")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Tested-by: Beau Belgrave <beaub@linux.microsoft.com>
Reviewed-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index fd1b108ab639..8001dbf16891 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1514,6 +1514,10 @@ static int disable_trace_fprobe(struct trace_event_call *call,
 	if (!trace_probe_is_enabled(tp)) {
 		list_for_each_entry(tf, trace_probe_probe_list(tp), tp.list) {
 			unregister_fprobe(&tf->fp);
+			if (tf->tuser) {
+				tracepoint_user_put(tf->tuser);
+				tf->tuser = NULL;
+			}
 		}
 	}
 
-- 
2.51.2



