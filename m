Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041344;
	b=2StoFVgMdAsZCOkIz4Lml9C6rhW/owpmWJP5ukn5mRdZc9IQK2o7XpXT1fd8UHBfQXXm
	 +ePlk1QlVhJDByvYKwJfkcdXwKNrZUwXRFRcJDPULGANQkuWXIE3k98nTvg7u8vgl14JT
	 KJ5sHA853tGWpHn3f1qABH9EWOCSOkFpXXRgcVXdKonH1Swd642po58Szb4qKLdgWGy6k
	 RZTyjMDWOhlETlfszYjUPyR2k4eBsVaT4/RaP5OiWft8uakrsyykMcro98uISuzlBA7zP
	 IglAAJ6SK15w4O226LUxdAkqNOaGdfkiC/OnL49RNGzoqxzOrF5KHPGB64fu4vzqEtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wl62dgSybgJvgzYA5MB6stGhoTtkOiLDRJ4K/OV9Hr0=;
	b=jaKcoslKO54DLeibbhnKKjsP1gyRGdr41RK9w9TF56WK/C2ii/7oJ70GutDvJdDfTKjU
	 uLqpakMwCrKr700lARiVZOYgkrJM2wprQJnJz7X0WWfw+gcsRLxKgqDoZrmTrI0o6n6zU
	 /tkT3wexD3vzgPqmG5C/mh7ujGZJU5WT2TZFFDfPz7icNkEBbBAIhMJsSyrHHrdOTFozO
	 IM8VAQwCUwpGPVABmk+Qpq3S/okdlEsFWKVljT5GNOfKMyHGMhGGcVkPCRAljP+VKTep/
	 R+SOhohwzjU2CoTfjkDcfqUiHJmBMZk+qWp52i7RFMcvxpErtF0GNd5a99T0mV3/K6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dz4vzuQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D830606A32A;
	Wed, 18 Nov 2026 22:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dz4vzuQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34BB1F000C4;
	Wed, 18 Nov 2026 22:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041344;
	bh=wl62dgSybgJvgzYA5MB6stGhoTtkOiLDRJ4K/OV9Hr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dz4vzuQFRRXUFE/bwx/NnraFc/rZ9B9WInC+DtfESgDYS3A8XJN4u/kg0SXYBs+8H
	 lENZfnDcT04yT+PrMxPdmsSBPtT1Du6wwEKjPWwS+5shT4OZI3AfxbIVDZmhrjhR8s
	 dRHTY6xv4QIJyae40NKAmAGKr6mtN6qAuYwRioZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2780/3318] tcp_hybla: fix divide by zero on rtt0 == 0
Date: Wed, 18 Nov 2026 15:56:42 +0100
Message-ID: <20261118150444.102709300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index abd7d91807e54..b9b482180d30b 100644
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



