Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DA540803B;
	Tue, 21 Jul 2026 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659837; cv=none; b=tsU5qSADUd9ZcCGuhQi9/BgHBlb0hkpUWIys9Bt2AhHBXXHp5CKu1/DSrPggPAtXuF72FYlXTOUPz5Rr3kgvtVp26ivnSZmchvWhiAGwTCG9zkocsrqte2il7FuAh+kB9wKNIv7ZsSEZtqJALA/PmFebTzEuhjAs+lHV4Ed7sH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659837; c=relaxed/simple;
	bh=46PLtg7OoLng3S+P8v6AAAxcqvbUVmvHOuKz8wLbWDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GN7Rf3bOBNRFqca3G2cS0y/wexnHAeRXsm4Dx3cJ0wPxwhNtzkqRE1LsVFOJynFYy43jFFgWu94trNJW0yAyv5UUCpanUpgl8JFz38kvghFGEkZ0ddEkYUBpoZ8hJts7U2eJeioA0ItdFwI0803Xc6Zc2eGjOAjdJP4K3l4vg7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMXoXC6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMXoXC6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41D11F00A3A;
	Tue, 21 Jul 2026 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659836;
	bh=hvZgwI1kKsFiSPD2C8z6TB59l0L5rEMzlfIOUZ07PHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMXoXC6x9OLoI1fNldh9/FzUc6gEPqRShUcnYr+CSBOzIVFgn2In28eiQX1XSvNMW
	 bvPGC8OGIkWDDkRv3JDwth9TIVlw/HJuGfvnkvbotL601+n2nnncvbx3rhXd2rQjSd
	 WeuT/FOG3pyphN6py9AWFpOho5sZ+LQhNrLN61i0=
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
Subject: [PATCH 7.1 0752/2077] bpf: Run generic devmap egress prog on private skb
Date: Tue, 21 Jul 2026 17:07:05 +0200
Message-ID: <20260721152610.528197987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b9eac5342a90d..dc7b859e8bbfda 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -710,6 +710,18 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
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



