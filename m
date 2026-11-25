Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623265;
	b=TNMJLcaTBWwODot0QdhxEMnCQO94havl7O/C44JBYkaiSPgw5NTQsyS6BjOznvR4DCi5
	 uz79Kh6nQi/V6mMdKCHY7UVjK3OG93D/00dIea+oi4kuN5VXhQJ7hoOh7BtFvrUXgxqeC
	 yQEZ//CnjoWUSp3bECXX80Rxur8WvfDwlP09q5ATJlSzRi0cj8bhcfllr/7NvZfntiSHq
	 DCFt/a0WSlcJCZ29DAciRWhKSYAJaOCCsmYoBR1y64fDLGefFYa3wOq0yIKZguewgFveD
	 LED0JyV2258ZJrWszYJ/YODHWB2THNEY6uGuVd71MAfS3BelC+M80gNYMprbGIl5mUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EqlBtSBf6vhREoh7pf6L/6+5r4SuqS4H3awCzdfYiAo=;
	b=xtrc5Sa3pZyeGiSBC97LiutapQMPX23114KXcQIuryDmuswqVH2qzrItJl+Qq0/YjDJ8
	 CZuRIieLGsApZMStSXtDLxBH61WCpsTnXePwyceyxOoAHHvrozPWmZF4C+Peb6OxDaeRa
	 5ay5QIu/0wB++9xBGHKJc6Ypm9c3EA1ieLXDOu3R1G/fRxGOR3RPqSOccNZJEC6jI7cL/
	 mMJCk+li387lWR42QO8ttMmuc1CgFK3xkmVNe2IinyZYcAtfvdRpwX4f4va148egKgXTD
	 eigtxdWpsK7h/SU6pNPf56qmKBRlemuxPY1qFC+/F1/cQUHYf4zLZRn0smagz5Bm6eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZIPrCwA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF934606A326;
	Wed, 25 Nov 2026 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZIPrCwA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E21D1F000CF;
	Wed, 25 Nov 2026 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623265;
	bh=EqlBtSBf6vhREoh7pf6L/6+5r4SuqS4H3awCzdfYiAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZIPrCwAM+WtS+vlE/JsocnyKi94YaYVOWNub3bh4e225nJNeKXWggjKqAHosNQ6f
	 Qkx69SQ4wqDB/CB39eVGakb7YXWKf/W4dBkYKwWfhVtw1jciB6/Ys/jvpstfKnDD7X
	 gru6EWlQwOcG5GBuWnCuAIBhVtbw6/VNACmA7+Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 803/990] tracing/eprobe: Disallow attaching eprobes to fprobe events
Date: Wed, 25 Nov 2026 15:36:10 +0100
Message-ID: <20261125143840.855184776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 92d9fa0ed69e1f724feed908bd0a462a42df4b88 upstream.

Event probes (eprobes) are not allowed to attach to other dynamic probe
events (kprobes, uprobes, and eprobes) to avoid recursive probe chains
and lifecycle dependencies. However, when fprobe events were introduced,
TRACE_EVENT_FL_FPROBE was omitted from the exclusion mask in
find_and_get_event(), allowing eprobes to attach to fprobe and tprobe
events.

Exclude TRACE_EVENT_FL_FPROBE events in find_and_get_event().

Link: https://lore.kernel.org/all/179455853457.403392.14549390017750529531.stgit@devnote2/

Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -756,7 +756,8 @@ find_and_get_event(const char *system, c
 		    (TRACE_EVENT_FL_IGNORE_ENABLE |
 		     TRACE_EVENT_FL_KPROBE |
 		     TRACE_EVENT_FL_UPROBE |
-		     TRACE_EVENT_FL_EPROBE))
+		     TRACE_EVENT_FL_EPROBE |
+		     TRACE_EVENT_FL_FPROBE))
 			continue;
 		if (!tp_event->class->system ||
 		    strcmp(system, tp_event->class->system))


