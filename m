Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC1B35AC1E;
	Tue, 16 Jun 2026 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626780; cv=none; b=S3XN+NDa4Okiqho7MldtHHDYgoqTRx3Mi8hP0AJlC1Pu/CHjKyKmwOLSwg4ukMytXQd/AFHiArVd858j4VRbFNUY+xCaV0APPGOeISvP6Xq9yvJaRIL7fbZWssZo5eODCJkHBtQ4nSU1PQsEf0Rqc2ur6nOnSrpjb3k9aON/nQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626780; c=relaxed/simple;
	bh=ZtS0xGQIhCjpftgIGizs53gt6hkMBSOYeoisrn6OoqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsz2Anl1UwbXCpPmyUEkSjmDkaIvGDdo3OCaLeRYv0hJcRqZGyx1Y89GyaJYXyPKN82puAb1OkIT/+f3Veg2EV5FSm8bChDCg23PdMmDevzA5iSrbnj+qRDvFM+tzFoEAjynvFPgwL+8TSh54iIq2JeFMqPRkNVOqOwRR7UH7DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/87Y1bC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/87Y1bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C254F1F000E9;
	Tue, 16 Jun 2026 16:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626779;
	bh=aKJPgmwyEQbK+Nr6tpDP4PE2pWkFKMhAZ6dxsauaqEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/87Y1bCGJKu1eiKDlPhOWMjW/5FKQ65JoKZ52XNsuHfY7KAFQrNfsDqWJRiE8qjZ
	 ar+CPAgfY3LdFMe1n0ZfCvRyubT89G4JItTvjniJGyUR3aSaaAg1yIejwrvz9UXW/g
	 OAEAsPKg8lXrXTCTgKo3aqK/pKzidopuWW+u+i1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/261] tap: free page on error paths in tap_get_user_xdp()
Date: Tue, 16 Jun 2026 20:28:27 +0530
Message-ID: <20260616145048.324350430@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 3bcf7aec6a9d16438f2cec29f5d7c8d5b8edf9b2 ]

tap_get_user_xdp() rejects a frame shorter than ETH_HLEN with -EINVAL,
and returns -ENOMEM when build_skb() fails. Both paths jump to the err
label without freeing the page that vhost_net_build_xdp() allocated for
the frame. tap_sendmsg() discards the per-buffer return value and always
returns 0, so vhost_tx_batch() takes the success path and never frees
the page; each rejected frame in a batch leaks one page-frag chunk.

Free the page on both error paths, before the skb is built. This is the
tap counterpart of the same leak in tun_xdp_one().

Fixes: 0efac27791ee ("tap: accept an array of XDP buffs through sendmsg()")
Fixes: ed7f2afdd0e0 ("tap: add missing verification for short frame")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260521163230.1478627-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit 3bcf7aec6a9d16438f2cec29f5d7c8d5b8edf9b2)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 5ca6ecf0ce5fbc..c460b1f39136a5 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1177,6 +1177,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	int err, depth;
 
 	if (unlikely(xdp->data_end - xdp->data < ETH_HLEN)) {
+		put_page(virt_to_head_page(xdp->data));
 		err = -EINVAL;
 		goto err;
 	}
@@ -1186,6 +1187,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		err = -ENOMEM;
 		goto err;
 	}
-- 
2.53.0



