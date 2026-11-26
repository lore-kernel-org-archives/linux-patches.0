Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704518;
	b=bEXsZJ44BEWoXtQBU84EvI8beeZ0aQo18k+i8qK29XnGo3Fc9hkCFes/C0sXbw7eu5oT
	 5ufkBCwwQPcb2MnFwzCpdnTlkNGNwK/cyhrLbrHkb8qDT3pI7EKUQegv0AcpDJWal/rwe
	 SW83r9wdl/iy74pMqVD0y6CeCU6s2X2KaD1l00vqhxU0M1VOdcBnvFsQkfbAKjeosVIWi
	 XiiQ8AdEERaIs674KPxaB0gygLRBgg0Af38AbweZUzPnqANAH7KRNYXD0X54xtHH4BLYE
	 I86Ot1BmFhOLSk4cR0FJyAVd5q9B9KhrV7Scm8Ta2Lh/0sCZlcL8mrwcmZOLFc6pXIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rp2EllO7Z2cxceMMvQq0xRulD0MVpKDc8cwqriETh+8=;
	b=BknpRRzw5S94eg5VGAhGGtyAqrnBLlRrZ5RJZ2D3WWmaWG0SdIOE0eIcU7FAuWcBbEFo
	 6S2WTdn6dwVDQ5OFmGrC20Cl30JxO08MnBWrow8NsVs39IEwwA9MudlKU81Me7z50GB0G
	 AK82wLefjtbpiyBtVn+GGRc2KbMjF5SCUiLDMa6IyBhr3RI85RgfZ7YoJ+/qLlQ1JdDfZ
	 /oKpd+VMHeRxlbkmPwvsXXE/77Nn7E/8PrPQ1E4ZrKYC0ZkiyhKDrYZ4jww6W6SPenw7l
	 3nCLL8qI7p+wa1VhP36wg2/BxEvtdIfYSylJgVzsQPtv+m8oQafYJYueJonOiFWl5TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIVPt8b9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41137606A327;
	Thu, 26 Nov 2026 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIVPt8b9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947521F000C4;
	Thu, 26 Nov 2026 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704518;
	bh=rp2EllO7Z2cxceMMvQq0xRulD0MVpKDc8cwqriETh+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIVPt8b9FHwtMVRI8PN/BMvy2uefVBnfaQ+0oDuFHFrSJoSMa8HD+S0ktct8XgCFm
	 aHuXQqcV1ivFcjXcN+uzLTYcYLgBcy7okL1poh+63V/dFqd4rjamWmvmNVF0TGtfSV
	 Bn5hNmNXrfBDrh1dc5Gge5aRwk7msiBAfUd5qRSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Sasha Levin <sashal@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Kees Cook <kees@kernel.org>,
	Jean-Paul Sergent <jpsergent@gmail.com>
Subject: [PATCH 5.10 153/265] net: dst_metadata: fix memcmp overread in skb_metadata_dst_cmp
Date: Thu, 26 Nov 2026 15:38:03 +0100
Message-ID: <20261126143615.768035235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Paul Sergent <jpsergent@gmail.com>

commit 74a7db839308dd7d1c3f72dd1e3299784df3affb upstream.

Commit 3fcece12bc1b6 ("net: store port/representator id in
metadata_dst") dropped the options_len equality check when converting
skb_metadata_dst_cmp() to a type switch, so the memcmp length is taken
from skb a alone.  When skb b carries fewer options than a, the
comparison reads past b's allocation.

Hit in practice with Cilium geneve GRO aggregation, comparing an skb
carrying 12 bytes of tunnel options against one carrying none:

  memcmp: detected buffer overflow: 108 byte read of buffer size 96
  WARNING: CPU: 0 PID: 15 at lib/string_helpers.c:1036 __fortify_report
   __fortify_panic+0x9/0x10
   skb_metadata_dst_cmp+0x11b/0x120
   dev_gro_receive+0x303/0x620
   gro_cell_poll+0x67/0xa0

Restore the check: unequal options_len means different metadata and no
aggregation; the memcmp only runs when both sides carry the same
options length.

Fixes: 3fcece12bc1b6 ("net: store port/representator id in metadata_dst")
Cc: stable@vger.kernel.org
Cc: Ilya Maximets <i.maximets@ovn.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Jean-Paul Sergent <jpsergent@gmail.com>
Link: https://patch.msgid.link/20261109082410.206140-1-jpsergent@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst_metadata.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -79,6 +79,8 @@ static inline int skb_metadata_dst_cmp(c
 		return memcmp(&a->u.port_info, &b->u.port_info,
 			      sizeof(a->u.port_info));
 	case METADATA_IP_TUNNEL:
+		if (a->u.tun_info.options_len != b->u.tun_info.options_len)
+			return 1;
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);


