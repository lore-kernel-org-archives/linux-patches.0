Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063655;
	b=fA9wPP2Iqb3ijnqRSGCMXaIgEdANr8F8ih+q3NEi/8IRIBT61cA9512r+VjoA3yXTjr2
	 QTZe+2BQnoq4bH5Yvi8OZlghTFX/C3qPGxTFXXiLjgbsnDTRhjjW0mBEHXqlWcSUb9Scs
	 ncbstUdt957ArXa3Gv3KfmFXQ8VvB+oh88WNAmwF5s75LPP7joCqm4rR1ag3uRCg5OS6H
	 1FSCLgasojkAZSjU1SAnibShkogMB6Wj1y8tWEC/b0c7GS/M7vLbCtxOCyKbL9NWNsWA6
	 wKaJ1vz2npYp1iEmAlhZaDHLLxJfD0hIPokhRfLuHwTvnE8JC5Gl5RqdasDl+awv4RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VZXph0xTfLHCeh5HFXLUTfuFtXryESR3IEB/Qr+SXGA=;
	b=L0nBRVTmaZwCJTBDQlSce58VnbJb0z2JFe2zfukUNQf6BousyvOQzuaaomoHaeROU5mY
	 F2l/PfSdjBQqqRzO2W3R9JOOmMl+jmacIiX7pJz0GifH8HVieUp1HeVFAXvCldIi4yaaS
	 Tua6NFTvgDGd4vFsfqNfSabM5pqHJRNoUSdQHue3q+pFHP66fdlDBTdRY2So8Yj+enLjD
	 RsYOlOD/1AiwK9KV9vNWas2Y1ByV2m8PSGJBcl3XSQAsZmdWniy8R6iOY1NSU3RjXC/Uq
	 qThHbTVPAopfRH+fGLfvBhweTyI1nKrcKU2+9/M8qN8XIWXBJieEw56I2qCf4oYu2ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2xkkO2s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD61B60A6F4F;
	Sat,  7 Nov 2026 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2xkkO2s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9691F0089F;
	Sat,  7 Nov 2026 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063654;
	bh=VZXph0xTfLHCeh5HFXLUTfuFtXryESR3IEB/Qr+SXGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2xkkO2sxtYth9eZeIvAxzymLIqAmCs1KJDPksPY9qkGStL/RrS3kz/HCTV4z82n8
	 Je1XqwDaZ1y7US2rVflmisEbdRG7uzy3Q3E1MN6b24CX/I9tGp8KfH1zhQ9Q/yRThG
	 lyuEWljmWWKAcawiRjXWyC6CQf3bmjSa2iLO4jtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yanxia <yanxia@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 730/869] veth: fix stale peer max_mtu on XDP program replacement
Date: Sat,  7 Nov 2026 08:56:52 -0500
Message-ID: <20261107134917.529660429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 148114ab85ac3..25cdbba5dfa9b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1621,10 +1621,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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



