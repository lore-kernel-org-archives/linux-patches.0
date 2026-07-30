Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C8D37B012;
	Thu, 30 Jul 2026 15:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426454; cv=none; b=G7+hzt7A8z0JVcTI9hgsJaeg9fjuIWQgoPAgKdn+OhwuQSdA+I+H7zPp/V/gpUBT4Xlo7BvRNiaN91J//M4V7Q34BnMzM/hlC70YIttPRC/Tf4YYbAqsKeIiYg0uyEMfNSvVGlWrsy0NoPKUnD6RWhBRSSZuvfVKa6vF1XXcZl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426454; c=relaxed/simple;
	bh=8R3b29j2NMwOBbg0Uy0a7prc9v/fcFlclP5XJOS9pDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD/LUiXE4Z5UXwBTH/hASoVBE2h7O2UcuyywmaQ91VSBdO3fpSy5xseGTvUhTMcmhepeIQIJev2IV4LGOBhUu2FMN3cmX7MoNOOx22z5fA1KcGAQnfJLMee8MXOwWB5RsnkWgZAAnvIIT+kwRtvapg84Mc4xjfdkNP/LIqQC1l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erMaGoWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erMaGoWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A0A1F00A3E;
	Thu, 30 Jul 2026 15:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426453;
	bh=+FVVB/v1Yuo6Jidhm7Vmgx+mrlnHXhYOqxBzsts/yj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erMaGoWHhG5d/l67LnKdjadq0tKTQ/qbCbgV2d5+cD5FenDiQT+FZwIBFDJa4Kcu7
	 ayaZ9qyMr4q9af5qBTAiMykWQcfbYxbjfqovqJ97OL9t2ZEDBgUpnAlH4KKJA8P8Su
	 4ujkvarhp/ZiNTMc//ksgW+Cu4AHh6xl0QYJjxJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 381/602] tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()
Date: Thu, 30 Jul 2026 16:12:53 +0200
Message-ID: <20260730141443.965138895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a9d6fb284039a5d3858a1d9f9a0d7e46cfb7c2d4 upstream.

If trace_probe_log.argc is 0 in __trace_probe_log_err(), the loop
constructing the command string will not execute and p will remain equal to
command. Writing to *(p - 1) will cause an out-of-bounds access before
command. This should not happen, but better to be treated.

Reject if trace_probe_log.argc is 0.

Link: https://lore.kernel.org/all/178454233992.290363.18323091580600697731.stgit@devnote2/

Fixes: ab105a4fb894 ("tracing: Use tracing error_log with probe events")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -187,7 +187,7 @@ void __trace_probe_log_err(int offset, i
 
 	lockdep_assert_held(&dyn_event_ops_mutex);
 
-	if (!trace_probe_log.argv)
+	if (!trace_probe_log.argv || !trace_probe_log.argc)
 		return;
 
 	/* Recalculate the length and allocate buffer */


