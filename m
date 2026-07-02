Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985E51C695;
	Thu,  2 Jul 2026 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011547; cv=none; b=D+H+y73C7U6E1kq3h7oU/UP/xqZU+Gan0PzMrbINFCeqq2RnS9+Holi8XxGW/Noqw24EgABDzdSzcgaAgDV6ZS9N+S7ylaJvy3ra3bw5ILEm7742MdXf3Up4gIayatMmHplBPuwV2Y+mVNwBGyG6sFNjRIOW2K5wIzZ3scdYbag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011547; c=relaxed/simple;
	bh=v4mP3EtgH68GXNvoHiPslAv6VN0T0bZ6kw3//VTnvmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RErtJXQH3QcnMhCVze5YnV7OhIiAiywHQL1N0xI8IqWdURNUmYlQ7M2QXfzSU62Jb9HokWoHEsDw1a93f8i1J87Ow/cDClVNb8ZAyUkjEEkLFKZ8BSQz8jfVnanbH3yofnGpo5Vq1wnRQ6jEgRHbsa0uHIC1SiRpGQoh5yjH6SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQ/nSSjH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQ/nSSjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097791F00A3D;
	Thu,  2 Jul 2026 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011546;
	bh=3Dmk2R5hyo4tuT5v9gR0IVnaiZ+wbMMiOnBkHTIDMeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQ/nSSjHCCB/O2I5yPwJJr9ujt2+Cy9Qcxt8eFFUYvm32f27Z54SiaPA+alm/DR7k
	 +7JkpcZbzdn8BsLeFpy/N4EmLg2SrzicsgokWwbKcp8Wgd7ku1C8FqCaMZb6wHFTh1
	 s4J1m3hX+GmWrseB0FPz0WlocaXWAZz078GwC+vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 004/120] batman-adv: tp_meter: initialize dec_cwnd explicitly
Date: Thu,  2 Jul 2026 18:20:00 +0200
Message-ID: <20260702155113.057308022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0325b951ff8a8e..2ff7aa5ed19fb3 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1055,6 +1055,8 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	 * mesh_interface, hence its MTU
 	 */
 	tp_vars->cwnd = BATADV_TP_PLEN * 3;
+	tp_vars->dec_cwnd = 0;
+
 	/* at the beginning initialise the SS threshold to the biggest possible
 	 * window size, hence the AWND size
 	 */
-- 
2.53.0



