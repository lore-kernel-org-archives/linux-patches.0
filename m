Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEA536166F;
	Wed,  8 Apr 2026 18:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673210; cv=none; b=tb7WGLuM3CxHsA/lvKMy6aiddFrP+DMtEsdLa2w4KS8m458NgwYN2x6oFLmPMLO85t8ve1IQFeeQcC7o1U09bZQ+rfOIQUBdoSXKSkcGtn2fu1HEgCWKtOXuPT39mt7otcpwvES2aPfy4wlw96AG8lRvZtXgIkUQ4nPaEtGt76k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673210; c=relaxed/simple;
	bh=BLP0VtXBMCMYlOmYKelOinKc+w2bJVAi9876VtAqUQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPN0/v92c9bB1j0cXkTAsZE/teVsowMP/Ppp5HJnunyp9GK/I01W208pUvx9lE3mSxEq27XIMZfSQ6sM6rL7gxs4IusvbQMo+7LrJQyI0vIl6FECDdV3TNjKsHczTEQYzWSRcZVTK+92LjciwdIzGICTW3uzHX4BNLjFi2zZMIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPSEWh6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPSEWh6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A145C19421;
	Wed,  8 Apr 2026 18:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673210;
	bh=BLP0VtXBMCMYlOmYKelOinKc+w2bJVAi9876VtAqUQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPSEWh6VbbcVuMGCkbSK6p2Nl2caR7HzdokY+ZKYCiuSgc3VT9ey7vQb9bEWlHzg8
	 laG77T+gzorjPomYS0/itwPDtgqVfD69rI024ATavg6c6jCIoI+dQBhUr03IPK8cGD
	 fch1V7dMVEFencL9urOIr331rJjL2ry7R4y5VHzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 142/277] Bluetooth: SMP: derive legacy responder STK authentication from MITM state
Date: Wed,  8 Apr 2026 20:02:07 +0200
Message-ID: <20260408175939.176882778@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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


