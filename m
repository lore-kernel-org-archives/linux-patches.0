Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB44048A3;
	Wed, 20 May 2026 18:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302990; cv=none; b=SlEsSEJvwBfuZUEaxbUYkOvmztFSW32IKvyEC457vDux2/CbJxDPjiR2b9wQeeMh0mnCavcdQclVaKC/Khmulw0I9Sh3SXhe+SpFxDGHWumO22byrPuGpjrR2CMsKSyhkiiSHrzc3VuLLF8SYWTyeIkwVrK9ovVmpge0xXnQRc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302990; c=relaxed/simple;
	bh=5XnvgaOzyWDgG/waiLzmJ6AbYE4rK6gT6YIo4pn4CxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REfRzyj96DVR9m0VLyWTbmCmOSpvzaeteLY5wy9ZkHVkc2NRuPalR0lhCR9KGAT3M06UC2HQ6pweSb9ArsXMAsldLEd9E1y2rDO82fVnKn3JOvmFDCXrHL2XqspLjGyfgop4dhpdE2KoH9ByHk30DCK9RzzFQeIiRHm36YI/PNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3vbnEqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3vbnEqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F5C1F000E9;
	Wed, 20 May 2026 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302988;
	bh=ToOIjAzRirD3BA9AQjq9bhVWRWIQB5lqVeQuoHzsqlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3vbnEqJjhv4Sv0H6rZGhJ81U0K2cGzXEzxMkhVaqez/wrAKRj0d/e7+9FckT5WRu
	 I3erWe4ogqRXRwhCUMdhapGQmixAqiW2LH/whqvTRB1dxej7kj5kknp1Eah//TGXNa
	 sF4DHK2m9z8nLmzTfRpAZuHxPRmX8mPh2N8cB5+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 474/508] libceph: Fix potential out-of-bounds access in osdmap_decode()
Date: Wed, 20 May 2026 18:24:57 +0200
Message-ID: <20260520162108.864797401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 35d0ed82d03e5ee77ea4f31f20e29562a7721649 upstream.

When decoding osd_state and osd_weight from an incoming osdmap in
osdmap_decode(), both are decoded for each osd, i.e., map->max_osd
times. The ceph_decode_need() check only accounts for
sizeof(*map->osd_weight) once. This can potentially result in an
out-of-bounds memory access if the incoming message is corrupted such
that the max_osd value exceeds the actual content of the osdmap message.

This patch fixes the issue by changing the corresponding part in the
ceph_decode_need() check to account for
map->max_osd*sizeof(*map->osd_weight).

Cc: stable@vger.kernel.org
Fixes: dcbc919a5dc8 ("libceph: switch osdmap decoding to use ceph_decode_entity_addr")
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1703,7 +1703,7 @@ static int osdmap_decode(void **p, void
 	ceph_decode_need(p, end, 3*sizeof(u32) +
 			 map->max_osd*(struct_v >= 5 ? sizeof(u32) :
 						       sizeof(u8)) +
-				       sizeof(*map->osd_weight), e_inval);
+			 map->max_osd*sizeof(*map->osd_weight), e_inval);
 	if (ceph_decode_32(p) != map->max_osd)
 		goto e_inval;
 


