Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622256;
	b=L8Ye8s4W3NqPyhvu/hlRDKRZvrLiXE7ThHXR2qkWPM1tfKaRyc8EG72YrP5q1K0EtHI9
	 k5L5uz7VbHJchAIKuQu/bs0THLayX821u/keNooRO5djeyIwJpSFTEBNYFlD26oETDLqt
	 QuIh+F0c7Xem54JNUg1gJkapSW19f+RY3sX1zOhLXeRQlsC4k+R2gd86SpUBvIK/AL5GC
	 pEo81P0+/jstWnP6CyS5DMevCF4r1ogvx4IGior0Cjq7p8SiWs3ihAWYOgBRvh4C/WKS7
	 Xq4QS5F17PfXAg4VrYhQY2e0Q8AhnX7SXvpMnOhqnR29SOA2g1DIcsVIaYNbAB5qURw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d2yXll24P3honU40Jq3gCzDs85VyV9MZX0fVer0a2m4=;
	b=go9irlTcPZF+LwwTxPfP7HZCre2FVg75j9O0K7k1PAZiJ4b8R2HtEPSPACUR45vGLMPE
	 v83vr5G9mXq6/B/fk7EQwX9/xa3lv2mLJy7rJwQTjms4yIh5ATsk/aErnn6kAThO+GkPy
	 2xkJjMxN2Oc7lVfi+tmeUucYFRHW36aLRGbixT83x6m8r4VRktLwpQQxFCXSd4i0d8Z4Y
	 vNC4Se1dR4a7NXGmlRg4Ak8iPoMUpT+OBM8ZGpSV0UevR1mXfYwFPJTgvred6x/O/JyWD
	 h7zPY8qaHxJZvg6HzyxxpHrZeVuwk9NxG1r+OjqiLhSYwcW0CRGWdlGZnOpHimBqsLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghO6S+p5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD65606A31E;
	Wed, 25 Nov 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghO6S+p5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188051F000C0;
	Wed, 25 Nov 2026 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622255;
	bh=d2yXll24P3honU40Jq3gCzDs85VyV9MZX0fVer0a2m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghO6S+p5LhKiYzmHUZtrqF2NjCUkABogCBJMo9q8JeLaJ5n90DVrTs0tkddjE4ln9
	 vfiYLzjOoU14SjtLbbusMJuTsU3jR7HA/FqRzxerEP+kYejUnMpEasFvnAs8oIjhVZ
	 zwUb8eOiiV23vJD02rWqS+Eoo0lDLrXzDxXBojOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenwen Fu <wenwfu@qti.qualcomm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 478/990] tracing: skip boot kprobe setup when no events were requested
Date: Wed, 25 Nov 2026 15:30:45 +0100
Message-ID: <20261125143833.292557188@linuxfoundation.org>
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

From: Wenwen Fu <wenwfu@qti.qualcomm.com>

[ Upstream commit 2388a673e9276de30c7e917fce50830e497d46cc ]

setup_boot_kprobe_events() calls enable_boot_kprobe_events() even when
the kprobe_event= boot parameter was not supplied. That call takes
event_mutex without any command-line probes to enable.

Asynchronous eval-map updates also hold event_mutex. A normal boot can
therefore wait in init_kprobe_trace() for this background work despite
having no boot probes to set up.

Return early when the boot-event buffer is empty. Keep the mutex
protection in trace_event_update_all() and retain setup for explicit
kprobe_event= parameters. Bootconfig handles its own probe enablement,
and the existing trace_eval_sync() still waits for background work
before init memory is freed.

Link: https://lore.kernel.org/all/20261106021457.2648231-1-wenwfu@qti.qualcomm.com/

Fixes: 970988e19eb0 ("tracing/kprobe: Add kprobe_event= boot parameter")
Signed-off-by: Wenwen Fu <wenwfu@qti.qualcomm.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ee8171b19bee2..52ec16d8d8384 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1995,6 +1995,9 @@ static __init void setup_boot_kprobe_events(void)
 	char *p, *cmd = kprobe_boot_events_buf;
 	int ret;
 
+	if (!kprobe_boot_events_buf[0])
+		return;
+
 	strreplace(kprobe_boot_events_buf, ',', ' ');
 
 	while (cmd && *cmd != '\0') {
-- 
2.53.0



