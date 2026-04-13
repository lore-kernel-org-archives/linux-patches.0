Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97E126CE32;
	Mon, 13 Apr 2026 16:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098238; cv=none; b=YWdWGQS0UQRcS3xlZB7fXQI9MlftkJUrp5XD9k0LTgLyjqmedhDoh1IBhwx+i6yM0v0jBN2lLUzfhKKKOlnrEBlKXLGw9M29BIdiI3dy4kdkFCM/4MKH3jG9QUJdP4GM0IRFNZZv3DIFEEx2Kv59nQ4zYnDof0BwfVUoaANZxfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098238; c=relaxed/simple;
	bh=sD2PdL4Bcg4RqeaQHINvNmA6jpPL8g+c9kEYR5i3o1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EG1QRu50cj1zuUy05ZACKIFEhWxRIiSO7tM6YNYy00/5zO6nVNqui+dbZBw0yeU6UBIXxliqBmD3d1F3clhKA3VwxIbU4tP5nR3G41tAw0nzSRT8icvK0G95Few9czqke9mbwycFFX8ElJScJsO8I5N2xizjwi/qiW0RmZpaacI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4Xur6/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4Xur6/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE5FC2BCAF;
	Mon, 13 Apr 2026 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098238;
	bh=sD2PdL4Bcg4RqeaQHINvNmA6jpPL8g+c9kEYR5i3o1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4Xur6/QsaRrhUDeQzJ0mkWS8TlwrbAw3dJfiwGFW0pAl5nEJxwgPPvjforsVrola
	 QWVUzbX2T0oTO0urVM+P6WA8k4T7OraUarFsR+F6EEg0uug54U16H2X9jmG1ZDbi7H
	 ZEp7dNPSm0p3/yWArQjW39cyrLSN/Dj3pA77wiZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 448/570] Bluetooth: SMP: derive legacy responder STK authentication from MITM state
Date: Mon, 13 Apr 2026 17:59:39 +0200
Message-ID: <20260413155847.251502526@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -1017,10 +1017,7 @@ static u8 smp_random(struct smp_chan *sm
 
 		smp_s1(smp->tk, smp->prnd, smp->rrnd, stk);
 
-		if (hcon->pending_sec_level == BT_SECURITY_HIGH)
-			auth = 1;
-		else
-			auth = 0;
+		auth = test_bit(SMP_FLAG_MITM_AUTH, &smp->flags) ? 1 : 0;
 
 		/* Even though there's no _RESPONDER suffix this is the
 		 * responder STK we're adding for later lookup (the initiator


