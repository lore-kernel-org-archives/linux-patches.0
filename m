Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2470B49C4CC;
	Tue, 13 Oct 2026 12:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892944; cv=none; b=EIKN8Fqudc6KpG57TmYbHuXqcNAGq+KIzmG4gkDMBv1wuifuA84xISoH+VpwAV8OcTOfYitvPeHyzDQACFB3i5Ks/4lJnJj3KTUk42x8BM7/gupJoO16OUOYdzJARRPnA/O9q4jsLErKOMot68j8NR6GWDRh1KhGeJzYAOSDYCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892944; c=relaxed/simple;
	bh=06ncSP1IqSTjBfK6GMRzbPlxul2n4Jn5pdJ4uN8Qr1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFmv6x0ma+R/uPkVZ8dxm2ZnFm447ElFscpG7yBQ4MhIOQpnQs7GqQbiban0YbC8M/ylAkRaAzLJJOR8yzyvACI3ALVOsgC5KkET+FGNo3RAgLJwzMZnNp8FFDNxlNCZRTiFOm6eDVK1Xve+jLKwRXsj04zdCahWNDnPhnYrTrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaFaMUG3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaFaMUG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7189F1F000FF;
	Tue, 13 Oct 2026 12:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892943;
	bh=yN90vCKvD7ixYroKTryTybOmIYdhEMeQpqCF/9uzPVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaFaMUG39jOTeDwA9xocP0MjMMONKdIs7waSXhp3zjngTF+8IOMbOpxjZ2KIihEl0
	 Ccgsr7ICgUykhiyW6jko0EjENQxtJHiAeTbPNIlgWq3TeRbZ8Iktm0b5hw11jz/7G6
	 ZNC04/x1Sjo3PnCTA4OMO1gL6F2KPzICw/Tz4LBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Hostetler <thostet@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 058/621] gve: fix XSK buffer leak when rings are stopped
Date: Tue, 13 Oct 2026 13:30:53 +0200
Message-ID: <20261013112922.240216859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Joshua Washington <joshwash@google.com>

commit 73670ddb91a4d22e1deb3efd962242de1ec48e90 upstream.

GVE does not free XSK buffers when resetting ring state as a part of
stopping queues. This causes all XSK buffers which are posted to the
NIC to be leaked.

Free XSK buffers attached to an allocated buf_state when stopping rings.

This issue was hit in production.

Fixes: c1fffc5d66a7 ("gve: implement DQO RX datapath and control path for AF_XDP zero-copy")
Cc: stable@vger.kernel.org
Reviewed-by: Tim Hostetler <thostet@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260930214735.3288780-2-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 5cf242b28557..a2c4a08ce68d 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -113,6 +113,12 @@ static void gve_rx_reset_ring_dqo(struct gve_priv *priv, int idx)
 				gve_free_to_page_pool(rx, bs, false);
 			else
 				gve_free_qpl_page_dqo(bs);
+
+			if (gve_buf_state_is_allocated(rx, bs) &&
+			    bs->xsk_buff) {
+				xsk_buff_free(bs->xsk_buff);
+				bs->xsk_buff = NULL;
+			}
 		}
 	}
 
-- 
2.56.0



