Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AB444AB61;
	Tue, 21 Jul 2026 21:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669164; cv=none; b=fZAsUHltDhRV2RfgjHl65mk8MVB2zC3AMvCxUWCEbCb+BmKQZGkxo8Q+Gc5NY/QcPsszzrnB1+CSpyjHBgs2iw610ka1N/cVAWulg7gtpKZcZXRpPsCQKz7V4YFNGOTj0AX9keXCvT1oPWnzErUjRsRNXhcH0xHxmADTGEiX848=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669164; c=relaxed/simple;
	bh=iQ3dbV/ZdQ3/idtPfmrD6PNTbYDyrXxlKqO7IylsMQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iM28oca/TmXaQBEkqb9RzbbNmgk8JnMjcyfawczHdTom/X+RBErxsSj5dsLCd9xNhRNE7TiKp14NEufpgkI+Sya3zqoN3W8nTyxyhwxN4isFVUmRAvDgsjaigeOnk+GzSuVu3uXYAYWeSpda0F0GMshENMY4djuOTXNa5nSsGbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKec7rR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKec7rR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFE11F000E9;
	Tue, 21 Jul 2026 21:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669163;
	bh=QXK5ltXD6M9UN1Sol73KD379/2fKQbUe7nOD1VLElYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKec7rR8/fq895wMo1x9ejSZnBDIY1RTXqMZnAPVOO9dEe0qvGHumyDj/2KIXQo95
	 rWuaZB6xx/x5aGebk478OtBbNsENZSoiX7ONxV2OFFEk5Yyf1pIovFiSs3AuS2d0fB
	 y+pdAfIgCKoZfxu4KDIu9jCHpvns9nX1x6Piu4Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0451/1067] bpf: Run generic devmap egress prog on private skb
Date: Tue, 21 Jul 2026 17:17:32 +0200
Message-ID: <20260721152434.706914998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit 6001896f00984d317fb75160ba05c4a885fbe2a0 ]

Generic XDP devmap multi redirect uses skb_clone() for intermediate
destinations and sends the last destination with the original skb. This
can leave multiple destinations sharing the same packet data.

This becomes visible after generic devmap egress-program support was
added: a devmap egress program may mutate packet data, and another
destination sharing the same data can observe that mutation.

Native XDP broadcast redirect does not have this issue because
xdpf_clone() copies the frame data for each destination. Generic XDP
should provide the same per-destination isolation before running a
devmap egress program.

Fix this by making cloned skbs private before running the generic devmap
egress program. Use skb_copy() instead of skb_unshare() so allocation
failure does not consume the skb and the existing caller error paths keep
their ownership semantics.

Fixes: 2ea5eabaf04a ("bpf: devmap: Implement devmap prog execution for generic XDP")
Suggested-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://lore.kernel.org/r/20260612114032.244616-2-sun.jian.kdev@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index fac0773fe9a0c4..f4e28ad6c920dd 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -681,6 +681,18 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 	if (unlikely(err))
 		return err;
 
+	if (dst->xdp_prog && skb_cloned(skb)) {
+		struct sk_buff *nskb;
+
+		nskb = skb_copy(skb, GFP_ATOMIC);
+		if (!nskb)
+			return -ENOMEM;
+
+		nskb->mac_len = skb->mac_len;
+		consume_skb(skb);
+		skb = nskb;
+	}
+
 	/* Redirect has already succeeded semantically at this point, so we just
 	 * return 0 even if packet is dropped. Helper below takes care of
 	 * freeing skb.
-- 
2.53.0



