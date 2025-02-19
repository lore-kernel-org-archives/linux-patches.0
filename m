Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809261BE23E;
	Wed, 19 Feb 2025 08:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954081; cv=none; b=TwHVazM2vNdn9PKtlYbjMIBr3OJC3LuqzT+bI3oq2tcMwUpuDEuUi7rnV4RFcf8Z6GtMEIPqf7GmRKz0eTSIUZVwCGaheQ03TK0BgubIXO4a94p73hxSWZIpUdjdJWyNBkkRM+5RdjGYnVbrGZopenNEKTtpKJ51jpqOc4TpBJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954081; c=relaxed/simple;
	bh=1MA8GHZQw0d9sfQA5iBlsuBZqoTsYn8QNjR7AoyBLKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5D82wwXmKhgOmiJXsmJAQFChZ3p8IuUAv0UijV0xKpgglnP5fxg+870tbqJI0gftn9/icyLBE5SBkbNuFctwLiPIErY1p7g+26pbSPLBduce/lIQkWhdcRa1NVuQPurtrB2Mydm4HJTo8AOj9TgdpqZyBHx3xrtAWx/LZnRgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlPfViyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlPfViyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F374BC4CED1;
	Wed, 19 Feb 2025 08:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954081;
	bh=1MA8GHZQw0d9sfQA5iBlsuBZqoTsYn8QNjR7AoyBLKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlPfViyjQv++ECivtR42Ks0iiDwFxiP4rh4TtCN42DWbVowFtPkvaoOdjGP++PYDU
	 y/qeSlUwFdUQ9z5SCvXYOep/xN1E41P/CDiK3zxCu6R4vyXzQrk037UZVeR8KS/N5t
	 ilJc8SXPiK/zaLpeLGG9CgE03BAsId5QoRT0fLxA=
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
Subject: [PATCH 6.13 090/274] rtla/timerlat_hist: Abort event processing on second signal
Date: Wed, 19 Feb 2025 09:25:44 +0100
Message-ID: <20250219082613.146747024@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit d6899e560366e10141189697502bc5521940c588 ]

If either SIGINT is received twice, or after a SIGALRM (that is, after
timerlat was supposed to stop), abort processing events currently left
in the tracefs buffer and exit immediately.

This allows the user to exit rtla without waiting for processing all
events, should that take longer than wanted, at the cost of not
processing all samples.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250116144931.649593-5-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_hist.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 90b33b0c4391b..446d650f0c948 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -1152,6 +1152,14 @@ static int stop_tracing;
 static struct trace_instance *hist_inst = NULL;
 static void stop_hist(int sig)
 {
+	if (stop_tracing) {
+		/*
+		 * Stop requested twice in a row; abort event processing and
+		 * exit immediately
+		 */
+		tracefs_iterate_stop(hist_inst->inst);
+		return;
+	}
 	stop_tracing = 1;
 	if (hist_inst)
 		trace_instance_stop(hist_inst);
-- 
2.39.5



