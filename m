Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D729C1F4176;
	Tue, 13 Oct 2026 12:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895831; cv=none; b=Uwe3sHI+ijV93ZresCcfZKucvPFuV3C8zN5oEVcPOgCTDMUpsl/BFN8X6wIUpeF6o+cl+Q3eURkF8/I1WFYMq9gPZDYmEBJyzxnoceVc30MXh47KsgvLjVQuie/YWfdA8XJBUvl3MaOvX8KiwcpVNlkAqAHiZfXUTH5Ta6jd1go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895831; c=relaxed/simple;
	bh=tvXl7/gWS9ySNxsSisQ3XJ3x6ibBI8E8nlQ7c4ZtrIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isMoiRSQzkn/iGWxOWzZ+Sg6nDtGBEVOeu5IPry8pYpwQNX4iFAt+XJt1+ovdP0MEoUTsD9DzId0CwE7cCpMlZeD8KlL3ThxqjTnzLIThMcCOCliA5wx4gl01zo2hWQiiwt7SswDIGPG9Yph5c5gO5t2e9vcLKElCopQu+e79vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jO8d6uHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jO8d6uHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECE21F00898;
	Tue, 13 Oct 2026 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895829;
	bh=6r5tpceloxKH9LtnvLidgtv3RIVfrSzcTuNMGChlmdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jO8d6uHD3IMIO2+w9Bvb67UTXh7oTZoLQGIW86+THCxTnyhsOPnT/AI2/pwBe/bwH
	 LqrNWebpuZVM4lDwDc2L0Os7/Z0WK6H9udUkOnhBn/hscbUMweVByCfA4ZtvXr6Pdv
	 uvurLrO4IITVqemWWzR24FYqri26KlERQu5VuN7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 370/497] wireguard: noise: reject response consumption after intermediate initiation
Date: Tue, 13 Oct 2026 13:38:57 +0200
Message-ID: <20261013112916.681726339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


