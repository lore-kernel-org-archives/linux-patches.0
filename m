Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641BC1F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9741C433C7;
	Tue,  1 Aug 2023 09:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882472;
	bh=3WgsGndg6SuR2kMCp0pNceBgAiPDZeB5+MErOJkq6r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQFYT2c0nA6+Fo+SKbktHG340yMZMk4FEXgVgFFaaDBjQr+3RueqSAOp86/LgKDgt
	 vuojQm5Od6lhFxTmE9O0AvvawLzV/j/C8f5MjxD7l/1pqUje4lFh8d62xq1pKLGXcB
	 jtxXZMpye+JbYAkfJm4F3earMI+uusW7SMHGUykQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Benc <jbenc@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/228] vxlan: generalize vxlan_parse_gpe_hdr and remove unused args
Date: Tue,  1 Aug 2023 11:19:07 +0200
Message-ID: <20230801091926.067793681@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 17a0a64448b568442a101de09575f81ffdc45d15 ]

The vxlan_parse_gpe_hdr function extracts the next protocol value from
the GPE header and marks GPE bits as parsed.

In order to be used in the next patch, split the function into protocol
extraction and bit marking. The bit marking is meaningful only in
vxlan_rcv; move it directly there.

Rename the function to vxlan_parse_gpe_proto to reflect what it now
does. Remove unused arguments skb and vxflags. Move the function earlier
in the file to allow it to be called from more places in the next patch.

Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b0b672c4d095 ("vxlan: fix GRO with VXLAN-GPE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 58 ++++++++++++++++------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 719f862fa55eb..0dc7326fd6ed4 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -670,6 +670,32 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 	return 1;
 }
 
+static bool vxlan_parse_gpe_proto(struct vxlanhdr *hdr, __be16 *protocol)
+{
+	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)hdr;
+
+	/* Need to have Next Protocol set for interfaces in GPE mode. */
+	if (!gpe->np_applied)
+		return false;
+	/* "The initial version is 0. If a receiver does not support the
+	 * version indicated it MUST drop the packet.
+	 */
+	if (gpe->version != 0)
+		return false;
+	/* "When the O bit is set to 1, the packet is an OAM packet and OAM
+	 * processing MUST occur." However, we don't implement OAM
+	 * processing, thus drop the packet.
+	 */
+	if (gpe->oam_flag)
+		return false;
+
+	*protocol = tun_p_to_eth_p(gpe->next_protocol);
+	if (!*protocol)
+		return false;
+
+	return true;
+}
+
 static struct vxlanhdr *vxlan_gro_remcsum(struct sk_buff *skb,
 					  unsigned int off,
 					  struct vxlanhdr *vh, size_t hdrlen,
@@ -1572,35 +1598,6 @@ static void vxlan_parse_gbp_hdr(struct vxlanhdr *unparsed,
 	unparsed->vx_flags &= ~VXLAN_GBP_USED_BITS;
 }
 
-static bool vxlan_parse_gpe_hdr(struct vxlanhdr *unparsed,
-				__be16 *protocol,
-				struct sk_buff *skb, u32 vxflags)
-{
-	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)unparsed;
-
-	/* Need to have Next Protocol set for interfaces in GPE mode. */
-	if (!gpe->np_applied)
-		return false;
-	/* "The initial version is 0. If a receiver does not support the
-	 * version indicated it MUST drop the packet.
-	 */
-	if (gpe->version != 0)
-		return false;
-	/* "When the O bit is set to 1, the packet is an OAM packet and OAM
-	 * processing MUST occur." However, we don't implement OAM
-	 * processing, thus drop the packet.
-	 */
-	if (gpe->oam_flag)
-		return false;
-
-	*protocol = tun_p_to_eth_p(gpe->next_protocol);
-	if (!*protocol)
-		return false;
-
-	unparsed->vx_flags &= ~VXLAN_GPE_USED_BITS;
-	return true;
-}
-
 static bool vxlan_set_mac(struct vxlan_dev *vxlan,
 			  struct vxlan_sock *vs,
 			  struct sk_buff *skb, __be32 vni)
@@ -1702,8 +1699,9 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	 * used by VXLAN extensions if explicitly requested.
 	 */
 	if (vs->flags & VXLAN_F_GPE) {
-		if (!vxlan_parse_gpe_hdr(&unparsed, &protocol, skb, vs->flags))
+		if (!vxlan_parse_gpe_proto(&unparsed, &protocol))
 			goto drop;
+		unparsed.vx_flags &= ~VXLAN_GPE_USED_BITS;
 		raw_proto = true;
 	}
 
-- 
2.39.2



