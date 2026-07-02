Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BB03ACEED;
	Thu,  2 Jul 2026 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010953; cv=none; b=dtsoDJ5sFH4BJkuX8GqOlMrfTyZLUjt+euo1mlmOnGxEjTTdzKZBYs+/ZC3/OFxqJ7q+JTxkz5omDO26Hb1ICna/2NvLiOP8gL1S1AsOlJ2GoKiN0BcgNf9aDsY74N/AwRldlhTCnN/y6eFR/mmQKTq+VsqiyQo8uXiPSRqNxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010953; c=relaxed/simple;
	bh=9SgdSGSwH2zB1ttoL+MdTBM6vX3lDIYT8w5ZG5Jy5v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgwkCgYe4wfzYvZa3299PaxpjbkSbBr/rjK5n3rFQzG/dTBGNKdKoCjABAnQds1UCrV9mlD4B1fux5VZspFh1PXI1M5u0qTfamu1IpSExegarukym0mUsXyY4CSUWb0aP8o724sV4yGNDbWDWS+FZRR/d+1dFkIFu2YuLlh9Pbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SG8yk46/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SG8yk46/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AC01F000E9;
	Thu,  2 Jul 2026 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010952;
	bh=qYbVotjtBCIu/+LEwcSk25c8AP+hvnKl0x3We03N5BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SG8yk46/AT9MMSeW6l52Yad4oSeRAlACcSNxX4I5L0ta+YPQr9kVpD+2eN9OF4BTE
	 lf9MxAdL6/9USRBodBifv1INqKJBO1Yu+WEx0uGXA5okIVZGyCU8ar28grrjc51Fqj
	 XY7rzSqItTCJszhQdbTdIh+0QnCcavpD4RIzSXJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/175] batman-adv: tp_meter: initialize dec_cwnd explicitly
Date: Thu,  2 Jul 2026 18:19:54 +0200
Message-ID: <20260702155117.736247321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



