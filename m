Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061523;
	b=oyZhgq9I7cf5pj0/t6HJK4VdlaC1pi+C3wBxI/yi4m9C5uRvM4noUZ6L03Q69pvvRloF
	 DGi2MkoHlc5a4SS3Et9WODNkT4ffhbq0htdqrHTj0MHVZRmT1UlZJApDyFGmVjG/AV8mb
	 l6xb6F8OK6EI8R5/GQDppgJ7IEMSZnIrH4RJvoR88EN4ksjx1ET0lInldwlTRH8xuSiWZ
	 7ZD1+qTUx4ijOn7XqhDL8GA0dfjuUUnsqEmuELOoxKwMcgMp2yhcxgzga66njd4BEhjV1
	 vXrKx/fEFPNRg44fNsLf02mw3p21yiYWNLPasq/ppEaQym5n9n8/g3hhMB+zayECDRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2h0ZhoD/w9day+MOEr89fuIaDiYopMqirIQSFg7ZNM=;
	b=hLQfKA6NRvQ1SKPU9ylqFaHTYY9yU+mb9kxudhg9Q/2fM1BPfPYuhGJ5gs43rAse9zI6
	 5GxifhJjkqUu8cXLOvyu7AkF0LDlWb1KIyWxYM7W05IbaLt6xY13Oh1vSsGg8RgoF7IxB
	 OCV6XLpVAWkNq6Ql6KCb886MxuUeky5hTonhtnmPxqC6HRMUG5LoU4ujtIA6SuTrChdRO
	 R3tSovkoio7TCq65H47RAx5WBV9zuUHvUh3Qm7nScdgs9515/BzFtLc7pWyfNKVAAhwRv
	 twtzhSwhaHMOFdQlwsAXuu1u4yF0qxe2hBonfiFLz65zyY46TNtouKMeFUuRslK4pdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkjgtzlI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E8B60A2604;
	Thu, 19 Nov 2026 04:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkjgtzlI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012CC1F000C4;
	Thu, 19 Nov 2026 04:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061523;
	bh=K2h0ZhoD/w9day+MOEr89fuIaDiYopMqirIQSFg7ZNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkjgtzlIWqzQzOgB8QwQ5tEEvUaiLAcnvI4ICalPyM8V9sYEgAddgWtB0AatsFKQH
	 Qq4oJBvMcFYKpKIbpYl9LnFN3fZcX1sDTB66nkUM1pQSdM3TMb742GFSY57QH6XDCz
	 LjuO84GUPsw8dGhXQ+k/ElOY5/PNkPn++hqC7wPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1582/1848] tcp_hybla: fix divide by zero on rtt0 == 0
Date: Wed, 18 Nov 2026 16:00:20 +0100
Message-ID: <20261118150025.792183048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit f09eb97322b16a6f709a47599c95b62f786905f9 ]

rtt0 is the reference RTT in ms, so 0 makes no sense, and
hybla_recalc_param() divides by it right from hybla_init().

Reject values below 1 when the parameter is written. Also cap it at
U32_MAX / USEC_PER_MSEC, since rtt0 * USEC_PER_MSEC can wrap to 0 on
32-bit. An rtt0 above that (about 71 minutes) makes no sense anyway.

Fixes: 835b3f0c0d7e ("[TCP]: Add TCP Hybla congestion control module.")
Fixes: 740b0f1841f6 ("tcp: switch rtt estimations to usec resolution")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008092641.140777-3-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_hybla.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_hybla.c b/net/ipv4/tcp_hybla.c
index be39327e04e6c..1ba48641b2191 100644
--- a/net/ipv4/tcp_hybla.c
+++ b/net/ipv4/tcp_hybla.c
@@ -26,8 +26,20 @@ struct hybla {
 };
 
 /* Hybla reference round trip time (default= 1/40 sec = 25 ms), in ms */
-static int rtt0 = 25;
-module_param(rtt0, int, 0644);
+static unsigned int rtt0 = 25;
+
+static int rtt0_set(const char *val, const struct kernel_param *kp)
+{
+	/* avoid rtt0 * USEC_PER_MSEC overflow */
+	return param_set_uint_minmax(val, kp, 1, U32_MAX / USEC_PER_MSEC);
+}
+
+static const struct kernel_param_ops rtt0_ops = {
+	.set = rtt0_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(rtt0, &rtt0_ops, &rtt0, 0644);
 MODULE_PARM_DESC(rtt0, "reference rout trip time (ms)");
 
 /* This is called to refresh values for hybla parameters */
-- 
2.53.0



