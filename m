Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E889260585;
	Thu, 27 Nov 2025 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255714; cv=none; b=YHXjTrwkTne+JChHNqrzJSYWMbao/RZyENW0Ya3Gw0wTjaul9eRNi1AwhwjBBnXff4kAYqVhhUaLXr2CuEeK2ohgidGcJ48n+Rez5KIeYkwRtpeOGOyVYgYWB4LluByhaZX8RamLzMVOs1H5jwutAK067H6hAkIVDJXT6TcAlgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255714; c=relaxed/simple;
	bh=+Ixz5H7z2ORgme+FUeN6rTnTVAriZNP2jTkit5xXB68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSyyz3lPPeJGNuyEEFY++DxRs6vGisSK0TYlQO4iI/igaLrBHKPduL/fdHiANuRmgQfXjgWXOdskzgo+dC5809NxQ9TKztAwaz7dvfn8SYu0gc4AmLY1/dlU4bYlrtr4EGmoXTZcEEtrmgdmKCYR3CCT44v2Vbe1TVoSzw2dkhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYSt8fK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYSt8fK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B69CC4CEF8;
	Thu, 27 Nov 2025 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255713;
	bh=+Ixz5H7z2ORgme+FUeN6rTnTVAriZNP2jTkit5xXB68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYSt8fK91WtbFyLgMD96Y/mY2wvlJj8fL+xiFoJdormHjL+7cDQxrMVlNqSK8FQKL
	 A15GpnuecIEoYMOIIdDwObaT4RmfTXTnEKsmNA/AUr4gnF2P/i5iZr5y2/nE5YxAP1
	 fmh97/urs3WrensHX10jNNKRRbRkBxF6pBos11FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 088/175] xfrm: Check inner packet family directly from skb_dst
Date: Thu, 27 Nov 2025 15:45:41 +0100
Message-ID: <20251127144046.177838125@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 082ef944e55da8a9a8df92e3842ca82a626d359a ]

In the output path, xfrm_dev_offload_ok and xfrm_get_inner_ipproto
need to determine the protocol family of the inner packet (skb) before
it gets encapsulated.

In xfrm_dev_offload_ok, the code checked x->inner_mode.family. This is
unreliable because, for states handling both IPv4 and IPv6, the
relevant inner family could be either x->inner_mode.family or
x->inner_mode_iaf.family. Checking only the former can lead to a
mismatch with the actual packet being processed.

In xfrm_get_inner_ipproto, the code checked x->outer_mode.family. This
is also incorrect for tunnel mode, as the inner packet's family can be
different from the outer header's family.

At both of these call sites, the skb variable holds the original inner
packet. The most direct and reliable source of truth for its protocol
family is its destination entry. This patch fixes the issue by using
skb_dst(skb)->ops->family to ensure protocol-specific headers are only
accessed for the correct packet type.

Fixes: 91d8a53db219 ("xfrm: fix offloading of cross-family tunnels")
Fixes: 45a98ef4922d ("net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 2 +-
 net/xfrm/xfrm_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 44b9de6e4e778..52ae0e034d29e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -438,7 +438,7 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 
 	check_tunnel_size = x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
 			    x->props.mode == XFRM_MODE_TUNNEL;
-	switch (x->inner_mode.family) {
+	switch (skb_dst(skb)->ops->family) {
 	case AF_INET:
 		/* Check for IPv4 options */
 		if (ip_hdr(skb)->ihl != 5)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9077730ff7d0e..a98b5bf55ac31 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -698,7 +698,7 @@ static void xfrm_get_inner_ipproto(struct sk_buff *skb, struct xfrm_state *x)
 		return;
 
 	if (x->outer_mode.encap == XFRM_MODE_TUNNEL) {
-		switch (x->outer_mode.family) {
+		switch (skb_dst(skb)->ops->family) {
 		case AF_INET:
 			xo->inner_ipproto = ip_hdr(skb)->protocol;
 			break;
-- 
2.51.0



