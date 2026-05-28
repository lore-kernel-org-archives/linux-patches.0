Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135B81C3318;
	Thu, 28 May 2026 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000030; cv=none; b=ORKL2rHKvfKDWUEr4hqdElg+AsjwcmbE+xCDZXAVCj1hVAiJ2sCqAQr1O8FzsVpQmLntAF+n1i/AfeKRAgSIEcegZRG1imJztKV81l5kginvVKa2CU8h0KxLRoer5580vFAsOgskIfzMHn/hW2W9KmXbzvq2+nmDCtZ1MgnrR2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000030; c=relaxed/simple;
	bh=LG1QfqsCjk+BJE6pojD9ZMTbCLSRvNnbGmhJOxRPTgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqznc3vXrgrZ04K2a2uXmzf7VlnZ66lZGpzbf5ZH2vMvZdYlteMghZAPeSTodpMkVtveNXiXkLdHego7thPGt02FqqNu8qKpnGkIldNy/WzMGtA/bQhWt5tbSWPLgtjd9y2acxNm4SKBZO67kHacigS2cetemH1+3FVWWZhiENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EV3rwSXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EV3rwSXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779071F00A3F;
	Thu, 28 May 2026 20:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000029;
	bh=tKPnmL0/pKSFzSbjdYdaOdUwiGKjBkcjVEaoNIdWQb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EV3rwSXtdhWFx9ojZW/1agtvOeNv8bckZLN4pEySWMj9emMKmDVfDkA8sUL0KSvVL
	 gF708Fpdj4JuaicROAwAz10qln7KJwHg6+GhvK4zRY9XMP5wU2qnFKKBbgfAofRLD1
	 u06li9KDmSNxZPthWSIPioUhTvYYZArs7kV8ETNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/377] net/smc: avoid NULL deref of conn->lnk in smc_msg_event tracepoint
Date: Thu, 28 May 2026 21:48:28 +0200
Message-ID: <20260528194646.185492614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 7bf563badd37cb796df5477d2b78bb64148a1268 ]

The smc_msg_event tracepoint class, shared by smc_tx_sendmsg and
smc_rx_recvmsg, unconditionally dereferences smc->conn.lnk:

	__string(name, smc->conn.lnk->ibname)

conn->lnk is only set for SMC-R; for SMC-D it is NULL. Other code on
these paths already handles this (e.g. !conn->lnk in
SMC_STAT_RMB_TX_SIZE_SMALL()). With the tracepoint enabled, the first
sendmsg()/recvmsg() on an SMC-D socket crashes:

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [...]
  RIP: 0010:strlen+0x1e/0xa0
  Call Trace:
   trace_event_raw_event_smc_msg_event (net/smc/smc_tracepoint.h:44)
   smc_rx_recvmsg (net/smc/smc_rx.c:515)
   smc_recvmsg (net/smc/af_smc.c:2859)
   __sys_recvfrom (net/socket.c:2315)
   __x64_sys_recvfrom (net/socket.c:2326)
   do_syscall_64

The faulting address 0x3e0 is offsetof(struct smc_link, ibname),
confirming the NULL ->lnk deref. Enabling the tracepoint requires
root, but the trigger itself is unprivileged: socket(AF_SMC, ...) has
no capability check, and SMC-D negotiation needs no admin step on
s390 or on x86 with the loopback ISM device loaded.

Log an empty device name for SMC-D instead of dereferencing NULL.

Fixes: aff3083f10bf ("net/smc: Introduce tracepoints for tx and rx msg")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_tracepoint.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_tracepoint.h b/net/smc/smc_tracepoint.h
index a9a6e3c1113aa..53da84f57fd6f 100644
--- a/net/smc/smc_tracepoint.h
+++ b/net/smc/smc_tracepoint.h
@@ -51,7 +51,7 @@ DECLARE_EVENT_CLASS(smc_msg_event,
 				     __field(const void *, smc)
 				     __field(u64, net_cookie)
 				     __field(size_t, len)
-				     __string(name, smc->conn.lnk->ibname)
+				     __string(name, smc->conn.lnk ? smc->conn.lnk->ibname : "")
 		    ),
 
 		    TP_fast_assign(
-- 
2.53.0



