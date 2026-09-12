Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483D0349CE7;
	Sat, 12 Sep 2026 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226177; cv=none; b=jZkf9CiSsvlXOai65MUlciUmpjaDtblCxjkmom1YBTdGzXrLQt1RoiE/HCCG+s0EXe0GUEdweoMF7DDK2coJwY5LnCV9VJx4C7GDaz46PCai+S0T55izrEygtRjMAM76mqIbl4cgGRnSDuBcCXDybW9HqnKOvt5OG6V+Gs5OqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226177; c=relaxed/simple;
	bh=jnEZeARb96ilLeGaEtaWqRNfCOjqJY2c8ZtiHklZ6Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBKjkIpLwkwfy7aq9JIFEknq7Xs7H1l9u1WX/zXpV4tEtVT14zO/DoRGP3P+JXp1/V2DTjrUg2DjK37Cu3hcNBoyvihbakLS2e8AA6GHEdM9Cn3ZaAqJtwkeY8tQkvyuPwknZzAbKgK8OgH+4tKHWcltTE6EWQ3agLBNEZ0Irpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PkbMApV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PkbMApV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FB21F000FF;
	Sat, 12 Sep 2026 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226176;
	bh=1SY57xFVp514sfH4X01xxIpVamJ/CPPyS+P4kB7eAOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PkbMApVLr7r9y2Z1JjsxoXUCXLhzhrjEozmq6TATAHnj0nnT5UiRYaxZwwdHB4pL
	 Aykf1w3HOqrLFxMSZ2upv9h7DDHRZOafcCD7zsqfSEh0NavGLNuvJi4SVR7NPXyIjW
	 49bSiiI6oCxXlT+Ebjk1L2B2/6c3r7udxB2LUWAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1348/1424] Bluetooth: RFCOMM: Validate MTU in rfcomm_apply_pn() to prevent infinite loop
Date: Sat, 12 Sep 2026 09:03:00 +0200
Message-ID: <20260912065637.447873987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 44c98fd082eafd49d55a8a4077ff488175b2fe24 ]

rfcomm_apply_pn() accepts the MTU value from a remote PN (Parameter
Negotiation) frame without checking for zero. When the remote peer
sends an MTU of zero, d->mtu is set to 0. This causes the sendmsg
path to enter an infinite loop when fragmenting data, as each fragment
has size == min_t(size_t, len, 0) == 0, so the remaining length never
decreases. The infinite allocation of zero-length skbs exhausts all
system memory.

Fix by clamping d->mtu to RFCOMM_DEFAULT_MTU when the negotiated
value is zero, consistent with the initial value assigned in
rfcomm_dlc_alloc().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index edeb076c537ba..390107643a76c 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1458,6 +1458,10 @@ static int rfcomm_apply_pn(struct rfcomm_dlc *d, int cr, struct rfcomm_pn *pn)
 
 	d->mtu = __le16_to_cpu(pn->mtu);
 
+	/* MTU 0 causes an infinite loop when fragmenting in sendmsg */
+	if (!d->mtu)
+		d->mtu = RFCOMM_DEFAULT_MTU;
+
 	if (cr && d->mtu > s->mtu)
 		d->mtu = s->mtu;
 
-- 
2.53.0



