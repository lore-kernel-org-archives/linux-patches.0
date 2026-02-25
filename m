Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83B1E2834;
	Wed, 25 Feb 2026 01:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983710; cv=none; b=YJrYgGb2eicB+Vu0S6qxC3Dr37i2/J3xmsT+/LHAQv6oCtvwMiTDWKK1GL9A2h6Uf4G9gUtyp22vFrTRqlObGhAYyAw1pmg5TrdcsvuWiS/mClG8jCgEzjN05PHJCs0twotFEl1hY0UovBLOi7rKATflXs2uGTDjv3rGrE5pxkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983710; c=relaxed/simple;
	bh=QTVHyvPVoOmonEHpclWAquqIJW6Mcu0RUJYlV6A/IVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjcV6M3kJEkwEUmOWlplwsfxnQ+0zsoZ5RC+jNboUnqPATdgWe9+PZTmULOAWXgxl+FLSJ32isz6GLE8BQcGsmfB9438q3lVHnNLIMT1lkO1YQ+/l+N0ONY0WHNwWTjWYEKltMAMYWx7VpJarBOCU/0yEZm5R9b+t2+2HeTpLq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAVFchpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAVFchpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFBFC116D0;
	Wed, 25 Feb 2026 01:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983710;
	bh=QTVHyvPVoOmonEHpclWAquqIJW6Mcu0RUJYlV6A/IVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAVFchpTDgUCUE86po7qav37TjKrbJs0rJ+p5vog6GlvAKecthLteOwLX9Z1oJqpW
	 6o7oxwEvkxMeKEJki9JG2qMZs2tIY6Pj4a6I/2H5crYe2AMg5FmQOv8aV/NJTOlwhz
	 X0SVxcMVuRr6brsVbnDbmDTmT7/x3d+cnOr0eLVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.18 001/641] RDMA/siw: Fix potential NULL pointer dereference in header processing
Date: Tue, 24 Feb 2026 17:15:27 -0800
Message-ID: <20260225012348.961361442@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
 drivers/infiniband/sw/siw/siw_qp_rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1435,7 +1435,8 @@ int siw_tcp_rx_data(read_descriptor_t *r
 		}
 		if (unlikely(rv != 0 && rv != -EAGAIN)) {
 			if ((srx->state > SIW_GET_HDR ||
-			     qp->rx_fpdu->more_ddp_segs) && run_completion)
+			     (qp->rx_fpdu && qp->rx_fpdu->more_ddp_segs)) &&
+			    run_completion)
 				siw_rdmap_complete(qp, rv);
 
 			siw_dbg_qp(qp, "rx error %d, rx state %d\n", rv,


