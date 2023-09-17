Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A416FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16DFC433C7;
	Sun, 17 Sep 2023 20:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981161;
	bh=27EL6QPSkvalQGsGgaRVNqzTyKk7T8Emu7lIq9XJmp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZGkU9Y4y4acmbXG8wmIZ3bUSfcwdE21UEvFFRgco5lKRaS0uaZwoApu2d/W9zOnS
	 WMlbv5YdkH+v7jrWxsZezSydT4m7orRbZLQAxVRXMSa9k4VFQjEiE/eW1FJKIT8aRu
	 1LF02piL7lSPsOfydnF78j/QQlxOC24PlXXtiCNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Benc <jbenc@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/511] vxlan: generalize vxlan_parse_gpe_hdr and remove unused args
Date: Sun, 17 Sep 2023 21:07:21 +0200
Message-ID: <20230917191114.177877991@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 58 ++++++++++++++++------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 106b66570e046..41b1b23fdd3e9 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -730,6 +730,32 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
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
@@ -1738,35 +1764,6 @@ static void vxlan_parse_gbp_hdr(struct vxlanhdr *unparsed,
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
@@ -1867,8 +1864,9 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
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
2.40.1



