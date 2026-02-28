Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AFF37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302658; cv=none; b=lG4QwJsRcGRWRy1F761N8kJHGSv0HsTfS4naSIq8ED+mMq8s2J3WMtaYvnofs92zD2JPrZXqBJcZ9XQZttiRymYXQ7lNWp+5NH/5CBaM1B5SDOd1uRRB6Jt+S/i59UoQx2ThevqkKKvNw9NWmnJTiLU+sTDB9lETvVHR23ubwB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302658; c=relaxed/simple;
	bh=ZcLtMZ55CvCApql4v/W1gA/dd+Jadmfq3JsCZ/RypjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ll++H5J5n6UpIBX8Yf+fZ+l3y+yh0G+qgC2/TpFqHTfiLqRVkRo/HCv8l4YMDK1Pjh6ZfcMzgRgXQ7Q8otLej9aJLyQzEIbNlAcxR34KY/nWq0LRkOegl+jOI5zAagRUJGNe1uo/0K89StS24lR+Ru6JEc/4Ji2Z5G7LuLwpK8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SV1dN//d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SV1dN//d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FEAC2BCB9;
	Sat, 28 Feb 2026 18:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302657;
	bh=ZcLtMZ55CvCApql4v/W1gA/dd+Jadmfq3JsCZ/RypjQ=;
	h=From:To:Cc:Subject:Date:From;
	b=SV1dN//dRe3vUn5TOYMfxBZtmoG/xOd3mVf71w1O0bWjTKtFMV2xZqWtLbmg85P03
	 0pV2Ud2dA+NmPqRBXrSe1GhCxeN6SXHEQQg6gNOiY6WpZn5VvPxyacpdqtYRCr+PiG
	 b1EYd6K7mnhyn+YNGgrReDZ+xy6OhPo0uyi0inI6ml4BtKQCbYx2JlgxuBwvBUhHQB
	 QiJMXUzFbGRn+JfS5pcMELl+j1+hJ1AU3mwVPJ/1WdHoAMjIBZbW4op4qbIBQG7m+m
	 0oCtnhjCsuM28jlPMOkimno3REZBjkv6SL1yKpH0Lw2S6/SK5OJhlhu0zSCdCAPTDS
	 E8190DcVlxJ3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: YunJe Shin <yjshin0438@gmail.com>,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 001/147] RDMA/siw: Fix potential NULL pointer dereference in header processing
Date: Sat, 28 Feb 2026 13:15:09 -0500
Message-ID: <20260228181736.1605592-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: YunJe Shin <yjshin0438@gmail.com>

commit 14ab3da122bd18920ad57428f6cf4fade8385142 upstream.

If siw_get_hdr() returns -EINVAL before set_rx_fpdu_context(),
qp->rx_fpdu can be NULL. The error path in siw_tcp_rx_data()
dereferences qp->rx_fpdu->more_ddp_segs without checking, which
may lead to a NULL pointer deref. Only check more_ddp_segs when
rx_fpdu is present.

KASAN splat:
[  101.384271] KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
[  101.385869] RIP: 0010:siw_tcp_rx_data+0x13ad/0x1e50

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Signed-off-by: YunJe Shin <ioerts@kookmin.ac.kr>
Link: https://patch.msgid.link/20260204092546.489842-1-ioerts@kookmin.ac.kr
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index fd721cc19682e..6b049858644e8 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1456,7 +1456,8 @@ int siw_tcp_rx_data(read_descriptor_t *rd_desc, struct sk_buff *skb,
 		}
 		if (unlikely(rv != 0 && rv != -EAGAIN)) {
 			if ((srx->state > SIW_GET_HDR ||
-			     qp->rx_fpdu->more_ddp_segs) && run_completion)
+			     (qp->rx_fpdu && qp->rx_fpdu->more_ddp_segs)) &&
+			    run_completion)
 				siw_rdmap_complete(qp, rv);
 
 			siw_dbg_qp(qp, "rx error %d, rx state %d\n", rv,
-- 
2.51.0

