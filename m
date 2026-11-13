Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590100;
	b=1Rb6kDpIRSeUDhtXPwITAChB9Tq0U1DXSkQwy/1YyodH9NfOyO5h0Jk+dFxgYau89SVK
	 dxL6yfSRlPJBTM7aW6J+cg6PLgLKGhfj2I64Ch/uAOq0FITYiBMHmaeBCdDFgBE5VEWuZ
	 99lCOdGTod8yCG22InvU3vHpiYpVQjrLdRFHE+hQLh0JKHVBKtO3ZEZbYGpfPM0POFZda
	 zx0wH/sTJZC3y6OHRZAxrvoXX3cydxp5+wFeelvjRcG/+hhOSG9DsHIcYBtsodJYDw1jH
	 4zuOza4kKMvm2T4LJoyqt2zFGZh0VLGuqac5MZBbjKd5il2SO/lal71XUryL8375IEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=keye52/HrAEr6dWGrZ/WItjb9rOtl48+5N+EwX1fC/Y=;
	b=EaL6WRAu0s5hS6X1CAPCtCnTLq2mvpr6kgSRcwP8g0g9Y505tFUgFK8g4n9jozd7EwLV
	 8Xk8su70ROiLn1aje/v43gk9qnqLnP1wG42gt+D/tLrJHXis5kePpwQBn8UI9SRSfjrZo
	 DK4+5CThw5WsZ8SuJoiZD2ICzC15VagebdJpRRybwjdfTApsKA4ODTmPuZW2DxggB2MJe
	 +cUYYFu8ZkzrTmPLXkG07epytgTwO7CT9boY6j8xqbQGuP9eAbposokxPd3ULK34V5RHp
	 Sb95hyAeh08wjFf4+30qoUwlsn535JnIZnNTow5row2GFXMigys/b6zxHZV0ZpAAHzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nwn+aIKM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B776E60A262A;
	Fri, 13 Nov 2026 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nwn+aIKM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D921F000C5;
	Fri, 13 Nov 2026 17:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590100;
	bh=keye52/HrAEr6dWGrZ/WItjb9rOtl48+5N+EwX1fC/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nwn+aIKMUegSW7qz2OWpnW9KKwwpLe2wxXTyGH4L6ROAK7o+hJzj1rkybwY7UH5MS
	 12t+Og8yUhoWSnsDq7TIvYc7SWoAuGhnTh+YeaKlhDGwJ+UENyHYgrD/+GxjPZ4KUm
	 71kDNK4r8Osy0KUyV0Ar51rhL19NIGOlR9fTZEls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/686] ax25: keep the window below 8 when a socket goes back to modulo 8
Date: Fri, 13 Nov 2026 10:44:17 -0500
Message-ID: <20261113153825.024332727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

AX25_WINDOW accepts 1 to 63 on a socket in extended mode, but
AX25_EXTSEQ set back to 0 leaves the window as it was. With modulo 8,
ax25_kick() computes the end of the window as (V(A) + window) % 8: a
window of 8, 16, ... 56 gives V(A) itself, the window looks full, and
the connection never sends an I frame. Other values wrap round to a
smaller window.

Bring the window down to 7 when AX25_EXTSEQ selects modulo 8.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). B sets AX25_EXTSEQ 1, AX25_WINDOW 16, AX25_EXTSEQ
0, calls A with a SABM and sends 5 messages:

  before: window read back 16, A receives none of the 5 messages
  after:  window read back 7, A receives the 5 messages

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit bcd2f2d49b5af392504f29292cbd622d857507b6)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index e1a47489c601f..81616e8438ce4 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -708,6 +708,12 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 
 	case AX25_EXTSEQ:
 		ax25->modulus = opt ? AX25_EMODULUS : AX25_MODULUS;
+		/*
+		 * A window set for modulo 128 may not fit modulo 8:
+		 * ax25_kick() would then find it full and send nothing.
+		 */
+		if (ax25->modulus == AX25_MODULUS && ax25->window > 7)
+			ax25->window = 7;
 		break;
 
 	case AX25_PIDINCL:
-- 
2.53.0



