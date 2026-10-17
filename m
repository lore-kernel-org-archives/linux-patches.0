Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC703AA4E8;
	Sat, 17 Oct 2026 17:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257181; cv=none; b=okMclJ0TZ9+4s5yfDknCG52f7lKDP86f1+kT52Yj/u3roAtswI1i3lDI9QH0nAREg+Fn2AtqOeXtllTl0fTlYhnefA75bfpZSeKYQU3+uHG6q0ZrxzbAhl4LSFcSEMRh9/YRgM8kGZ9XtnAVZO4mox26kCcTZu65tp+TMFZGsHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257181; c=relaxed/simple;
	bh=Rer5gZBjYBmEvJQJOlb+QX55MwZH40u1qoMdtLoTEcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWHRgm5ESEbROmWslJ3rw7GfD+eVyWS5E5ghkPSEH3OJmpJ37kSyTKCXy09TDIAjIIul1oKfyT2urYPX16/sfRervLOykGnEzQkQ9SRFKOKpcHvj5jq/EHQz5P9sHblUZLJGGZ5wG9zKzIWD4nrCGvm4bZ9bdw+nRINZxXFxbF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GV/OafLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GV/OafLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9991F000C4;
	Sat, 17 Oct 2026 17:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257180;
	bh=qusRis1I97eAql+PanycV2bnnHK2FxEpjrXIyxSQhAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GV/OafLOYawnUevMSLw+uWAi5UiJ5wqYyEmuv9S9FuZXYcGbUuRd14J4NQPDoVb0N
	 KcpnjnefXFd3q14YHUb8LyF0A7MNAE84dylYc49y9Dj0I5hPAfBihrY2kPd1P6rnb9
	 qZFIhwTzhf3sZLMQexUOg5/PpdPZs4fSAGNff/d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0475/1674] wireguard: noise: reject response consumption after intermediate initiation
Date: Sat, 17 Oct 2026 17:45:47 +0200
Message-ID: <20261017160443.307640465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit d0305f8d90029556260c6824b61c493c424eba9e upstream.

Two threads begin processing the identical response message, received
twice. The first thread, A, runs. While it's running, the second one,
B, gets partway through, and during that slow calculation, or even while
blocking on down_write(), A completes and then also a handshake
initiation that's already been queued up runs in thread C, which itself
takes that same down_write(). The handshake initiation creation
succeeds, and sets the state back to waiting-for-response, and calls
up_write(), at which point thread B resumes, because either its finished
its calculations or was finally allowed to acquire down_write(). Thread
B then copies the state back to the peer, and begins a new session,
using that state, which is the same session as the one made in thread A.

Thread A			Thread B			Thread C

down_read()
 sA = handshake->state
 memcpy(cA, handshake->crypto)
up_read()
if (sA != 1)
 goto fail
slow_crypto(cA)
				down_read()
				 sB = handshake->state
				 memcpy(cB, handshake->crypto)
				up_read()
				if (sB != 1)
				 goto fail
				slow_crypto(cB)
down_write()
 if (sA != handshake->state)
  goto fail
 memcpy(handshake->crypto, cA)
 handshake->state = 2
up_write()
down_write()
 if (handshake->state != 2)
  goto fail
 derive_session(handshake->crypto)
up_write()
								down_write()
								 slow_crypto(handshake->crypto)
								 handshake->state = 1
								up_write()
				down_write()
				 if (sB != handshake->state)
				   goto fail
				 memcpy(handshake->crypto, cB)
				 handshake->state = 2
				up_write()
				down_write()
				 if (handshake->state != 2)
				  goto fail
				 derive_session(handshake->crypto)
				up_write()

This seems basically impossible to hit in a meaningful way in practice,
but ensure that it absolutely cannot happen by comparing the ephemeral
private key that's on the stack with the latest one that the peer's
handshake state has.

Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Reported-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20261008130124.724119-4-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/noise.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -784,10 +784,11 @@ wg_noise_handshake_consume_response(stru
 
 	/* Success! Copy everything to peer */
 	down_write(&handshake->lock);
-	/* It's important to check that the state is still the same, while we
-	 * have an exclusive lock.
+	/* Check that the state is the same and that this is still the
+	 * initiation we started with, while we have an exclusive lock.
 	 */
-	if (handshake->state != state) {
+	if (handshake->state != state ||
+	    crypto_memneq(handshake->ephemeral_private, ephemeral_private, NOISE_PUBLIC_KEY_LEN)) {
 		up_write(&handshake->lock);
 		goto fail;
 	}


