Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590936;
	b=PklwFL8eqyMsnL+HvIlzNO1yfTrBgOjQ6ainqqemg7oIgWJm9Jd1BYUoBkftj3ogYKNo
	 dlhuDK3Xun4Jq1Cns6CqfLfKrd8cIy9dhF4M6cz9kUj9RYS1Wm5IGJQGE7BRorCeMdv4y
	 vYV12+toQIGyKzmDi0ln3kC8xoP7IAl94+SLkgR8LJe2ceJ5BgHJUAihu+NPWyGCfs1dd
	 wCooWIKDeQCgedE8cfGFjacEbnezah88NIPK2Op8HB/B4fEORvRdB1o7sf7VPTEXPOeAa
	 YWGFlO0sYDyiv/U5YnJhMVYKmt8jAIlTRtj9gFvKfqMcvfz2BXZe4xSaLK7t85ymsdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7IGSn6q8MUFgpLkxAxcmglZbTlMGZJUe0tSOiuclUUA=;
	b=cEs+tFgSGoKyfn0ksqqpXw/aK0FpISqWw48Jq5r20KO67C8OS0PCVTF8GfxDKZWYBG1X
	 N1xA0jFvlk+nNyw/uJcq2U1DspfVGOKx6LhLQq+gckiOHfS4XvX5I6xmrkwSpkt1BbBQR
	 Wkci+P8GyB+pkM46FhuCPfOInXYL5kL4eHZ0//IquQFasH02K2v1A7cu+5YZqjXt+Zx4j
	 40bExusFj2XFRQGMl9LucObpwUydoMnkAUEhRi6RXsBq++iPzsmXCyOKL3+7Z341wE0TV
	 gba6edAjMUIAdj/7dYrRTavxRAt15ckOv6Bo6YdX/8HVfFlaAMIV56hnfCQ8c7XoyEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1usYN3a6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD723606B441;
	Fri, 13 Nov 2026 17:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1usYN3a6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8A71F000C4;
	Fri, 13 Nov 2026 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590936;
	bh=7IGSn6q8MUFgpLkxAxcmglZbTlMGZJUe0tSOiuclUUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1usYN3a6y7KrTyR0uQCS37CsU5GAmhzgvVSyst6XwirCbTwz9HEjNW3dB7pZTy5gp
	 ujGUip+atB3gwPOXTv+47zGk5rBusSONEok1ntbKkwHKr0fpQRPxN1QgTb9ezUH3on
	 eb1Q0hC+SxXlDYQJstmCyWZe9P4fqxUKeipe9DQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/670] ax25: keep the window below 8 when a socket goes back to modulo 8
Date: Fri, 13 Nov 2026 10:44:45 -0500
Message-ID: <20261113153815.918545871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 08b196ddaba5e..43f4ea1ef88e8 100644
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



