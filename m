Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1532FDC5E;
	Sat, 30 May 2026 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162100; cv=none; b=gyINMYtDg4jH022OgPIUTfurlwbcJIDFQHsx8pmfhE3h0yViZfYLxL0iMDWe2xaeWd5WkYiabPzkJGDjCroeY+2ntHjMXSeeYye610N0UclOmuQVbFKQS+8CCzggFngwqEFXXFCKpwp7GhtTLiq6x3fGT0g3WqTh9RXkvUliwHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162100; c=relaxed/simple;
	bh=vTAHJ8wFF0OuFKah8xuST4e63Ri7XjGzQxql/0UiwPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTA6R4rVDu3Y5gkGJn1ygWM77qFc0I03xyJWnQ4JzDJPxd4UQ/7QwfPes5pnP+rixJ2Dbi5HsCVp32mAsT0E/oADC/sgCVv0WZSZbvEdWfRYirUALx2+2sa+HV7QoNgpnhlxZiu6YuycGp4iGwFal7HYiyCokoyANW13medA2tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KixQ9fDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KixQ9fDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA841F00893;
	Sat, 30 May 2026 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162099;
	bh=ks1Z3CbX9vr4YGgpZxdJyvaIn4tIoWEcmXYEYHQAMck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KixQ9fDe/S7jhFwqvbEFpMx+tBBqWMJIRNLgqxaYxGPRzGfs5ZwRe7Fie7EYUYiH2
	 U7UHko0CdmPVKuzKKYX0WI1hc72gtcP3DDGo7shegVEImlr4QZ3hp0z8av5V0AIqgQ
	 LDcqpKsb2IjhnZcuW6ZJQt2XQrRPLhYO2XbR2ol4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 820/969] libceph: Fix potential out-of-bounds access in osdmap_decode()
Date: Sat, 30 May 2026 18:05:44 +0200
Message-ID: <20260530160323.284729846@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


