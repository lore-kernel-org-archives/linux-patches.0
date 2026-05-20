Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19DA3F4DC0;
	Wed, 20 May 2026 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297268; cv=none; b=bFx2xtVXyUeAxJkoKhoyYkxP7JAgtIxJL6KEJhKMTXJSmosLdbreKke+beEbb095vzq4glYw4Js7HwGL2mkD/Xc/hRqkHiGsHmGkXa6fYFAmnJAAkkDDFdhu0E/rxchdZ2wmTd7pTS5xAax0F/ivuUMdfb28meA08xmEo36olas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297268; c=relaxed/simple;
	bh=7HT3cBloBWIPaM6DuIJyPg2VCxO1hi+NDYTOJ5EalOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk3krtr7qy69RRnDO+fT9CHCZl+zVXgM8B8oSMOF4JrrMjo5TiCiQ4Ddmuw7jLQ7fHRwrGpp8MapJMfZtO5U5MnZN7aMyfDYhlHF/ONfBcPPIrtyFt1oJ0V4qGy1W/vO79hpwzW1zPT7BcvHqUOVwLhP8aeq6FSdRGA5ZvApIsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofVJWMaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofVJWMaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305841F000E9;
	Wed, 20 May 2026 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297267;
	bh=TSvgkmrNwBuRQPkgn5gD8eMMmLt5Cy/eXIb5cfJZGBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofVJWMaC6XelnrcTNNpFPQhTPuzYBPsQt/QIyxfRvXWpbOWoGU5yp50pAF+t1UiQY
	 oPBhnzSJybND4Pf8iamYTI+pS2P8TRQPdnh9h34Qsw5amEixXnySX5Nd0en0A4Qtxg
	 YUdpGwe+oHgkjKb7eNsGnqITmCCDwWzBZ6buipx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.0 1114/1146] libceph: Fix potential out-of-bounds access in osdmap_decode()
Date: Wed, 20 May 2026 18:22:44 +0200
Message-ID: <20260520162213.456133766@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1702,7 +1702,7 @@ static int osdmap_decode(void **p, void
 	ceph_decode_need(p, end, 3*sizeof(u32) +
 			 map->max_osd*(struct_v >= 5 ? sizeof(u32) :
 						       sizeof(u8)) +
-				       sizeof(*map->osd_weight), e_inval);
+			 map->max_osd*sizeof(*map->osd_weight), e_inval);
 	if (ceph_decode_32(p) != map->max_osd)
 		goto e_inval;
 


