Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246E6386C39;
	Tue, 21 Jul 2026 19:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660959; cv=none; b=G2ESowHsblwipA6L7sZPsG6CoX2cfOLTlnqvCD8pm9jJnjb4kbES39WqbW6LlVg0I3V2uM2lZk0gMZArQx3w1DdkQgfQ1zbbRTDaKBTg180XKoDB8E+JvBlcUJ/Fye8z03/ZpCdfBC3iV4vSz4xL+JRbBrE5RLJKCNU1H8HHmR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660959; c=relaxed/simple;
	bh=rDNEvgx90NpQCALwSXoUEA35hqD9DEiSLIfhg3U05eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t47mTuyoZKU5ej4Q1/df3ZFZo56D4cH5EtHJDqHTxD20UZA8Pvdve4omWxSlNmIlJTGWG7lmlzUn42CdJSIsti3DcLOf/qrkKPoeNRJKQZUhKtCivEeMj2rigo22b0nCxwVqEBHFPj+M4Xe0RTEp0bTUA0Q/lC4bGTK9mXoVrCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCc9Zxp/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCc9Zxp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFFC1F00A3A;
	Tue, 21 Jul 2026 19:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660957;
	bh=canXRkDkL0pPAJEpAZPkXREpXfK/b12bvYPYmOHe0XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCc9Zxp/2V1owxWhlPPkhQAUeQb16kKvurO7hub93smsOvEVX0gXdhpirWx9cSDpe
	 EOnJhvVRR+XYKsod618v+ydH2W30nG42url1u8n1leoOZE7ya2a6YQ/PtXU9RNJoc9
	 aX3dghGrN7zJbZdx80lFYxOoX6F4WoWvQMkya9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Thomsen <write@ownrisk.dk>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1177/2077] net: dst_metadata: fix false-positive memcpy overflow in tun_dst_unclone
Date: Tue, 21 Jul 2026 17:14:10 +0200
Message-ID: <20260721152620.579957630@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 4c6d43db2a4d2cef3921e885cf34798f790d34ea ]

kmalloc_flex() in metadata_dst_alloc() sets __counted_by for the
structure to the options_len, which is then initialized to zero.
Later, we're initializing the structure by copying the tunnel info
together with the options, and this triggers a warning for a potential
memcpy overflow, since the compiler estimates that the options can't
fit into the structure, even though the memory for them is actually
allocated.

 memcpy: detected buffer overflow: 104 byte write of buffer size 96
 WARNING: CPU: X PID: Y at lib/string_helpers.c:1036 __fortify_report
  skb_tunnel_info_unclone+0x179/0x190
  geneve_xmit+0x7fe/0xe00

The issue is triggered when built with clang and source fortification.

Fix that by doing the copy in two stages: first - the main data with
the options_len, then the options.  This way the correct length should
be known at the time of the copy.

It would be better if the options_len never changed after allocation,
but the allocation code is a little separate from the initialization
and it would be awkward and potentially dangerous to return a struct
with options_len set to a non-zero value from the metadata_dst_alloc().

Another option would be to use ip_tunnel_info_opts_set(), but it is
doing too many unnecessary operations for the use case here.

Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
Reported-by: Johan Thomsen <write@ownrisk.dk>
Closes: https://lore.kernel.org/netdev/CAKv6aAM8_EWgXScnKmKYm_4SwGDVBK++dzfP+Y6msUXbp99QUw@mail.gmail.com/
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260616100332.1308294-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst_metadata.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 1fc2fb03ce3f9a..f45d1e3163f007 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -164,8 +164,11 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 	if (!new_md)
 		return ERR_PTR(-ENOMEM);
 
-	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
-	       sizeof(struct ip_tunnel_info) + md_size);
+	/* Copy in two stages to keep the __counted_by happy. */
+	new_md->u.tun_info = md_dst->u.tun_info;
+	memcpy(ip_tunnel_info_opts(&new_md->u.tun_info),
+	       ip_tunnel_info_opts(&md_dst->u.tun_info), md_size);
+
 #ifdef CONFIG_DST_CACHE
 	/* Unclone the dst cache if there is one */
 	if (new_md->u.tun_info.dst_cache.cache) {
-- 
2.53.0



