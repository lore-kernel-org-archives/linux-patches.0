Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831153A5E89;
	Tue, 16 Jun 2026 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635553; cv=none; b=XZtwMQvhhjttYegzjMG8GTDQIp/EF0EzcIe3h1p+cfqTAeQ0pK8U723ZSc5xsoOrWo04RISx/Vd++oBGuBJtsJZYv+yaC5218LCkarnoXQ4RSwHRwj+wTLZ3UNRPZ3L9veht+hSQvl9iZXTnDMsY2+iMq1N4QoreGZCaUDuSGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635553; c=relaxed/simple;
	bh=wU26ltw0kgBVyFCM0L5fEmOU/kYR+G0+XibBAFQC/bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i47Myn3Ozyb+G8XGwoeRyWbBYEfGvypX3Rf77d8gZCjbj8Wurw1AUSSZt10qFYwW8igOQxw32vv/UzkfuFmI8z8ajVHwPWwHkYcRpJw0frrPkpaqScr6ahgZGKJ3GY0dfFZyuXHagBPF4g0UisH+GhXB8R+7xuC1nh1ta8yGQx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z89Q3L4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z89Q3L4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375C01F000E9;
	Tue, 16 Jun 2026 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635552;
	bh=KZBDoCSeoFtylLGMxVd1OajvgatjwWtOjz5dXiABeO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z89Q3L4omdeAFlZ8PwtfUxsia4l6Jn0iRFSEIw2L9NPN3kd3WhmqL9Al7nFjOBi5s
	 eKogTxJko+qWRuqO+bAYKB0ujSwaP1e94JN4jvVz0Q1orE9Z+3M9q3+54sPtEX/x6V
	 h15aP27tUPZ41YgoGt6tX2GcnPiav5IAGjADak0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 070/342] macsec: fix replay protection at XPN lower-PN wrap
Date: Tue, 16 Jun 2026 20:26:06 +0530
Message-ID: <20260616145051.506146929@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit e68842b3356471ba56c882209f324613dac47f64 upstream.

In macsec_post_decrypt(), when pn is U32_MAX, pn + 1 overflows u32 to 0
and the first branch never fires. If next_pn_halves.lower is also in the
upper half, pn_same_half(pn, lower) is true and the XPN else-if does not
fire either, leaving next_pn_halves unchanged. An attacker that captures
the legitimate frame carrying pn == 0xFFFFFFFF on an XPN association
can then replay it indefinitely, since lowest_pn never rises above
the captured pn and macsec_decrypt() reconstructs the same IV.

Extend the XPN else-if to also fire when pn + 1 wraps to 0, so receipt
of pn == U32_MAX advances next_pn_halves to (upper + 1, 0).

Fixes: a21ecf0e0338 ("macsec: Support XPN frame handling - IEEE 802.1AEbw")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB78813FD49E58F253B989F197AF012@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -828,7 +828,8 @@ static bool macsec_post_decrypt(struct s
 		if (pn + 1 > rx_sa->next_pn_halves.lower) {
 			rx_sa->next_pn_halves.lower = pn + 1;
 		} else if (secy->xpn &&
-			   !pn_same_half(pn, rx_sa->next_pn_halves.lower)) {
+			   (pn + 1 == 0 ||
+			    !pn_same_half(pn, rx_sa->next_pn_halves.lower))) {
 			rx_sa->next_pn_halves.upper++;
 			rx_sa->next_pn_halves.lower = pn + 1;
 		}


