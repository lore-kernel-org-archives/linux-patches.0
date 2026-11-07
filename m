Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065289;
	b=tGGf6KcSFpArVi2YnC6qq25OPtk90IkJcPNrppt81rK/JB/9loikfLjA0XcZjx6X3cI6
	 QlZyKC80el4T3MkQlcYDbnc4BvYFVudcjGNqowq6oV/FT9zG3BsCNWfYmNYCfSQ50kHLW
	 +WaizF1scDraKfkrr1ocsK/Ihv85I/qKub9Th4SGdt23i682fmwE1fK8RgAB464v1Qc9z
	 YebSpvQeilVUdl9RvULg0LPZtteDQcYukqzA0vahx44h+gNGL0c7R5HhD5BrJSEmGo9TK
	 /6ScFVrhGxs6cj8sH6mfAaaw1Bu3+ww6RxYW6Ybjs5YJQXw6EaNyUdjMs3HK8Z6or1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IWXPnsbInVlkq1NEDhm01CcfJa+XL5eAgtvhjo67U3c=;
	b=f4pRgVu0Y2zy6VLZlGGvHRSojSSd1O1hCo+vhnwoVBbnWr4YRhY85tibayyoaKjJRc5T
	 DEt9+Zzybv+FouLRu2FZ9sgbfJ+cmyHxv/pLg/BmHXzVeSJ9YGlnqnMXU/j8exdnz8mT/
	 kc/TnIID7lIr/z0E1zUNiX9vS7KZQoRsdQe04ltWiqaKY/woXfAqKeWjAxVQmUWolwmyL
	 6Hbq9h8MnDerRhP31Xn/bo4PHVDcvDGueqUQxt+xRgnAmdUNeJ2t8Nbth2s0fyFVpqL3J
	 HSy3hXx1YWHjK4x1vv37MnoIXxVYsErZpJo0VUlK1I3Es6Q9akquwdbvzU1OAHcrMyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=buyEOCw2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF64A606A333;
	Sat,  7 Nov 2026 15:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=buyEOCw2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE241F008A1;
	Sat,  7 Nov 2026 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065288;
	bh=IWXPnsbInVlkq1NEDhm01CcfJa+XL5eAgtvhjo67U3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buyEOCw2NAUt/HMSr2UZZWiQvGywZK/7gVQ7ihgm8QYgo/DJCL/liF4x5NM6w2Qi6
	 Ka3VqAwqQIoRb+uGxa/XI2IdH+ov4jAMMH9RoH3nwOHJtN1ICFJmw9dpJVR9hwY8uK
	 98pbgE7wfYMpEz51o4Z4qcPHPFow9XO8sBR0Ekjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yanxia <yanxia@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1047/1257] veth: fix stale peer max_mtu on XDP program replacement
Date: Sat,  7 Nov 2026 08:55:43 -0500
Message-ID: <20261107135008.219482925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yanxia <yanxia@cmss.chinamobile.com>

[ Upstream commit c955325db639e9503941227e14e1f1ccc99442a1 ]

veth_xdp_set() calculates the peer MTU limit from the incoming program's
XDP fragment capability, but only stores it when no program was attached.
Replacing a program with one having a different fragment capability
therefore leaves the peer's max_mtu stale.

Replacing a regular program with an xdp.frags program keeps rejecting
otherwise valid jumbo MTUs. The opposite replacement leaves a larger
limit in place and permits MTUs which a fresh attachment of the regular
program would reject.

Update peer->max_mtu after every successful attachment or replacement.
Keep the GSO feature update conditional on the first attachment.

Found during review of the XDP replacement path and confirmed with
native XDP on an isolated veth pair. Before the fix, direct replacement
rejects MTU 9000 after switching to xdp.frags, and accepts it after
switching back to a regular program. Detaching and attaching instead
produces the expected results in both directions.

UML tests on net reproduce the problem before this change and match the
detach/attach controls afterwards, with both devices up or down and
with either endpoint receiving XDP. Failed replacements preserve the
previous state; same-type replacements and detach also behave as
expected. Small-frame traffic passes in the devices-up cases.

Fixes: 7cda76d858a4 ("veth: Allow jumbo frames in xdp mode")
Cc: stable@vger.kernel.org
Signed-off-by: yanxia <yanxia@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261020020147.790274-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 643b97dc52456..7db389ae866dd 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1622,10 +1622,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			}
 		}
 
-		if (!old_prog) {
+		if (!old_prog)
 			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-			peer->max_mtu = max_mtu;
-		}
+		peer->max_mtu = max_mtu;
 
 		xdp_features_set_redirect_target(peer, true);
 	}
-- 
2.53.0



