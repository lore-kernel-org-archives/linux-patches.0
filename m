Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EAD303C97;
	Mon, 17 Aug 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975926; cv=none; b=ruaEeea2H08PcXpXm25cuyOILXwtjv4MU9uQJZZQdxasPMUBsq+Cr9oUes3xkCOTDw9vGc67YYY3UuNCkWpW/wEpcstR//7vJmtzyvJIxyK1w4J2Kr/wukEV9jchFVvpTM3HE75pqs09/zOY9ZybrZgGm6ECJ41CTt/U1EwKUw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975926; c=relaxed/simple;
	bh=+oVbkw/pizSOskAvOlKzsGAXBM+yxJ57wIKz0pnr204=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrzTzaDEbNtfTd16/QNVrVZTNv/yuRhCEUhic4E9cyiNi0AhGWI7TrsLmiE92EzjrSUvelUdFkhG90FQ+jt/oi/aGu74Av6jhX+kUQjdsImzoLWxBvMgKVkHKOXceb2KA3lXfn809YOkgh3fkfuoeTAbQMJgnO3fzeWoZ1DTWio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hq8ZObOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hq8ZObOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7982B1F000E9;
	Mon, 17 Aug 2026 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975925;
	bh=+p+4Kqgc2zaMbfo3zTtrb64mfChsoFqDbQsCOv47VAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hq8ZObOrDVPhFIZVC5k2O9OvFgdrQbbtitzRlXrbpv/gsKc9pmpgZ+X8a9xd9VAnW
	 SZZc8pj9F688kCK9fRzjd6gFsNjzYZQ8ys/JduDTkRjFzE7lihjMZx7HaVmcDmOuiJ
	 wVB9yZJS9QLsVzXoy3Q+nM3FEXkLoH4njfHJfYeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 156/389] tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()
Date: Mon, 17 Aug 2026 15:29:55 +0200
Message-ID: <20260817132545.269660540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -165,7 +165,7 @@ void __trace_probe_log_err(int offset, i
 	char *command, *p;
 	int i, len = 0, pos = 0;
 
-	if (!trace_probe_log.argv)
+	if (!trace_probe_log.argv || !trace_probe_log.argc)
 		return;
 
 	/* Recalcurate the length and allocate buffer */


