Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625867;
	b=2+Bpz1ZLemGtaqkBQtbAc/KAPQgsHf6w/oeOzS0YT5uGIxKllY79AI9FwiIXRPyZHRCU
	 gSJHy0tDyhC8oma9S/7G0sQJDaHAV+4WgkcrG6r0xV0gLM9MbOQd3qTK1mO7DRzfF3cS8
	 Lcm1lm5ZjpIXB/WYGPl3tfZDOwaGQlvhdwn586pTkno19ryaD1aYYi+9xHKMm68urJUR4
	 K7vXPl+hPbh92PA21rmYB8ZcucZHmTX2tFLm9s2nNJ+8r/TzKtJRtkpNChFmo5I4SdHb6
	 Gf3Uz7P4+odAghePhHNQUW5gxREuD1Ktsmjwol0TQvCHlGydFIP0h5t5wLoGe8AsKZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vgQYIqRVFcGt8W+UNXPbV2X+TR7kUq/N5RIYk3fmj10=;
	b=pGpULRsy9ToxxMYcw+hteBNeMMrs2zCnSXKQvCh1t7TB5kPFQWif/ksLgFm9P1nzNhzn
	 dO7ceVGfC7X5Yy5B687uwbW4oHQBglvmJbI7Ociz10jclSoh1gtuXI9lNGDvq851U6qKq
	 lTKlz8rbq9+2o5mYv9mN6wLn+++j0h9H/1yflViF95YgBQANzGe6QQgyDrefN72nLMO/S
	 D5/BRBUieqtoAAaqbNEXAYj8z+yJM8va2+NVGg1Rmqj/GK7KbPh2iW66hSC1kg+eb6Ff3
	 weBv3+ehuyAqu1xmo2YMm+CuMKdgFzfu0fdsi04of0Cdsy5gOFXv0lgJ1dPIdf5kZ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2f9P3zT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FC2606A323;
	Wed, 25 Nov 2026 16:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2f9P3zT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AA21F000D3;
	Wed, 25 Nov 2026 16:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625866;
	bh=vgQYIqRVFcGt8W+UNXPbV2X+TR7kUq/N5RIYk3fmj10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2f9P3zTOGzoc/zcV2dXmJ+uZaffwORtjoUGgMfEmeaKz0DceZ0fMR0URur1Wrj64
	 W+s42SfRkeXdnnChuHRAg5QphFehMIwW2ZlrW8DfRZlI7hLo7Biooo4GrBDFRaXDM0
	 cxYn7jJXRRkheHkeK0GEf4zNMCsIRk28OlRT7bJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 654/816] tracing/eprobe: Fix 1-byte signed field fetch in get_event_field()
Date: Wed, 25 Nov 2026 15:36:42 +0100
Message-ID: <20261125143904.319651678@linuxfoundation.org>
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

commit a0f836eea463d4c468edb58eedb03911c9c0791d upstream.

Because the kernel is built with -funsigned-char, plain 'char' is
unsigned on all architectures. Reading 1-byte signed trace event fields
via *(char *)addr in get_event_field() therefore zero-extends instead of
sign-extending negative s8 values.

Use explicit fixed-width integer types (s8/u8, s16/u16, s32/u32) when
reading event fields.

Link: https://lore.kernel.org/all/179455852542.403392.15666310371702309464.stgit@devnote2/

Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -327,21 +327,21 @@ get_event_field(struct fetch_insn *code,
 	switch (field->size) {
 	case 1:
 		if (field->is_signed)
-			val = *(char *)addr;
+			val = *(s8 *)addr;
 		else
-			val = *(unsigned char *)addr;
+			val = *(u8 *)addr;
 		break;
 	case 2:
 		if (field->is_signed)
-			val = *(short *)addr;
+			val = *(s16 *)addr;
 		else
-			val = *(unsigned short *)addr;
+			val = *(u16 *)addr;
 		break;
 	case 4:
 		if (field->is_signed)
-			val = *(int *)addr;
+			val = *(s32 *)addr;
 		else
-			val = *(unsigned int *)addr;
+			val = *(u32 *)addr;
 		break;
 	default:
 		if (field->is_signed)


