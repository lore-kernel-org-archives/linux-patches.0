Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625959;
	b=4sA/XEODTkbeYGyeL3VKKdgL/q6kFHVSMG5DyEHWFgkJKEpGbMjXZiYbzEtcBLh4JrTr
	 poy4h9JgAwOG3Jav0gJTRJu3mp8XEsIHLLTtP3UvqJ14fYIc3Wx4OTRWrIFjP3ednEXPW
	 TazZ81jJEK9haArhJetwCNvQJJZEQfDvxoX7mzJofAX7/qq2nCzi7QXHgGfngphHQs2Ak
	 FwSiqngOIUdAeUk1sXhpmOCohfTyu68gQHlMDhAaBGSSKs/GqnV/gEGSuUJH2xxat1QzU
	 mEQunaI8OSJnmgf9jEQzok+rt1+//j/uOPhhXG4S9fCChL/QfFMer2Y9guxIYsZSvVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZnlRdWpouLYqK1g2T/uQQRBmJBMyXScp4LJctE6C2I4=;
	b=ZVs+UWGexCT5yHfhr7HXEyhq+fm/tVFyWLeI7XGB+92tlocx4VwCPPNhJejjLtZoMIDh
	 PgeIFCNblGMS/mXdnHnPZTlEjpIItBzl8I2zk/wmtwK0i9F0fdh9gec7ceeAoVpWxQtWP
	 kg/cHc9BbGVEaTACFmjXwda28TvbWXbr+91K03ta2yYxgdUOE7B4qiwLFUn2Nusqc+elh
	 odxtA0kRo2PMU7lVCBWosieJOLPrtEFfwGlAK9Za23tDAhrKGEnrIqUZ3sGbuETnZ/6kg
	 p5lgsC5YqffjfcJKnm1RosvukxMUVmZDsto8tvaQ5kUwPtY+Gypl6OMs/uht0/CrEnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwFp3gLu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F287F606A326;
	Wed, 25 Nov 2026 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwFp3gLu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3506A1F000C6;
	Wed, 25 Nov 2026 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625958;
	bh=ZnlRdWpouLYqK1g2T/uQQRBmJBMyXScp4LJctE6C2I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwFp3gLubX7FkySJyQL9ypAl5dhR/jzvEsoKgTiSMZ2K75R6wTbjOCS/6M729bt/y
	 lDuozFPDDzDH9Ah7Ln4BCGbi89akmAfyDNDGM4QiamlBaoetGws7YfsK2izr+fJkdq
	 lu+fHsGKAshJqFa+DN6bBHq7WSAx/fAwN/U3dkIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 658/816] tracing/probes: Reject array count on non-dereference string sources
Date: Wed, 25 Nov 2026 15:36:46 +0100
Message-ID: <20261125143904.411907119@linuxfoundation.org>
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

commit 0941144ebeaf3ce46c80711f00e935921eb28b21 upstream.

The runtime array loop (FETCH_OP_LP_ARRAY) for string types requires a
preceding memory dereference instruction so it can advance the pointer
address on each iteration. Non-dereference string sources such as $comm,
immediate strings, and eprobe event fields cannot be indexed as pointer
arrays, but finalize_fetch_insn() still accepts an array count on them
and emits an invalid FETCH_OP_LP_ARRAY sequence.

Reject string array counts when the preceding operation is not a memory
dereference.

Link: https://lore.kernel.org/all/179455855309.403392.4197028577158545202.stgit@devnote2/

Fixes: 40b53b771806 ("tracing: probeevent: Add array type support")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1367,6 +1367,12 @@ static int finalize_fetch_insn(struct fe
 			 * For the symstr, it doesn't need to dereference, thus
 			 * it just get the value.
 			 */
+			if (parg->count && (code->op != FETCH_OP_DEREF &&
+					    code->op != FETCH_OP_UDEREF)) {
+				trace_probe_log_err(ctx->offset + type_offset,
+						    BAD_STRING);
+				return -EINVAL;
+			}
 			code++;
 			if (code->op != FETCH_OP_NOP) {
 				trace_probe_log_err(ctx->offset, TOO_MANY_OPS);


