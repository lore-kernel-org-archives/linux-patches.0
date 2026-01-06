Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1903612C2;
	Tue,  6 Jan 2026 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721796; cv=none; b=ZSDrwuFTKOJKbj9yQ15p14oqFrDic7RDZNpx3DFUMamWRqqqm1FLZeKmgOJf0JG2dDotRhWt1J63omPN5xrfJkw7TghiiWevpGo4/3xxhKQMLjIZcgtYLq0qxujHtKvdUdeLDnn4mHNYNphTIjJbfiky9TLNMANGs3DVN7FbFUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721796; c=relaxed/simple;
	bh=9YIpejEKsCeC75liy2JWdCIHu4pV0XlZDRnP8XK/I0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+0sadQirPQpFYkfRgZPidL+S65Qzc9o0jldBekkPXFW3Lg3imAj3/Mxpb8a7J9snnZIZB+yNV0INPgN4IdnA//TaFu20LGMkL9QRV5xAPHEl2WC08lxy+tINwh+1iQ1d4x1Vc2M6XZ0LaPusyYbqBosvvlBgtIYxDAntjDEegk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgMjOUo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgMjOUo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFB7C116C6;
	Tue,  6 Jan 2026 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721796;
	bh=9YIpejEKsCeC75liy2JWdCIHu4pV0XlZDRnP8XK/I0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgMjOUo5SQ2JamowgsaQH+YrcgmLymWUsF1rPHBDFX4hsBiBOUMWRkClTh2I8CsOw
	 GMOm4/oWDQ1fYzNZZioklbxP3kmlUhTSLB231hBu93PDQ4TuzVCkiNeVoEusXM0/gB
	 bPAsdCxcQnelEQe4P4tSWvy9Jcv4s67+UM/B1pus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/312] RDMA/bnxt_re: Fix IB_SEND_IP_CSUM handling in post_send
Date: Tue,  6 Jan 2026 18:02:28 +0100
Message-ID: <20260106170550.522401018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f01765a2361323e78e3d91b1cb1d5527a83c5cf7 ]

The bnxt_re SEND path checks wr->send_flags to enable features such as
IP checksum offload. However, send_flags is a bitmask and may contain
multiple flags (e.g. IB_SEND_SIGNALED | IB_SEND_IP_CSUM), while the
existing code uses a switch() statement that only matches when
send_flags is exactly IB_SEND_IP_CSUM.

As a result, checksum offload is not enabled when additional SEND
flags are present.

Replace the switch() with a bitmask test:

    if (wr->send_flags & IB_SEND_IP_CSUM)

This ensures IP checksum offload is enabled correctly when multiple
SEND flags are used.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251219093308.2415620-1-alok.a.tiwari@oracle.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index f19b55c13d58..ff91511bd338 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2919,14 +2919,9 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 				wqe.rawqp1.lflags |=
 					SQ_SEND_RAWETH_QP1_LFLAGS_ROCE_CRC;
 			}
-			switch (wr->send_flags) {
-			case IB_SEND_IP_CSUM:
+			if (wr->send_flags & IB_SEND_IP_CSUM)
 				wqe.rawqp1.lflags |=
 					SQ_SEND_RAWETH_QP1_LFLAGS_IP_CHKSUM;
-				break;
-			default:
-				break;
-			}
 			fallthrough;
 		case IB_WR_SEND_WITH_INV:
 			rc = bnxt_re_build_send_wqe(qp, wr, &wqe);
-- 
2.51.0



