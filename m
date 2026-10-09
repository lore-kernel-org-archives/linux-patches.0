Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABE12D8DC4;
	Fri,  9 Oct 2026 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555504; cv=none; b=E463R2kI7vbNlql4rMgsyvPEk6F+D+iZmJYKFgFdIOWfaxbhokAvmKBLNs8DGstJzTy0ZvnoXZVQH/iVjN6gw6+hulMlTq4s8+JRbrXFVZR+F80RmD5eimu/oPYKhhQcpxkTObw9CDdILO5WxObXtn5naXoPhVKhTYhR32FCVAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555504; c=relaxed/simple;
	bh=RPXrTlDqSkwjKuQWYkGRpkNMHUZ4wfPhAh7F9zIgqUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa0GxEw+fGfdRtxajoHrTSH5ChNmz97Ek13AbYq9zaCjp+XrsUg0MC+QEa40TSD7Gva57c0xl7wp8SC5K6Au/1T6+maB/vTPCDyD42hDHlaNMTHRLHrnlIWDP11+xWdLcD/1xXArFabGMc3jFOgEdTt602LN7eos3IYD98+CIqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3yvvcla; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3yvvcla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0337B1F000FF;
	Fri,  9 Oct 2026 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555502;
	bh=Mc8YgNwxMlbdzu7/OIjOnzv2XkI43P6HzZL8S5GcnRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3yvvclanpGBfKw9DsFHvDSUxtDtILRvPfMzz1PrAuYpeNq40DdksEpxyyL93ZJOr
	 r7KUyh1jfDGUMvY4XUuoTPYz3KT+ho+/Gt+cWNZkHWunoxHsnkZkHjSvSQQAr7Ba15
	 7RkJd3daBRLvbAW0BOwV/2FrVzpGkjviepiA08R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 027/403] kprobes: Skip disarmed probes when checking optkprobe overlap
Date: Fri,  9 Oct 2026 16:06:28 +0200
Message-ID: <20261009140952.749490439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

commit 7a39c732a22ec4a369af9e19fbe3d666ec83eec4 upstream.

On x86, an optkprobe at A replaces five bytes with a jump. If a disabled
probe B is at A+2, get_optimized_kprobe() stops at B when arming a new
probe C at A+4. It leaves A optimized:

              A    A+1  A+2  A+3  A+4
  A's jump  | e9 | d0 | d1 | d2 | d3 |
  after C   | e9 | d0 | d1 | d2 | cc |

The INT3 for C overwrites the last byte of A's jump displacement, so
execution can jump to the wrong address. B can have prepared optinsns
while disarmed, but has no jump to unoptimize.

Continue past disarmed and unprepared probes to find the active optimized
probe before arming a probe in its jump.

Link: https://lore.kernel.org/all/20260930053618.104498-1-leon.hwang@linux.dev/

Fixes: afd66255b9a4 ("kprobes: Introduce kprobes jump optimization")
Cc: stable@vger.kernel.org
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -493,14 +493,16 @@ static bool kprobe_queued(struct kprobe
 static struct kprobe *get_optimized_kprobe(kprobe_opcode_t *addr)
 {
 	int i;
-	struct kprobe *p = NULL;
+	struct kprobe *p;
 	struct optimized_kprobe *op;
 
 	/* Don't check i == 0, since that is a breakpoint case. */
-	for (i = 1; !p && i < MAX_OPTIMIZED_LENGTH / sizeof(kprobe_opcode_t); i++)
+	for (i = 1; i < MAX_OPTIMIZED_LENGTH / sizeof(kprobe_opcode_t); i++) {
 		p = get_kprobe(addr - i);
+		/* A disabled probe can have prepared, but inactive, optinsns. */
+		if (!p || !kprobe_optready(p) || kprobe_disarmed(p))
+			continue;
 
-	if (p && kprobe_optready(p)) {
 		op = container_of(p, struct optimized_kprobe, kp);
 		if (arch_within_optimized_kprobe(op, addr))
 			return p;


