Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001FC37A498;
	Sat, 12 Sep 2026 11:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212249; cv=none; b=UG22zRVpHr7ONO7PYy4OXnCVdm7hU0N7RaSyRZnz77MCvjmosKqZzly8wNqm8o9cl0sHnOgy4hxcOl2mgiUaQgRL11+py0FJpaNUpzZb2ioLd38UIz63F9UtVan4O89/FgTNOyPCKbdhFNalP9LxnrQ64GED64CVqSwtjvMQGRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212249; c=relaxed/simple;
	bh=BW6BYOEI9aqT89C7M6S589K4QOxOEtQcQt9T1GolXW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oETMsRDkBluKOTr0vrLcC5wIvaeEfmw8UlqEJU25Whqe9dFHDy6tP5Ce4lSmbaan0fJXe/crEAziuKKkVP6vo/OQ8p2JH8qAt5zj7xPQyvg/voCDnnfNfOFOoWF+Ojw9x+iiza7TFmj3iMDY94m314Fhd0Gyvlxrgzffwi9GsDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2RIuPpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2RIuPpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04EC1F000FF;
	Sat, 12 Sep 2026 11:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212247;
	bh=KyztPmw4bJMoWKTGvKTyOjqalWiLkU7s1QTF7w7Y9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2RIuPpM1quzrzbni264GfogxXpYDXmlmBVPC28lorl3yCyLOcU3+fvnKgmfDcEtS
	 MwYkB3Gb1Fm6/oNUgHCxipM92ljXBzaoL+38Dp8xDNn3b0d3id0DVr6AqiyZ885CyB
	 RSwy3pXtERC4x5i+K3qeM5pRu24AMrblAJyf7Raw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1398/1518] xsk: align TX metadata layout across ABIs
Date: Sat, 12 Sep 2026 08:59:27 +0200
Message-ID: <20260912065655.173457041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit bd7d30bd1d3856d8354b5acef947d68ad1faf886 ]

Add explicit padding before launch_time so xsk_tx_metadata has the same
layout on 32-bit and 64-bit systems.

On several architectures (csky, i386, nios2, m65k, openrisc, sh), the old
native 32-bit layout put launch_time at offset 12 and had a natural size of
20 bytes. Using sizeof(struct xsk_tx_metadata) as tx_metadata_len was already
rejected because the length must be a multiple of eight, so the
straightforward use of the interface was broken on those ABIs. Userspace
could still register a padded length of 24 bytes, though; mixing the old and
new layouts then silently reads launch_time from the wrong offset and
misprograms packet launch times. This intentionally replaces that
incompatible layout because the affected architectures are unlikely to
have any notable users. (x86_64 and arm64 have the most users and are _not_
affected)

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260819160535.1472459-2-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/if_xdp.h       | 1 +
 tools/include/uapi/linux/if_xdp.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index 23a0627814687..50d67df78911f 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -149,6 +149,7 @@ struct xsk_tx_metadata {
 			__u16 csum_start;
 			/* Offset from csum_start where checksum should be stored. */
 			__u16 csum_offset;
+			__u32 reserved;
 
 			/* XDP_TXMD_FLAGS_LAUNCH_TIME */
 			/* Launch time in nanosecond against the PTP HW Clock */
diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index 23a0627814687..50d67df78911f 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -149,6 +149,7 @@ struct xsk_tx_metadata {
 			__u16 csum_start;
 			/* Offset from csum_start where checksum should be stored. */
 			__u16 csum_offset;
+			__u32 reserved;
 
 			/* XDP_TXMD_FLAGS_LAUNCH_TIME */
 			/* Launch time in nanosecond against the PTP HW Clock */
-- 
2.53.0



