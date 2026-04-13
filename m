Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946FA31F9BC;
	Mon, 13 Apr 2026 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099514; cv=none; b=ug+Ofbi9rtZcYmTD3gRJ9btXK09SWH/v0GpptGVPWea02J9P5sWkZV5lIEZW0PPZ3QsvWN3ZUeajNHONVtEPR7qeFaQhI9afbq8s0a0vJFe+gjOA7akT8jmyiSGDIhui8JP8HG6d1jpxPnT1ZWFB88uSGJ+I/DrNmqEBQlsWlmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099514; c=relaxed/simple;
	bh=ChoRTLUYteOC1Lv8sxh3xBN5HTOR5FL5BVNB48Z5QFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQQjooWMhVV+sUSmX/wtXgKv0rgNdkRaUj9236XqOJPSUWd4Z8b7BcrMtaxytTN9rZwH7qvp86VPecsl4k3/U2w7ECNT/t3mXNVXl9dtf4P0CMu8IM9K6ipPXPQRtHp/MltqeUyH/WoWbk4HTBbHAsYbECTllvg7jcG7ReJ1WGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTYuPxWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTYuPxWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291EBC2BCAF;
	Mon, 13 Apr 2026 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099514;
	bh=ChoRTLUYteOC1Lv8sxh3xBN5HTOR5FL5BVNB48Z5QFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTYuPxWJX0QqkBgwEr69wWeA/A9ybfTQquLeSCbNnpE8sv/T/tJerGeorxV15wcXy
	 hBfQI7mn7k7WJroz4Qm+8rJq8xN2+xPWg2j43GcA0b3tTRuFAvwYtZV2OdrDWVPHAh
	 nIGwbGQCisHa0uX5nJMrk1iE3V5EZQk96Izle0sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 369/491] Bluetooth: SMP: derive legacy responder STK authentication from MITM state
Date: Mon, 13 Apr 2026 18:00:14 +0200
Message-ID: <20260413155832.848280354@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Oleh Konko <security@1seal.org>

commit 20756fec2f0108cb88e815941f1ffff88dc286fe upstream.

The legacy responder path in smp_random() currently labels the stored
STK as authenticated whenever pending_sec_level is BT_SECURITY_HIGH.
That reflects what the local service requested, not what the pairing
flow actually achieved.

For Just Works/Confirm legacy pairing, SMP_FLAG_MITM_AUTH stays clear
and the resulting STK should remain unauthenticated even if the local
side requested HIGH security. Use the established MITM state when
storing the responder STK so the key metadata matches the pairing result.

This also keeps the legacy path aligned with the Secure Connections code,
which already treats JUST_WORKS/JUST_CFM as unauthenticated.

Fixes: fff3490f4781 ("Bluetooth: Fix setting correct authentication information for SMP STK")
Cc: stable@vger.kernel.org
Signed-off-by: Oleh Konko <security@1seal.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/smp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1018,10 +1018,7 @@ static u8 smp_random(struct smp_chan *sm
 
 		smp_s1(smp->tk, smp->prnd, smp->rrnd, stk);
 
-		if (hcon->pending_sec_level == BT_SECURITY_HIGH)
-			auth = 1;
-		else
-			auth = 0;
+		auth = test_bit(SMP_FLAG_MITM_AUTH, &smp->flags) ? 1 : 0;
 
 		/* Even though there's no _RESPONDER suffix this is the
 		 * responder STK we're adding for later lookup (the initiator


