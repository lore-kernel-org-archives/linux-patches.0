Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019760;
	b=yDZo24DoTfbuIlf9PI6PQV5BZTH5sP8vg6uClgVmtIxBWedOydjERKYf2M24AjcRSw6T
	 QbKlDWsbBpC3TxhdXvHEYdK843uV4AK91/IF1VR+GVrK43NrB+qSSpgLvjhxFNyMA2q7e
	 j6ugEpeGOyVtCFYm9msTPDahwYVHY2sBHFUcdlEoVtgAxBxlxktlEZ2pJ4IRvLFelGghh
	 sv78C8CsCGm32N7RAzfkqrsgtTRvx6cxWE8f437LjtJ4mK4UwdDPwzMP1FWk6Eko6Peoe
	 p2yd/nVWjCkmemHUvXPMa9mglk4ojgv9160E50D+PPbmS1KoUHVhj+3bC08Qtoxuh/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y9BhyU1OKPgvemrcc2wBCy+FfovjM2VJoPwhvOwSYx8=;
	b=tCVqdqe+mpypHCrObWb3mxXU+aiLDWfKRci9efjDRWITRwXdZVyT4cbuM0H31GDTp5VG
	 7ZN4mGogVjE/SbQoRaoFzjY2V4X4VKJEpcm/RHlRE7/dImQgUzjcqEyaotPrQ3RnQlIDp
	 q4yeFdUHruXbjKAJXTyXb3Bqy+8qg0+14d0KWCDwc4Vx2VSwhXX53TTBJUrfAAQt5xXaV
	 NXzfk1jw2SkZevK2oNEp+1adzEfjgSUkT9yLEJqQ1VZ/fTgs8cp7Ko57z4Z6V2kK3HO8J
	 8AdTXUmpKt7VbMuEFKh2oxI9ieyIGLVlrW1lifreTuYcPWCCcGAqMpT5MkJXZ7EAq8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJaUZAAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31CC606A32A;
	Wed, 18 Nov 2026 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJaUZAAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2477C1F000C4;
	Wed, 18 Nov 2026 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019760;
	bh=Y9BhyU1OKPgvemrcc2wBCy+FfovjM2VJoPwhvOwSYx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJaUZAAjeLsDisavrnrJpu8zagFZC8D431NEqrd7PdkO89jvQ/BM5uHJP+wVQ+B+N
	 2TiRO0rmAXsWN7dkdhLtyZJczZGbyObMA6HwS4HKY9amVD8x/vqUJugvDxdcYER+er
	 ma4iv4XhGCkD7j+/meH2eMcjI/LZg7eqc5wBj2os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1712/2651] tcp_bic: fix divide by zero on max_increment == 0
Date: Wed, 18 Nov 2026 15:49:12 +0100
Message-ID: <20261118150349.263261685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 8edbf6c23363563e508a61f3f26f4e4b6eec9dd5 ]

max_increment is how many packets cwnd can grow per RTT, so 0 makes
no sense, and bictcp_update() divides by it.

Reject values below 1 when the parameter is written.

Fixes: 83803034f423 ("[TCP]: Add TCP BIC congestion control module.")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008092641.140777-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index 65444ff142413..27d2e38ff7932 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -27,15 +27,25 @@
 					  */
 
 static int fast_convergence = 1;
-static int max_increment = 16;
+static unsigned int max_increment = 16;
 static int low_window = 14;
 static int beta = 819;		/* = 819/1024 (BICTCP_BETA_SCALE) */
 static int initial_ssthresh;
 static int smooth_part = 20;
 
+static int max_increment_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 1, INT_MAX);
+}
+
+static const struct kernel_param_ops max_increment_ops = {
+	.set = max_increment_set,
+	.get = param_get_uint,
+};
+
 module_param(fast_convergence, int, 0644);
 MODULE_PARM_DESC(fast_convergence, "turn on/off fast convergence");
-module_param(max_increment, int, 0644);
+module_param_cb(max_increment, &max_increment_ops, &max_increment, 0644);
 MODULE_PARM_DESC(max_increment, "Limit on increment allowed during binary search");
 module_param(low_window, int, 0644);
 MODULE_PARM_DESC(low_window, "lower bound on congestion window (for TCP friendliness)");
-- 
2.53.0



