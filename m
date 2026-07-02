Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E2B22D7B9;
	Thu,  2 Jul 2026 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011182; cv=none; b=lyTzbi7nZTGBkIox88n1m2+t7BEzJ/ztQCTmDQn89te9qF+up5dCX08TJnjlbxueen0/FZ0kwRS6lSAYHx2o3T+1xv6rEF0RCZsGTdnsKPQ16qhNCtINGdfIwMNiS9LmJ1Jh0s+W086sqH6kktoInw0NAPbtbv0pVRxw+ovbxQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011182; c=relaxed/simple;
	bh=zgGTI7UZ3wSq9V40yD7nN0ctMLO7HBqcQhqonrlARh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCbEQKkcbGdt12hhTHKwayT+mfKqk5O1C81qnZOek7N0wA9OCwmui1NbsniDYVrUNUF61eSytPoEjBAWRHFXlXNDwJWNqlOIBIYGMDX41OCyl5rn1a4Gjskv4sFnMHVRFhQvCYvqJgwwoHAWjjj2ejobILJmSRRRiQKfEfXunEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZ6IGtR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZ6IGtR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1181F00A3A;
	Thu,  2 Jul 2026 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011181;
	bh=XlZyYZ2NcRjlxRyAj0242JjbqEwPSYfAC851YLPmvfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZ6IGtR/aZWsAKROYQwTPLgWTOVl5CA+ClHanCj18ZpmLicXOpKIH8bmjkC3s2Y/k
	 8PjNzTc0mA+OCsrgcRdALfPNyBVwcfUfJMk0+NUgxCAsWgD1himdsenmPxFagMT0xg
	 yzzsuarJAW4xYinZJj8gGCfxHHddUS4Q2F1lAUWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/108] batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection
Date: Thu,  2 Jul 2026 18:20:09 +0200
Message-ID: <20260702155112.366659864@linuxfoundation.org>
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
index a85622267ba655..0ebfc4462b8f17 100644
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



