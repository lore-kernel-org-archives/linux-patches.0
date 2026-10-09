Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F09933AD8B;
	Fri,  9 Oct 2026 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555414; cv=none; b=SFXJBzZJLEwFUnulJVPoHLZ3QUsKBxVW5VGnWuFApmosU4G4e2+u5AhT7Zhs5S7KRj2kzMt/uCrsn4+0IeuZeW2FGyX1EIK7wbKNVtyu/NoH4PuSrwCcL7+052kFZ5U55bCtzAoHnHBYI5Xo/vJOAHTsGEPFSpRXigEXHiOFpEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555414; c=relaxed/simple;
	bh=ZX7BaHhfzq/4eWspuN0v46kpM3ChRbDravQdIbiYEpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuTPB/kVszqqL4IHw0BmsOnfhnPVsUyCXT1qXnr6zK6BZGoJuxaVapQvNab+uaSbyV2j44lpf7h55RQDKfztg/7gctND2RC9nv5NmO3XVhnDqovhCQTMGZYccAyneldtr+AMsoTrj4cwmfUIcJgTQKffvfCv8KM5Jtba3QlUONs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjdK1wVV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjdK1wVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF7B1F00898;
	Fri,  9 Oct 2026 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555410;
	bh=TI1EmJ8/sU0cewAQC9dGXEnOk2axLQd0OOETEtkSX74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjdK1wVVlzsOU3iksW6663QjWcSP65/fWU6RyJhVVXoJGkPMdBvahauFTAgopCc+P
	 cnGWkQ3QK7yzlU2w7iDoLL4BEAoHisI7QRbOzNmenSlfCHQAbq8bxDrZtP2gxGwb/H
	 Ci2qtN78rt7GaLLc127mi4Uz95cAEbgOx42ayNEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Thomsen <write@ownrisk.dk>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/403] net: dst_metadata: fix false-positive memcpy overflow in tun_dst_unclone
Date: Fri,  9 Oct 2026 16:06:49 +0200
Message-ID: <20261009140953.228857097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1fc2fb03ce3f9..f45d1e3163f00 100644
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



