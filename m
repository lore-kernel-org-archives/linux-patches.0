Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C888259C98;
	Thu, 17 Apr 2025 18:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914623; cv=none; b=pCJWj88mbNwi3KfKjjUjmiEWnYCjUpc7RzeLpEhx9TVtrWS+5nlLlY2fAH5qbWl0trrm5KMBvL9z5Rb1wyE4iXxl6SgMP9OU73lWQTedy6lvOCWhy7Ni/b3IM3xdSCeXWineEyVXmrQvYT0if3piGd1VYTP++NCZZ9a848hFdAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914623; c=relaxed/simple;
	bh=Qh+jjpDVNXDjBiziJAu+HW2HBVNbHJg27LUscp3R1Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYvNc1iiisWE5Suo+76OWjtLYFwJwJMKuFsI+ORAEO3CX0fWsnAQZZDuC5sMT+MehH6jOdmkH5F3ZH+fQRHp5MRYXUyZqUXY8EPqhaR2wp61h11Lw6wf0p634tvgni385eH3dMKOYtIGKD8XeRjZ0NFvyUvIMSc1Xe9pj7EuZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZoxKlr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZoxKlr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996F4C4CEE4;
	Thu, 17 Apr 2025 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914623;
	bh=Qh+jjpDVNXDjBiziJAu+HW2HBVNbHJg27LUscp3R1Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZoxKlr1HxCEU2928qp33YD5mU/LxtTbHTYJn1/Vn8xn+C82mAP4RQlxb/R4he4J8
	 A4jQ2IrmBD3TSFjuitu/vDxlrdxZNZCLIZ8j0cM3E5g3SUCp2+fiFUS6WtPRehejUh
	 Y5U5onknp4L7K9GDSn67quRL8KuhuNixRhlD+c+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 246/414] gve: unlink old napi only if page pool exists
Date: Thu, 17 Apr 2025 19:50:04 +0200
Message-ID: <20250417175121.318699462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshitha Ramamurthy <hramamurthy@google.com>

commit 81273eb87af86d4a43244b553762348e364b2df7 upstream.

Commit de70981f295e ("gve: unlink old napi when stopping a queue using
queue API") unlinks the old napi when stopping a queue. But this breaks
QPL mode of the driver which does not use page pool. Fix this by checking
that there's a page pool associated with the ring.

Cc: stable@vger.kernel.org
Fixes: de70981f295e ("gve: unlink old napi when stopping a queue using queue API")
Reviewed-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250317214141.286854-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index f0674a443567..b5be2c18858a 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -114,7 +114,8 @@ void gve_rx_stop_ring_dqo(struct gve_priv *priv, int idx)
 	if (!gve_rx_was_added_to_block(priv, idx))
 		return;
 
-	page_pool_disable_direct_recycling(rx->dqo.page_pool);
+	if (rx->dqo.page_pool)
+		page_pool_disable_direct_recycling(rx->dqo.page_pool);
 	gve_remove_napi(priv, ntfy_idx);
 	gve_rx_remove_from_block(priv, idx);
 	gve_rx_reset_ring_dqo(priv, idx);
-- 
2.49.0



