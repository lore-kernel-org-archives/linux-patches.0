Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7E9212564;
	Sun,  7 Jun 2026 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828771; cv=none; b=IZE8iUfi7aLv0AT4cROFJ1k8Y+TzgrsahNZZTM0E05MwWWp91fKeS122xXDPcXT3XX0Z9oVXDhjw8WO16bzeRvwag5Sxv3UQ3Ls6d5AyGQa5NKm82YG46/UGJJImlVo9R3prIRwATAxe1u9oDaQlWcwIidxVcgd8mYf5d2K5LzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828771; c=relaxed/simple;
	bh=4OXHpfFKsp+Md0/xYHSkTIBOq2nMGxYyV0oJQ5WIZcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpqSDKJabePEwi20XU923esbOj0oVvNTo04a11GCooq/O7p2g51JmQwwKkMXpmKio05vCEI6wfvzzwdOKEDL4Slgj+WETXBwiHJ4nrMyN66DaCVbeqQKXWIcfZb/Pt4124TZ+umVERR0UwtQ1LuEBvEd8kQ0d5ew8Mg9Nx8g/8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4XkPpdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4XkPpdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C781F00893;
	Sun,  7 Jun 2026 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828770;
	bh=nMFZqEID5k4gjNVJI5c5ZRfaULSEJZO4j3I+cYI5Chc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4XkPpdZ2bmNmFJdQzScin2F7zcWAf/CFTMkD9Asob6uytViqeqhcLZeK9dwANWqS
	 7zdwTDxj3uEkGUZL/fDzQd5QIL627zZxM2oa5O0JxeMaBQBxsrQBKXi59qI2MB8pa7
	 HtTlMFd9DcKUWaofgSSAvOgLUTkR7v2FXU4QiRqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 210/332] macsec: fix replay protection at XPN lower-PN wrap
Date: Sun,  7 Jun 2026 11:59:39 +0200
Message-ID: <20260607095735.779924163@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -804,7 +804,8 @@ static bool macsec_post_decrypt(struct s
 		if (pn + 1 > rx_sa->next_pn_halves.lower) {
 			rx_sa->next_pn_halves.lower = pn + 1;
 		} else if (secy->xpn &&
-			   !pn_same_half(pn, rx_sa->next_pn_halves.lower)) {
+			   (pn + 1 == 0 ||
+			    !pn_same_half(pn, rx_sa->next_pn_halves.lower))) {
 			rx_sa->next_pn_halves.upper++;
 			rx_sa->next_pn_halves.lower = pn + 1;
 		}


