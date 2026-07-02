Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4732126F46F;
	Thu,  2 Jul 2026 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011576; cv=none; b=DQgB/8mJXdWKvxbZVEdKoi3aeAUobEd1BodGDx4sPa1Lc2wH63pZ1xdN4vU5lzCWegu+4g7R/Ikpq+HL1K55AfYDposi+lvOJIKXAUNGCv1lB2XUwR6HbHCW7/Dgj6eiYWA4vzh3e+1TUwZhlAOaZnuFR1xQHBWkvkY2BvSLByU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011576; c=relaxed/simple;
	bh=HSAZCVd9KVL3hoX1VbKMd46pNF6VY9qUCBLX/3ZRE1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPxa3h1FZeWzUK7QN/VqjjqDfBvVX6Bqx1vmSh0dC1Bv0RCRgyMMV3XbJXAh8UvmuE6zxBsnnlGlILITCjAcw9pkS0kdjuZqYIZg5lRt2vxnS36dB3H7s3NvRqmifgwTTsAPf8wj/Tipz56rN6PEUB3nD05b2LaJeH0V9mqdeHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y0DAOZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y0DAOZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0B41F00A3A;
	Thu,  2 Jul 2026 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011575;
	bh=ZQKuG6OjnQZYwU6a6TXPpVS+XcboxI1+64oWsoLe2n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Y0DAOZmgQ4/+8efz2fGMf8gsJDMSmBtmGU+jO669PSWmHXN2Ugk3MByTjp7Vj9GX
	 +sjlITBk33SjlvTs4TD9YXHixeWdcc2kyNlJPFcueTP5gzyuvzme0UankxM7LatdYI
	 o43SFK9sPLlfVHL7UpP6ok9jho/xP8Ukp5dAAPsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 008/120] batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection
Date: Thu,  2 Jul 2026 18:20:04 +0200
Message-ID: <20260702155113.136361055@linuxfoundation.org>
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

commit f54c85ed42a1b27a516cf2a4728f5a612b799e07 upstream.

The recover variable and the last_sent sequence number are initialized on
purpose as a really high value which will wrap-around after the first 2000
bytes. The fast recovery precondition must therefore not use simple integer
comparisons but use helpers which are aware of the sequence number
wrap-arounds.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 77bc69573a5624..0801dcf93540ac 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (tp_vars->recover >= recv_ack)
+		if (!batadv_seq_before(tp_vars->recover, recv_ack))
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



