Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F4A4F054D;
	Tue, 13 Oct 2026 12:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894529; cv=none; b=u/7Xlva6HL9fzj3CyRq0GSpJiq3XR7gImUZBgECOG6d9MPXjGL2jNTvmdg0nw0dScwF+n4s12B1/DAbNQ9yP+57IUwkMdklu46AEcQ96ecWc/WvCPhnzrug7sHw+g2h2/hLe6PeZFhDS/2JqMaZqsT3RbngUDtpr6xGUZ+cG8Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894529; c=relaxed/simple;
	bh=J2WmCC5j7PnLKciezLZx3TGQZKNP2O3k7ekc13Tte30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnhAn29xfVk0bKvdfL5UEtZBrfbozvsK1FLDAAl+ZgGa8WVC1enMbIaqitMqSzQ7Yciw4XQj1ICxgsJg0U8J4w3A1obWX4C8uv7CkWXSUUfaYeezc7ezuOfdnA6TdKNW+ufhpGLd0yVqrSmMmgnwOgMEvJ4hrUw6L7yrHb3o4N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwIhyorh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwIhyorh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0307B1F00893;
	Tue, 13 Oct 2026 12:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894528;
	bh=0rv/lep338vDQu926/LKmwsfmwSEdw9wcH0rMFYAy04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwIhyorhxG/Khhj9ascUvScdsR9c4v22oxzSFy6Jn9Oaw4Y556/vfFbHHe4rYTPCk
	 mJNiPV/wOkjgMdXBq198HZhjS4hLmj3gGchHpPOO71XYTQNgtMvD0dBkICJYOdNLgT
	 vMxDHtYkQvFwkqYQh0TH1OQ3DmRl1uycGkTKTBxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 592/621] flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()
Date: Tue, 13 Oct 2026 13:39:47 +0200
Message-ID: <20261013112934.852327836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 27d8a01bc9230..1be6c739e3c71 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1023,6 +1023,8 @@ u32 bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 
 	result = bpf_prog_run_pin_on_cpu(prog, ctx);
 
+	/* bpf_flow_keys offsets are u16: do not let @hlen be truncated. */
+	hlen = min_t(int, hlen, U16_MAX);
 	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
 	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
 				   flow_keys->nhoff, hlen);
-- 
2.53.0



