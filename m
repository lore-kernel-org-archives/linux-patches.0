Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188853F86F4;
	Wed, 20 May 2026 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299985; cv=none; b=MoNVCsrHlmahHBpLH2LMJYyTXb+ZARpUN23AsyIE5SNY0XwuChhp48ivQoYp4uGZkK5dxhk6Sd3VbxFBphTQ67moidpBf4MYTWjYonboOYxz7+z+Ju1MsLpDlF3cxohdr8b8FKy3tdR1TEWfG6Bmxzh69EqRbsXcDC9SzJDq8nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299985; c=relaxed/simple;
	bh=l1DGY0+EwoeYOhihH7+iDtQXaJYpbUplWC6G9Og1wPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCVTu2Ju9EwPUb9PNnW2UNUVvgRnp1b3GzWzQgrBEoVhS5/QbYtLtlxDpx9xTxuQnp+lcVHYnOLHBi/+NepNmwltIl41Kx/M8fax4ulvJR4egYPYpm1IADi2YzCbt1S5HrGUXem6qKIxS6Jo1qMxidVKEMAXf0uDqfRU1XE5TTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzeXNZv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzeXNZv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B671F000E9;
	Wed, 20 May 2026 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299981;
	bh=OTIMDUCL25zueZIflMrzOoqt/vmyy66AlqxphjVr0SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzeXNZv2ZoL0x9S/nFqYwMNBZmYFDM2ypBgIsWksfsF4slG91pJQ0dEVhUIPCT1kA
	 FxpR0SnPU3tUWEsBfhNz4aYe2B9yDQbrsSFuj+EUEbXNdH7vqnJlwnkBZRGelYXYBZ
	 xahrrE6R8CXLjxx3Z+545tjLj29eQC+fcB1eCfcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 933/957] libceph: Fix potential out-of-bounds access in osdmap_decode()
Date: Wed, 20 May 2026 18:23:36 +0200
Message-ID: <20260520162154.822992746@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
 


