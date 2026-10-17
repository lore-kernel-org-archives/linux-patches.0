Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9762E266C;
	Sat, 17 Oct 2026 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257420; cv=none; b=j7/3G//mECyfgb6LxYzAznSrCWBO+bhSPSgTNsjEoQKkkdsND+0473DB/rI/1BYboWKK+tCtimHxhYFcEZMqlu5wDNah0KFTyF7+NdTFUlfeAXG1FXlDik0t9AbmgJZp6HOrL73xsQDFxZ9Tp6NBN61U+KP9tmPg+w8/5/oZ9wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257420; c=relaxed/simple;
	bh=HGUNXKQHtup7hy1sdNYs1VNA2NLL1+2JhqO6XUCm/6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgOEulxqeCsriec3oe64nEV4xaGoeiQlhHlGboWomw8anGys5OkEdqE2+qcqqasqN/2BlV+re4sCtddJ3nSFao3IJIO58wA1Uc2C0s4OUDVldJYdbaWuFOi/gJpOYmJ06COjBeAMf7suQ/frfh5LnWGxohLCQHa493MfQE4gBPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJ5vP5la; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJ5vP5la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788621F000C5;
	Sat, 17 Oct 2026 17:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257419;
	bh=mV4jzTu6X4Y5JLVl5JOAiFpNolikugPYt3fNDZKzIx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJ5vP5laTY3hfIOJ1kRU/Nq6T/g18LhXe06kMIts3Th8T+d2KMte35/rIdUJNIDVt
	 spmpdvcqOGnqSDSD88OEiLPa4yZgBxU/QjlsxUcXjIfhGzMZqWDrECp9V6AF0+WZPX
	 Omr72Djet/x19q3uw4utTlf21rbE40jNbhqj51HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0552/1674] flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()
Date: Sat, 17 Oct 2026 17:47:04 +0200
Message-ID: <20261017160445.265051066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit f202578efc738b883cfa04889eb97328914265a7 ]

bpf_flow_dissect() sanitizes the offsets returned by the BPF program
with clamp_t(u16, ..., hlen).

If hlen is bigger than 65535, the upper bound is truncated before
the comparison. For instance, with hlen == 65536, both nhoff and
thoff are forced to zero, even if the program returned sane values.

This is the same class of bug as the one fixed in commit 99bda1ecbd56
("flow_dissector: avoid u16 truncation of skb->len when computing
thoff"). That fix does not cover the BPF path, because
__skb_flow_dissect() returns early when a BPF flow dissector
handles the packet.

struct bpf_flow_keys stores nhoff and thoff as u16, so cap hlen
to U16_MAX before clamping.

Found by sashiko while reviewing the commit above.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261007045616.445596-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 37864578e8687..57fb95186238a 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -999,6 +999,8 @@ u32 bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 
 	result = bpf_prog_run_pin_on_cpu(prog, ctx);
 
+	/* bpf_flow_keys offsets are u16: do not let @hlen be truncated. */
+	hlen = min_t(int, hlen, U16_MAX);
 	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
 	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
 				   flow_keys->nhoff, hlen);
-- 
2.53.0



