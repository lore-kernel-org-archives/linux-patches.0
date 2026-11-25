Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626034;
	b=zGlM2baDdauMXJQOVQBI1STWaw7TN/azuealXFaoeKubs6SAUDu4jpOsZcJf2yhb6iUZ
	 xHGZHu16Lm7YlXWXaz59nV94OTWvQkZGHJJ1Bs+LWyDjfXE9BTv+OzgBC0ntsokw3PZRi
	 ZkeMKN8SKrYSKCmaKSfaTVH+LjUzwtgIMmZSkrS36Pi08lSET78d9naCJtNNzQQ9AOpkg
	 6PaBuOpr22wxzgfM1zaObEDA7UIirD2vz9BkYaOarB9QqNz3rhBw13S2i5felC9TIedeQ
	 brausbFUpPNqq2dDGZv14uakRcGpeOMXNwOWtCpCKM0vq4ztHKj3CNnW1BAqAaFQj8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fIdkKEe1zoRRhx2uoDe4FmQ+jjQmkH5DQXWfloppXCs=;
	b=okMvAiC766rE/62/KYKCMpwHOBYyK42Sb7IZyJ4768z3U5BHF/LRzF7v/QKW3twYkvqR
	 gTDv/ZTH6ChNTdpmbhVKzyiUMQ0SrCuzMPg/MGZU79FIVOrXnOyC5+7zW7HNNNAInfhi6
	 gObkfPFTqgIdN1+TOH6iF64JlDfZt8XMO9CU+WCIvLxnbdaeVcFOYmmNJRoWsIyGnFpnt
	 SM8LSQJmuC2TI8ki0iEeeElWY2wrXTLB7u8m03mUU8rkdJnSAqj7WT7edUpy4L9CNhCBJ
	 IBlQ/oa+qr3a3T6G9Wmr55I+BFMa8GHNAd6tH5XQjcJeSdSsGnIrv3qh55D9RIIbmmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dfv5Jv+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AE8606A326;
	Wed, 25 Nov 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dfv5Jv+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324D51F000C0;
	Wed, 25 Nov 2026 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626034;
	bh=fIdkKEe1zoRRhx2uoDe4FmQ+jjQmkH5DQXWfloppXCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dfv5Jv+3d8gJMZ8pr0HJ5hxOpYklO5IEuKZpWBbKt6eynv1sE1SX2BQB5jldyMzHs
	 DWUvHwnrr9qzbUDfHPzmepDzZxLIGKRYHgwhlfbQJsqovDyAzl2uF3YJ0GMVZc5OgJ
	 xX78+eFWaCt5ZsVEslT/FTXIh+8y8wxqLANwThuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 655/816] tracing/eprobe: Disallow attaching eprobes to fprobe events
Date: Wed, 25 Nov 2026 15:36:43 +0100
Message-ID: <20261125143904.341934802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -750,7 +750,8 @@ find_and_get_event(const char *system, c
 		    (TRACE_EVENT_FL_IGNORE_ENABLE |
 		     TRACE_EVENT_FL_KPROBE |
 		     TRACE_EVENT_FL_UPROBE |
-		     TRACE_EVENT_FL_EPROBE))
+		     TRACE_EVENT_FL_EPROBE |
+		     TRACE_EVENT_FL_FPROBE))
 			continue;
 		if (!tp_event->class->system ||
 		    strcmp(system, tp_event->class->system))


