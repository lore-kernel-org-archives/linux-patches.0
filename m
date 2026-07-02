Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5FC39B979;
	Thu,  2 Jul 2026 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009641; cv=none; b=iT9o+dtQeKXZnB+yEj8WnQEG4pUiVCBTNeoK96as8FlGxval5+uoPhgDRfcPpzF69StTKDoWbr0MYXR4MnkGO/CT+xIauAfRMNmL4dXqwO8uocgWF4wVQsXfim49wlsCXSvJ8ttYSDEgAq2ACQnceQgYTS5QsdzjPF9QHIpje1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009641; c=relaxed/simple;
	bh=gXFd/3ac2OOUc8UWMKW/XAMAKIMWzgV/WapfFYhBml8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nznGykeiZiZLmN/huvbhOGhwIXdxR4RESd2uJ/lmFzdr6SBTtFWxQfSjsyeFIKo3LDcrsN6lFCUAWqoZMtr//YPEBXOdlGC1CZ4NtFYBVjA6yTjwAEyGGsBQuoxKDOCs48fm/20SUVn5Le0edX03JTFm7YY7+rs3D2EYq7y42CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YstgVPhF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YstgVPhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682C31F00A3A;
	Thu,  2 Jul 2026 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009638;
	bh=HdwpBGIV7oocolMPOCvwpTxbuOXE/EVet3+ZRJgngms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YstgVPhFtgbOQCHvNoelefkLr7Shrcy2AAEYRS/ULI0SIrjEkpVks3Z2hX1LIejgg
	 wV77wFs1+vuQqTn0xB2HkEUybwP4KlWvMnJilJF0DsX/Rh5vSBZKpx3OKRT2cSMM11
	 iPxOhxRGEssQGwBpMtmtWesv1utYsmsX2V9AwpeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/95] batman-adv: tp_meter: initialize dec_cwnd explicitly
Date: Thu,  2 Jul 2026 18:19:33 +0200
Message-ID: <20260702155109.842254079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2b68eacd7bf51d..f7b0ce3f8e2aef 100644
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



