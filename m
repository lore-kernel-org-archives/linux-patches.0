Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29C11C695;
	Thu,  2 Jul 2026 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011289; cv=none; b=CQYQH1F7FTQ/rSDgBryCVPKm3W4RYmz49NviaXpnFnhjmU9vVFQUJPz9gxoNcJWD7Q9d9aoskht9UOQCABlGQ3vFveknPkfNMQr7t6HSYn2JOpvoXMIwGUO7QPF1p+5gZoqrQ0o9Th773f8IpZzb0qbD9IdDDMkZoRH28qns3B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011289; c=relaxed/simple;
	bh=xkCYcodTQhvhhXGgwB02/DH9oh5ouwb0wg4xdhaEK+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMuQ4RaBh8l/Xd7OsUEd/tTk4XDr+onzROM+VM31RqPi2bBiWwTPOeyVDEriyzGJzqyI+iaXUtNemGYywJ0MeP1RAJBfKBsHmeHAOnqCWCCOM279cGYcBqPCt4Iw2ICdS7fclTD36vteaV1d61DP7f8OUhM34c6Gt+z/xxDCooY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuXeXWo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuXeXWo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557B01F00A3A;
	Thu,  2 Jul 2026 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011288;
	bh=IuOUzgzScvvdwfXd7daJMkiVWTQHVeGB5d6oMF2SZzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuXeXWo27MjvdJ1giZn0+TQPvMBgONLNZaKxsiC3+qu0Dp8TlWzZxyNgTPPpDSxGW
	 q3aEZj19s+UVQ43WIyXBMfcT6GsLq7sFlsyXGfv13LdmKwcqZEUAadW7mXW6+mydnl
	 PP1B8puzdwCCH1PLGwBtcU4Dt4IKYAl4fh5VWz5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/108] batman-adv: tp_meter: initialize dec_cwnd explicitly
Date: Thu,  2 Jul 2026 18:20:05 +0200
Message-ID: <20260702155112.285480420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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
index fe9a447643074a..473641d32dc683 100644
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



