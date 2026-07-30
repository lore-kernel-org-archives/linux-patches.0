Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4D442FA2;
	Thu, 30 Jul 2026 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422914; cv=none; b=q7L3uHcFWQqjz/tO167Y6pwYW1llRVb4HiXBqUWzP7ca+qHHwNXOYqlDsT+wsXn7t4UMlc+Adoj8KpPG/dhVfqVOAoVRZ/GthCAV7aMR2S/apgz5vBgRa2Vm+YG3xRuFmq0EdvRD6VafTx1RPcK4OuTlYvI/+BEbPsV4YUzRcNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422914; c=relaxed/simple;
	bh=TvHaEDHFuhk2esQunJvK0TsMNg+8DokjBlKC3YyyuHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5hzD/6MayYjl7CHrutjhyJLvBNe7tA4tcDgc2KgpJCK+h5UpyzXP3+qCxKV6lzjdZA/q/0yTxTyMET18GrjNbA6c9cncrO4tnukVQQ1IkVK2JTFpW6/O2vt9QExOWqOeqSX41I3Hqml416oWp4+IHPaMCd1VN6a+0fJQj7K6a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+pUpoJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+pUpoJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2231F000E9;
	Thu, 30 Jul 2026 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422912;
	bh=WAxBiCzqryZO1icBwthoU5609ar7hgWgxg6mcv3rDic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+pUpoJ9YpyQBN+Vb7j00Ubu0nffRvrKLF/81Ev9oBo0uJZVBZ5VYS2dWS1hnYl0+
	 7mwFdiTag83unUFTsVAOwAv5vk7FQ0tilegziQ8PjoV8tgB2d0xk7Y7+YXmlwHkbwI
	 9kX4ZzTR91jaGXkGGrPrYsomYiXwxynJqWadBoGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.1 598/744] tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()
Date: Thu, 30 Jul 2026 16:14:31 +0200
Message-ID: <20260730141456.989701186@linuxfoundation.org>
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

commit f418d68d71fd4a0a9cef92377bc8c4c3334b5b53 upstream.

eprobe_dyn_event_match() checks if the target event system in argv[0]
matches ep->event_system using strncmp(ep->event_system, argv[0], len).
However, if ep->event_system is longer than len (e.g. "eprobes" vs
"ep/event"), strncmp() still returns 0 because the first len characters
match.

Check that ep->event_system[len] is '\0' to ensure exact system name
matching.

Link: https://lore.kernel.org/all/178454235856.290363.14872590900774231133.stgit@devnote2/

Fixes: 7d5fda1c841f ("tracing: Fix event probe removal from dynamic events")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -172,7 +172,8 @@ static bool eprobe_dyn_event_match(const
 	if (!slash)
 		return false;
 
-	if (strncmp(ep->event_system, argv[0], slash - argv[0]))
+	if (strncmp(ep->event_system, argv[0], slash - argv[0]) ||
+	    ep->event_system[slash - argv[0]] != '\0')
 		return false;
 	if (strcmp(ep->event_name, slash + 1))
 		return false;


