Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209771;
	b=O3a31l5sNuWD8gUF+F5VAwxAir1xs0fDsunKjcAn5r/M+lz/ZWYv8N/xNB4y8iwRqgWP
	 15rHHl+vcmniIwhdcmUj9T3J2wbNCMBNmenUd6KEao5Bx6PK/1TeYFybjJYhbXQRSYNr4
	 yfVW64oq2iSe900GQdXEzigwjKZ9uCS8NqDEtOn2AHn+DhA/zWye4Cl7MwbfaIOlynwdL
	 YnA+JdmKJsOVg6pKM3oh0Eum99m4mzyTgrxGxTfSslwDIH64phrhCjn5HTe/bMk7vZUI5
	 7ICP0Ox8SW7PG4KfOMJGFmzou6Zu8q2kRnVDY/WyzEIOfTlt69E4JCP8GTYiENIujIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SFKK8nyavqXclFP5xhWTJB1a8kPwf9lpZys35ZRaju8=;
	b=RoIWmDwUWqxouRV1BV2h8CEW1RArbvDeU1xVsSipHWvz/5sRxQjcMa5P4JEWr8Md8+rp
	 IrM2+kV/0GGNyyc2bb5GJssC7dRmWHtNxnItcPimm7NAT31bisA0eWPufRRcoiZFiqm7X
	 Twd2PwP75eRzLH2w6xhVDz57VN1ToDQLahNgJ4npGBivSrZL4l2gwQYGcuEUExR29hmmw
	 Ic3R666pgMIpinjBMi4kdxqRf4a8IXCYJxF3KO6P4COBjSsBsnEo/LDUcBpJdi2UsV/Yc
	 v1ipkzWnQVDLX5l1TX8XCWpXqHTC3koVlQHYSgS666THVriqKDDj8HHW9BpXWlcRYcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjwJFWkH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBDB606A31A;
	Wed, 28 Oct 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjwJFWkH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375861F01825;
	Wed, 28 Oct 2026 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209770;
	bh=SFKK8nyavqXclFP5xhWTJB1a8kPwf9lpZys35ZRaju8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjwJFWkHF2WQYu+iMOnbgxmB69I3o9h9UyAIVMkWCnQivaiokqzzX2JEpgKoL89eq
	 BN3d96ema7Tfd9i51eqpnYqH3ZUOAEHZpxWXJwx4wepzHKddrSiby2C3ijRAAgd9It
	 D51ylF3s3tm+DPCODuapTruFWpOTzeBeOsu7bGA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 070/109] io_uring/napi: make stale entries time out after 60s
Date: Wed, 28 Oct 2026 18:00:54 +0100
Message-ID: <20261028165944.005378276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 9c151648780d89e5446e5f89f3fa2e416c3bb911 upstream.

With dynamic tracking a NAPI id that hasn't been seen for a minute is
meant to be dropped from the list the ring busy polls. The timeout is
added to jiffies, but it is defined as 60 * SEC_CONVERSION, and
SEC_CONVERSION isn't the number of jiffies in a second. It is the
internal factor of __timespec64_to_jiffies(), HZ scaled up by
SEC_JIFFIE_SC bits. For HZ=1000 that is 1000 << 22, which puts the
timeout at about eight years. On 32-bit the multiplication overflows.

So entries are never removed, and every id that a socket of the ring
ever had keeps being polled on each wait.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-33-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -6,7 +6,7 @@
 #ifdef CONFIG_NET_RX_BUSY_POLL
 
 /* Timeout for cleanout of stale entries. */
-#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
+#define NAPI_TIMEOUT		(60 * HZ)
 
 struct io_napi_entry {
 	unsigned int		napi_id;


