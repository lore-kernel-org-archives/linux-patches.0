Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D39F3D8911;
	Mon, 17 Aug 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976401; cv=none; b=R1kVFr0ZI4coSPo2WARzSW9kPSkCyfSeMs3oo2Dqj/Mya03oNTlcNI31sXBU8B2HUtUKZw/Nn5L9NhhGYNpdYSgZtb9zmfsG3pG1zctXdjuAQsKZiK0N6sWFiki3h8VVR70KllJItQJKnsdulFiDxMNzzRYo2o4Ut+WNBGx2EeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976401; c=relaxed/simple;
	bh=zzuEkZJ2aS8099+PUD12ykMEWIwse0JokDcFKh9Mnsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XMEB/zsG7X1ZkoVIndEBRV8l0SKbFj/xlUzE0mVfzuXIK9k9SoXJZzMB5zogDIRsKg+8rS28/5rR/bs56JcwkmUnYRbWt44w3+wCfFe7oSBUCrvrOfGtptyvIjYhtKSA7AHFDLck+VIXahJwxmz7vAb/B3NabBbdMI3r6m8ORWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSKQXfaw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSKQXfaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C091F000E9;
	Mon, 17 Aug 2026 14:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976400;
	bh=KujArSgxZ32ZrTKyP0gHtOlS6LW6RWkqC+cZz2PBejA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSKQXfawXuUHX60KMbMSQzLQ++fPToLS9JP4fhng0CAsU1zLkobAj7H0w8Iw3hsyo
	 ldutNiSD4rWC39QSQpne3gSLIsGRFizGY0WPS4K2xD9dvO0UD5njarsrydDEr0F43+
	 d444ZhVZzmebOH/Sj7huccHfU08M5Zmj3Nax/qBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/389] net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter
Date: Mon, 17 Aug 2026 15:32:42 +0200
Message-ID: <20260817132551.526351791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit 2a33516f9ef59ad11844d4fc152f889449b5daf3 ]

The sch_cake ACK filter parses packets to find the TCP header and filter
duplicated ACKs if the flow is backlogged. The parsing code contains a
WARN_ON(1) which can be triggered by a malformed IP header in certain
cases. Depending on the system configuration, this leads either to
either spamming dmesg with warnings, or a panic if panic_on_warn is set.

The code already correctly skips the offending packet in the branch that
triggers the warning, so the WARN_ON itself doesn't really serve any
purpose. So just drop it altogether to avoid the inconvenient side
effects.

Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
Reported-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260729191417.45665-1-toke@toke.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 45b175e53aac0..8e3010a183822 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1281,7 +1281,6 @@ static struct sk_buff *cake_ack_filter(struct cake_sched_data *q,
 
 			seglen = ntohs(ipv6h_check->payload_len);
 		} else {
-			WARN_ON(1);  /* shouldn't happen */
 			continue;
 		}
 
-- 
2.53.0



