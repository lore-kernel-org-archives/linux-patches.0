Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624227;
	b=16RDvSPPHfkaYf/UKvzITYRhJzDayRnKP9k/5QSYxRDKi6hQjyjPsiD70wnLowEi56sn
	 rXMS0Oyqv/kZWewC78HeSShV8D8FvTNd7N1akDobRI8luLFp0avQqeht+FRGpm0CrjF05
	 K3laElDGEoKNulzmGHSV8N4mXl33meLZuO9c/qrSvBUAu4IlUKScu4RsAR1axJlKF2YC8
	 +hSol9We3LYHq/o6rEnvsNoAA4TyLRSPoK9462ReN4RvvNLhO6PYLxfxNurUOJwmiJnjY
	 xQNyD9hhnXCPNQAW+FnFA+k4g/ItyftF+0ZuhVZrmmhTHbmpDrsj3JbO86c9GrL3w5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOTk+nLw0TLTnBW7T0ZMxdZ51nKan9SU/QiPY8o03oE=;
	b=oH28Hzft0CXOqTKvyBU3WhhEKEZrHzo+gSWgET4hWNU955ZKpYzobJlnn7W4GaWGCu+d
	 7ZBS1qevQ9GtkrXzT93VRDFgbpjNYefNbg6URGPVl58n6TR8+Pnau6pAsn6JTTNQuylrl
	 iYLt/m49cb8QEpVBZUTgkQw9njZs1gIi3DYJrCJ58sguX0WLih1kzJRtxyRlBE1473Rsg
	 cSqens2bT+NxkfBx+YCsfMIHgI3fJHF6Tle9tYHGNGc7j1zwHHkSsHaX4WEUpcM5QTqEQ
	 JEicYZ5xdmu2HiDJZd1nrvLTV5oOjoWJfh10IEdaCE2/RbcY/SApdhP9N/nOdqcdvQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+bkC9Uh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C65606A680;
	Wed, 25 Nov 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+bkC9Uh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889E51F000C0;
	Wed, 25 Nov 2026 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624227;
	bh=ZOTk+nLw0TLTnBW7T0ZMxdZ51nKan9SU/QiPY8o03oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+bkC9UhYgRgr+U7b/EpwbMQ8yjxp08FXN21ZX/TCBVNvyj3B0URZNDIP1oV4hZ4k
	 tXMxJ4G1MbgsBpWLk/fIUhjG80sGP+bxAfeRCJ0qjy+hWglQO7rs3CdAWyr7YklIGe
	 Y24dKlmPwMyCOPod22Gs9Px4g/z4YQ4ZqoDXxTo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/816] net: stmmac: copy XDP metadata in AF_XDP zero-copy RX
Date: Wed, 25 Nov 2026 15:27:51 +0100
Message-ID: <20261125143852.055178892@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 41d78e9ac0984f0e9577e5312e62400b5a6760c8 ]

stmmac_construct_skb_zc() reserves headroom for the XDP metadata and
records the length reported by the XDP program, but only copies the
packet data starting at xdp->data. The bytes in
[xdp->data_meta, xdp->data) are never copied into the new skb, so the
skb advertises metadata that is not there: after eth_type_trans()
anchors mac_header, data_meta points at uninitialized headroom instead
of what the program wrote.

Copy the metadata together with the packet data starting at
xdp->data_meta, leaving skb->data at the start of the frame and the
metadata immediately before it, and record its length. This keeps
data_meta valid for the stack and TC BPF after eth_type_trans() anchors
mac_header.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-4-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 62527de9874e0..a48c34dcbcd26 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5171,7 +5171,8 @@ static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
 		return NULL;
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
+	__skb_put(skb, datasize);
+	memcpy(skb->data - metasize, xdp->data_meta, datasize + metasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-- 
2.53.0



