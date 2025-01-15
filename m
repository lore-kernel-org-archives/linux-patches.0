Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B262822FDF1;
	Wed, 15 Jan 2025 10:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937951; cv=none; b=fdyNE4OzbwTVp85m+IrNd9U0/9Lls0JpdZMqeHk3os/ooSo+iWUa2kVH3Mfo8ZZEoBfZDEHty/7+Djtx9/QzN7y0kqdf7u3UciI+MgpEPTFms27vjAY+jM3EYSSVnPwxrJnLZHJ4FZ3Xf0q0/J/X8SBOVGoYZAf3ip9E1WsPBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937951; c=relaxed/simple;
	bh=h88CLlunzx5YLP3myuI1OVXBSpfl89WiYzL+vHEZtMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axfjKtEcewg6QEFPC8mengxIWRiIzLXwqgQ0koqgQUhd7l/hCvfwJIv78R3O+lJ/eNNx5XHdpb+4BUZYIZSqRVYhCSUWqSSzaOePAclIXCpvmsliw8EYUtZW9uPuvWgTipSWMWIYfvQlbTnAw7GsZdrQcxPR5F62fh8JtiYOOwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnygETxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnygETxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB5EC4CEDF;
	Wed, 15 Jan 2025 10:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937951;
	bh=h88CLlunzx5YLP3myuI1OVXBSpfl89WiYzL+vHEZtMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnygETxBVGhNoOaaCfJHsh7JbGy4lZU/pnp7Xx++eQJOtuW/S68eFZIin0YJ7+UI7
	 V7EQ2RcBoKfMqTtK2wDXxnxPts1ojjgqTDY+QQIdi9gMEOkKGx0Xj5qUNUvnayuQRo
	 GmYInDHnX1NGeH1JN4ZlXopF0+yzj1cnXjArsqqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeroen de Borst <jeroendb@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/189] eth: gve: use appropriate helper to set xdp_features
Date: Wed, 15 Jan 2025 11:35:36 +0100
Message-ID: <20250115103607.959361796@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit db78475ba0d3c66d430f7ded2388cc041078a542 ]

Commit f85949f98206 ("xdp: add xdp_set_features_flag utility routine")
added routines to inform the core about XDP flag changes.
GVE support was added around the same time and missed using them.

GVE only changes the flags on error recover or resume.
Presumably the flags may change during resume if VM migrated.
User would not get the notification and upper devices would
not get a chance to recalculate their flags.

Fixes: 75eaae158b1b ("gve: Add XDP DROP and TX support for GQI-QPL format")
Reviewed-By: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250106180210.1861784-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index d404819ebc9b..f985a3cf2b11 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2224,14 +2224,18 @@ static void gve_service_task(struct work_struct *work)
 
 static void gve_set_netdev_xdp_features(struct gve_priv *priv)
 {
+	xdp_features_t xdp_features;
+
 	if (priv->queue_format == GVE_GQI_QPL_FORMAT) {
-		priv->dev->xdp_features = NETDEV_XDP_ACT_BASIC;
-		priv->dev->xdp_features |= NETDEV_XDP_ACT_REDIRECT;
-		priv->dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
-		priv->dev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
+		xdp_features = NETDEV_XDP_ACT_BASIC;
+		xdp_features |= NETDEV_XDP_ACT_REDIRECT;
+		xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
+		xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
 	} else {
-		priv->dev->xdp_features = 0;
+		xdp_features = 0;
 	}
+
+	xdp_set_features_flag(priv->dev, xdp_features);
 }
 
 static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
-- 
2.39.5



