Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65C536493F;
	Thu, 30 Jul 2026 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422964; cv=none; b=J1MErWTOgWByutoco6alZP8GVLymlII5+9b4sz+37b8CyLI2Gk18jQ8ccOtK1FcWub3EYnSkYH4EyZM5qVqRfXvww1QXMhDgj5oIJu42hjgL6h+TvQW6VIE55Qv0xOzLQKyhXY8lAW6LmsxJ8OHJ7FcSiBL9+OGt/V6juqzkPh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422964; c=relaxed/simple;
	bh=/0I2JO136Egzj2S0jdTPRr8ywHltdApbWilyww5cd8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpTn7aA/3Ciuk4RxXFyKbBVa2Po1FbGGOJ8gLpIEZfFuwVUYnJytWMLh9S55qX+RVtDiPDeRYcaxed45S5O58WX6kAKkNfCLCagGNVwKfJFvUW60hpm8Ub+4hC/VTVzFA1Oc8vo1OEMnHXlarSuUFgJzZbBRahHLtjmbPEN/hAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jr8S+DXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jr8S+DXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB541F000E9;
	Thu, 30 Jul 2026 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422963;
	bh=BEg+K/TAC6Ivz4onFF+N4/kuMXe9Q/aONrxmLf+z6f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jr8S+DXTFOBgU9wW/QjcXp0sT88jdaCTFbN/lUaRrLU4PR4YE3eSEiKv0uttyJBtN
	 k40yLLgPAk6bMkV2HO0c2zyRicRd/RXqvZZ9oejdVx0C5Y5DmMzl8YBu/GiJQedTjy
	 enUNBX5nSlk5hgtU5DZo6iRr+n8/qXjLzO4kudiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.1 601/744] tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()
Date: Thu, 30 Jul 2026 16:14:34 +0200
Message-ID: <20260730141457.051823588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,7 +188,7 @@ void __trace_probe_log_err(int offset, i
 
 	lockdep_assert_held(&dyn_event_ops_mutex);
 
-	if (!trace_probe_log.argv)
+	if (!trace_probe_log.argv || !trace_probe_log.argc)
 		return;
 
 	/* Recalculate the length and allocate buffer */


