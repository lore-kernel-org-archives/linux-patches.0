Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624370;
	b=TFmuMF8NtThkhjVc9VBqIxaW8kC/RNC8PBM2MWTYkbV2EKDdz2cUcmBmvo/TUowOT9TQ
	 H8LHdq1NofT77EqBTbMQNmZgElrIcSbRWmDNgaToUF9IgectFVfk0d11mtuwXhof9i0W5
	 eQVwb2avTPNBAzFsZZ90nxyx26HtovlNgj28OTGrTW0XYlvOTRRo6palkZ6ouaLYvXsZe
	 DWtJHx1HUuh1LeplRUkzbQyYeqN8abymTdhfMhmpLWAF3YqkQksOehuhFad0LqtRR8KRc
	 c3fDWOArF/Jnqux9rvpe8yJnPyu/YkbDl8IEdf3wDjlsh8EHPgWU2vqurRTC6OkWHhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwAAIbPrKxDK5H0odjMX8tENKOfyqBsXZdVEYAsnSTo=;
	b=ED3Wecr2SM8cNEF04gJgZKh20E5jXxjMmrBOx1prlf/7hk/sU7fHUHF3ryKKG8+1LYIQ
	 eio4qrDMZ7tNe1gWxkHJt9lm7BLsmJ1PkrXNvZ/x1q0P9yUDqd2e5gQEWY8QDRR20oFos
	 xJled7Sk0f+ut8CHqzBQF/ih/gRq4dOU0OaiYs3vFNakLVDdul/Cgxl5Grr15+JvV67os
	 CqscVmx5sTNcLlIVtpjFUlp0LzRVVKUV9+p1Xwcs3L2pibubUVpYz2u/fv1xGKrA3cEC0
	 Zb3NtVjtbcM5Fo+BXlbQUJKxtf8MoofVaqmH7Aa/Mgb/iU8w9TAyE7SXhodPsgNuIzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q+/oGDcf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82703606A331;
	Wed, 25 Nov 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+/oGDcf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C4D1F000CF;
	Wed, 25 Nov 2026 16:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624369;
	bh=kwAAIbPrKxDK5H0odjMX8tENKOfyqBsXZdVEYAsnSTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+/oGDcfGXykFJhYDx00DoIDLdx5Frr24VV5CrFCEjsmrdgIZqXo5v73JwZF56kB0
	 F5JKOWKK4KLwZyUp1PIEQDZKlWjo8U59hc1mI3UE742IbspftlIAEJXiOsEri9etT4
	 NHwuqrWWnfVMCdObDFxkKFeDr5DjLcu9Q7qnkR/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yang <Leo-Yang@quantatw.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	netdev@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/816] mctp i3c: Fix locking in an error path
Date: Wed, 25 Nov 2026 15:28:37 +0100
Message-ID: <20261125143853.106379966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 750eb5ab457e62e221a9c8521e2274f14c85b387 ]

If netdev_alloc_skb() fails, mctp_i3c_read() jumps to a label that
unlocks mi->lock although that mutex has not been locked yet. Fix this
by returning -ENOMEM directly. This bug has been detected by the Clang
thread-safety analyzer.

Cc: Leo Yang <Leo-Yang@quantatw.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Cc: netdev@vger.kernel.org
Fixes: 2d2d4f60ed26 ("mctp i3c: fix MCTP I3C driver multi-thread issue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/71e0a880ffe7a83237e501b07884bf54343e76ca.1793296780.git.bvanassche@acm.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index dd74f916e3172..7b8f41ec3012c 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -111,8 +111,7 @@ static int mctp_i3c_read(struct mctp_i3c_device *mi)
 			       mi->mrl + sizeof(struct mctp_i3c_internal_hdr));
 	if (!skb) {
 		stats->rx_dropped++;
-		rc = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	skb->protocol = htons(ETH_P_MCTP);
-- 
2.53.0



