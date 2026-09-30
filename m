Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D98B4CC63A;
	Wed, 30 Sep 2026 18:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793244; cv=none; b=ipjikcHJG8qOs2LoC97UM6WPcnE+Tc0wqrdS1nWciA9VJw6hzbqbCgrkmao2n11P0X4mmnQV2VyD9PTG+kVX1Tw3JuTSGKHbQY1mTZMEtkZNG67UTLyp5sLlebeOap7Xh5f6ar00HgksxokoqdPjsrV8dblKrtG6qJTsJpDJwtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793244; c=relaxed/simple;
	bh=vFIYRU2c+R0Ezv4s77YibEuwxY2BmVR68fQt6y+dN+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM89lOb484LJWl1EgIvNPLdhZXB+Mg3bAY9U0HA4TZb/oHDaeeBkJKclNS8WF92l3YHUAZSjpSqiai05K2a6HNQ+zm/+eNunn2VrKy2mQc7mZ86pAqHQUfHWvFd5/D9z3l/Dc548604pusdOeAQIOZw4L8swmIcF92hZrRtt6xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNHFa1je; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNHFa1je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39B61F000FF;
	Wed, 30 Sep 2026 18:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793243;
	bh=cMKtxyT/vOnlHzKZ9TFJcoJW+/BKgY/2DzryYTzowfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNHFa1jexdtf5qrIb3niW8g74UTrejRLuXln82r4clBCbo92CryX/BAqklcXusfvW
	 2Q/GsgceRMtOAlEkp8E2nDnH1nk/dlmEpB4iS+hCkV0Y8puflmlMJAypqYmm0U2/O1
	 +GLwQR/WVd1a3/oMgGEYNvyxxWOtHGxtJAv6eUI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Joshua Washington <joshwash@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/395] gve: Enable hw-gro by default if device supported
Date: Wed, 30 Sep 2026 17:27:29 +0200
Message-ID: <20260930152344.706683000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit 3c398063ef01b02d7efd31662154fe70fd28ace6 ]

Change the driver's default behavior to enable hw-gro whenever supported
for device.

Performance observations:
- We observed ~10% improvement in RX single stream throughput across
  various MTU sizes.
- No change in TCP_RR/TCP_CRR latencies

Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260303195549.2679070-5-joshwash@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3b430ea62340 ("gve: fix TX drop when GSO MSS is too small for hw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 7f8212c20ed2d..926833b2424fa 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -1124,8 +1124,10 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	gve_set_default_rss_sizes(priv);
 
 	/* DQO supports HW-GRO. */
-	if (!gve_is_gqi(priv))
+	if (gve_is_dqo(priv)) {
 		priv->dev->hw_features |= NETIF_F_GRO_HW;
+		priv->dev->features |= NETIF_F_GRO_HW;
+	}
 
 	priv->max_registered_pages =
 				be64_to_cpu(descriptor->max_registered_pages);
-- 
2.53.0



