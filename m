Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2D437F01B;
	Wed,  8 Apr 2026 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674731; cv=none; b=RImYmw34cQjFUzkjtt3OE3JescwUPvm1WCPb6xx17AIQz3PqoR4WjvtH7iCQDUrdMubqbrWhux2TF4Qesx4IEi/iZCXZAANgCuFFJ6RxbMP70d45Lm10W0nHF4vKaPWBSIWTQDE3Vjj8qUN06PchP3WFw+YS+MUQUH88xSDcIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674731; c=relaxed/simple;
	bh=ufybht9EdzybxgL+IoIqu0SrrGnx1VJQoyWgr0rlGog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFTWYPgYk98xvbCkdNsmmtrr5geiYF9cgbANYM5V97XWLRIxUdmgcNkeAC377eJxJMTBWGJtld7t/Xww8GeawT5ZxLpYm6kPS2ugLjzf9iqt5JSJ5XV8xKZYA0T/Nc/BPYOah+8XjWPCGtozbupH/R++Rb2L0NOURLw9IqR41rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7mgHx41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7mgHx41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2154EC19421;
	Wed,  8 Apr 2026 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674731;
	bh=ufybht9EdzybxgL+IoIqu0SrrGnx1VJQoyWgr0rlGog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7mgHx414KmfZ74xpEOOQKkcubdbj/b/00iM9eHIvsMfuVWrn4ZmMF6g3YYJvRcwR
	 vdV+TSHP4/gcKX/HPopAtfsM+kvwWAY9gEbjXVR9Q/h1yIJXwBZWU6plK5PEUggKmm
	 EfBjkJVjORe1nOPcpyElG1ld2V0GTrDu9kKWa56E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.19 179/311] Bluetooth: SMP: derive legacy responder STK authentication from MITM state
Date: Wed,  8 Apr 2026 20:02:59 +0200
Message-ID: <20260408175946.090909276@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


