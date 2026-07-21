Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA993B2D1D;
	Tue, 21 Jul 2026 20:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666167; cv=none; b=Eun0ete08A3bucuflPSqrj0/wXYJ0xh7E5FGHL5OjRbPaL9x2r4qJQ9qWdmnHSRg4S0nPieeedVtDHgHTen1BSHB/TGvjvM+Ka85Gv79b2YSTHEBfj6z/cwI+BF8F1yAiVCN64c6zqgbKoRNYNxS9dndNrBf1gKlSSndliCavLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666167; c=relaxed/simple;
	bh=qF6ZobCe8e8YK4r8YQIN9Zhh2UzlM3AQFEBTm4soK3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUxDb2/LoXA2ZRAUnofv85BuViD/HplAtAlDKW/Vi/2YRVVtC9t7q16Hz4w4TamISqrm7KMka90RfhvYa8+GI4k+ikDc9GQ7NEtEFMvBprRVDzIVSpjZBm97MvDhZyKl+Nee/ojyG5yP6vng7sPq0RAHykxQFv1dyX6YDlRQ29c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGhF3ASq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGhF3ASq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B6D1F00A3A;
	Tue, 21 Jul 2026 20:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666164;
	bh=odX3u8uJlfhuM6x2JMPbXz3VWNdytXDbjxiaAuKs8eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGhF3ASq0ct0jsuV97QH53SfPE3EBCZXbiBOI767gZokGc1p0bm/W84teN29VjN1S
	 T+1AsXjBlMo8FUxp84XnCHDErd58c7AIDnQS13sWSEid+LRdoi9KcKY2KTGhzFwkLO
	 EIh2zexn4BRHJ647vfJGzQvl4HACY+/WZ9IyM1SE=
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
Subject: [PATCH 6.6 0579/1266] bpf: Run generic devmap egress prog on private skb
Date: Tue, 21 Jul 2026 17:16:56 +0200
Message-ID: <20260721152454.823701043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3f710d5af55d4b..8ce3b152dcd5b9 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -687,6 +687,18 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
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



