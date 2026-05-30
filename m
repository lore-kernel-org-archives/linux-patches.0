Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B3D31F98D;
	Sat, 30 May 2026 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164888; cv=none; b=XiQBj/9HZOpouvmICgl90rHzr6XBwk+B/Acb9HKuYc4zPqcT9x4TlxBcc2wubM9nwsSF79G8u8mSO0JWXiFH7vBOxDfSvWuZwV2Q6wrPuW3IGz4KFXppqVDp51vTDoyGPr0G5YE94TY+BL2khrd6nkVgl973Cj7BNseqIBMoM4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164888; c=relaxed/simple;
	bh=syGcVg9utqcM5uPljr7iUZsaSwasvkdsxnHDbWbuO/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWIR2rbrWRerWyNY9s6i9Bcm9baQO3P6th7Z0SOpWUeAUE+AI7GdnrBIRzkPjJtnaMjJuW4q+uKvdqvP4RlsZLnpJdgsbJ4vLUzwkx8K3F+n5quWMIH+puaXUzO/7kU5VPSf21QggZ89zgf32IyMnjhkA0474POpb8k3OlSlbKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff2M0Bxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff2M0Bxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728571F00893;
	Sat, 30 May 2026 18:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164887;
	bh=JAa9SvfbCK90SyJk7XIJtFb6o15doLdJHeN9uKIw5d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ff2M0BxdbQTqfBa96dwS72rWIIgXeVflX+vWsJMuiAllfV0FJgZNhpHbZ5zX6ubSZ
	 Lts1YjCBapxvwgeadu8afHw6SZIOAVy1noU97/XxVI6dxHUHzHhdLCV8IOWxoUZM1T
	 N+IN1cSsZJAPQ1YqdSqXd8yl0Holc8WjeLtftyH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 659/776] libceph: Fix potential out-of-bounds access in osdmap_decode()
Date: Sat, 30 May 2026 18:06:13 +0200
Message-ID: <20260530160256.934067074@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1689,7 +1689,7 @@ static int osdmap_decode(void **p, void
 	ceph_decode_need(p, end, 3*sizeof(u32) +
 			 map->max_osd*(struct_v >= 5 ? sizeof(u32) :
 						       sizeof(u8)) +
-				       sizeof(*map->osd_weight), e_inval);
+			 map->max_osd*sizeof(*map->osd_weight), e_inval);
 	if (ceph_decode_32(p) != map->max_osd)
 		goto e_inval;
 


