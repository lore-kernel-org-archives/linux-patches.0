Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3D21F4C8E;
	Tue, 30 Sep 2025 15:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245351; cv=none; b=e531ksh+VDngFMW/Pwi2nuRmGhhjmiY9odU2CR5/uQHlDQw7BY7hdeyRnoJ536BnPixY62MCY3uCw2fAm9KGSZ20FZwt/rTfsJbEp0tQqB/OmeIANOMbM8OG7KPT43A6iMmW9RS8YJDwrwDYtHoIBUjddnUJtCCkYIt2V9lOZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245351; c=relaxed/simple;
	bh=2HX5mZrlFBOp1/ZKvFDIarmT+E4H6aNJnsqoz9cfObQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRsWCunxVV6J0jZuwp9DRVAd5brq3e+Yj/p3RorY3rRlm1HFTza0xOidSyGGI3ZlUGKwTyUf7C68+uOaojcO2o79JzZP6UqCtbbNOMnbxB06C25bnqInpc3lxwvwjVISuspFvP9je4CBw5cg2bVCCeCIGYeR/xnK+fSoKBcbPwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZrW3PpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZrW3PpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28B3C4CEF0;
	Tue, 30 Sep 2025 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245351;
	bh=2HX5mZrlFBOp1/ZKvFDIarmT+E4H6aNJnsqoz9cfObQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZrW3PpD0A0up/FQizaOHwmVcOTkB3dBP8yKH7+nfdGEWx/Gth8X6wph3Pae87Bgn
	 4QqpgrcKVHSqGWGPAHe42EsNi1y0eG0hwG9eD0dqUyk7wNVxp9ylHcM7w3ydBAuqZg
	 hfuCy66/LtmqSPL/P/9BM8qWpA528pW6rz99Q/KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 142/151] tracing: dynevent: Add a missing lockdown check on dynevent
Date: Tue, 30 Sep 2025 16:47:52 +0200
Message-ID: <20250930143833.246927362@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 456c32e3c4316654f95f9d49c12cbecfb77d5660 upstream.

Since dynamic_events interface on tracefs is compatible with
kprobe_events and uprobe_events, it should also check the lockdown
status and reject if it is set.

Link: https://lore.kernel.org/all/175824455687.45175.3734166065458520748.stgit@devnote2/

Fixes: 17911ff38aa5 ("tracing: Add locked_down checks to the open calls of files created for tracefs")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_dynevent.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -239,6 +239,10 @@ static int dyn_event_open(struct inode *
 {
 	int ret;
 
+	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	if (ret)
+		return ret;
+
 	ret = tracing_check_open_get_tr(NULL);
 	if (ret)
 		return ret;


