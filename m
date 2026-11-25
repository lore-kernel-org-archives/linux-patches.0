Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622648;
	b=28ARHsrWWDYET841oVo+MUGsLQnSVsIrkwoa2drnqUsYPgdbP8xKyUuHIiqvFzaHS6Ih
	 5/MXUGlFK4c2jdcFFieDC1mpyYs6W/DW5vN8fdFpPHwrf027VdKGtgXmFZFjHW92RPvQt
	 iK6O15uksDpEDTNUEmGGPsQGuD2kjuuA5Tz6//kxFInn/d5myohY1EuITfe59kNCHLDwT
	 13WA+/TY3hSpaDQh63pnZkc4pjlYYfXmmC8odxKO4qzlZcdibbks5UsB19EJMYrQpX7Rl
	 ICSLfzPpXgiDeOSH1ebdSlksvD0MpjPyl5TBDG5bncMseVypmtdtVgh5gEY0Af2L9Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=13cQ3GvTFz9W+/NFCslsqvcCNssQcjfjLSu8vTVt4po=;
	b=Hsbx3Kzj0gaIvuZZOYyj7e5FT5l4R/5M3KYLPH1IXFoH/1RbpjOmad53Tgt8nHRICg3v
	 8wrikVw94Yf8CpElvWoE9/Z/L9L9xX9S9rBPSz+fc0U4JW0g54LwHQZImdmIASdwkrpNT
	 XW/5rGroy6HPi9BMjvdqeHVBObuK6PDihU7gsApZnGfasIO0rmLB2f1uML/6lGIZnynnf
	 iqq6lLG7DfP6O7RoL7vzGVlVqSug0awlKxJmz6HnV2wmsNpfo5gNgipyeFAcrO8GMepdX
	 PPNC5XB2cCOBOr2CCaaM6mtrTt8wxxveM1wjChxd3LsK7qhhOsb5qcsYxCjvBqQxvDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0HTufzY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA02606A31E;
	Wed, 25 Nov 2026 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0HTufzY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B243B1F000D8;
	Wed, 25 Nov 2026 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622648;
	bh=13cQ3GvTFz9W+/NFCslsqvcCNssQcjfjLSu8vTVt4po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0HTufzYoL3SO47lBtR/5kdncxRenAa8vZtYSSRf/0oxICQ6bpqht21OaUny+7i6e
	 UF32HWlP7tU35ycNv7C9EjZqgEU2al3dJUuoAYNSxhYL6O3/5HTXR3fZfluMcusnim
	 tADiId04ek5Ae29i51WoTcHaFc8JkS7LaKDU0gLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 605/990] bpf: Assume no bounds for a writable tp with tail calls
Date: Wed, 25 Nov 2026 15:32:52 +0100
Message-ID: <20261125143836.264568018@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit cd0490e671d70326d70c7d36e82388939fd9b071 ]

A writable raw tracepoint hands a buffer to the program.  The verifier
notes how far the program reaches into it, and bpf_probe_register() refuses
a program that reaches further than the tracepoint allows.  A program that
does not touch the buffer passes, and can tail-call one of its type that
reads and writes behind it.

Take a BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE program with a tail call to
reach as far as can be, as for the stack, the packet and the buffers of
iterators.  It cannot be attached any more.  Plain raw tracepoint programs,
for which the limit is zero, cannot get at the buffer, and a tail call
stays within one type: they are left alone.

Fixes: 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-28-alexei.starovoitov@gmail.com

[ sashal: Moved the added max_tp_access = U32_MAX lines into do_misc_fixups() in verifier.c, since this tree still has the fixups code there and not in a separate file. ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 13da4dd120d74..dc7b4d0280f65 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23178,6 +23178,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			prog->aux->max_pkt_offset = MAX_PACKET_OFF;
 			prog->aux->max_rdonly_access = U32_MAX;
 			prog->aux->max_rdwr_access = U32_MAX;
+			if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE)
+				prog->aux->max_tp_access = U32_MAX;
 
 			/* mark bpf_tail_call as different opcode to avoid
 			 * conditional branch in the interpreter for every normal
-- 
2.53.0



