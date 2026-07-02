Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21D318EDC;
	Thu,  2 Jul 2026 16:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009952; cv=none; b=sKosJVt93DF0unV1cRO89NtMAtlglUCPLq301udloD9HCPX/2rFv23CafxvPAsPn7TfPOHtqpnW7vvIzYtSQP6JqUuhn5SgicNvPeoiydL0BSrFTA24lW6JSXWQwCmx9c4MoiYJ5wZM8hUMg/A/RKgGbi8iEtH+yOHUxmtnvS3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009952; c=relaxed/simple;
	bh=dhmhLuuHbVO8CLt8tG5cXtsTGVHksZ3osyC0rBtXd8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utc7oZMf09cktBYbwTH8vmMwdiaA8Sy6G9yuiL5RRm/wOkawLSBGnUGTLEKoR5wMLV2mWJDaPwUjFVPqZJWp96ld7l947W8zl6hWCpU2MjhVbAlxajvWMTuhrHpnExWf9rIHhd66qmlHYDKXQDv4Rk5dV1+LjRsRESgnoU/+Pso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6WsiVEn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6WsiVEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12D71F000E9;
	Thu,  2 Jul 2026 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009951;
	bh=N4JAtruhUBuTNpHNfpmZCBUxb8mmtDBK4A9LbTFAc98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6WsiVEnagV0ggSmxo85Y/z42vzSuFrB4LN8K+0hjnNxctxX3Z/mJLiwvzocO3sxI
	 Cxs24YiiIj+kDIo8sqMz97t6mbM42aFb51KMmeEMhbrRtzRJP2hIqU5e56+0mlV4VX
	 r6lXLpLc9dz1wiW8IVCxZiDKEJe83Te6OcNYHM6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/129] batman-adv: tp_meter: initialize dec_cwnd explicitly
Date: Thu,  2 Jul 2026 18:19:31 +0200
Message-ID: <20260702155113.224997418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit febfb1b86224489535312296ecfa3d4bf467f339 upstream.

When batadv_tp_update_cwnd() is called, dec_cwnd is increased. But dec_cwnd
is only initialixed (to 0) when a duplicate Ack was received or when cwnd
is below the ss_threshold.

Just initialize the cwnd during the initialization to avoid any potential
access of uninitialized data.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 750e5e9d3dc9d6..f6ccb639744a2a 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1055,6 +1055,8 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	 * soft_interface, hence its MTU
 	 */
 	tp_vars->cwnd = BATADV_TP_PLEN * 3;
+	tp_vars->dec_cwnd = 0;
+
 	/* at the beginning initialise the SS threshold to the biggest possible
 	 * window size, hence the AWND size
 	 */
-- 
2.53.0



