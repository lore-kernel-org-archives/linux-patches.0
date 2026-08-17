Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3874A4457C4;
	Mon, 17 Aug 2026 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980434; cv=none; b=hx3iGCawPvORs34VdYh53ZV2ApKSEEniA73nAJDvbYvwjy9iKWETDlTqh+1JDt8PzxhFW1lzyu9132NrPEwqdfUqcVwy02Sr0pdfylkGuESFvZhM31Jtb6qdKvtZf5DiygXNc4Mgpt436vtLTi8pfv8b2Ftm1khZjDtNnG74owg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980434; c=relaxed/simple;
	bh=tvsc9fpyHUB0nDSwEBW1CLP8ZYbpuyzF5iQcLVJ0hAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPB/UxgLqorDQr7fPdwdyz7PKpPBfY/akXTGrHi+6j4Byr6ps0zs88qHz35NXob1KBWEHDQ4HlBT60q/I9jxioEc9cgqLuhxQ5OyL9+vpWwLzGbG6iiM351MgKAii4tZCXVAvIhjyFnVbbmxeQL7Ml93Rh9B9LcpNwprJwwh2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+x+nvSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+x+nvSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907881F000E9;
	Mon, 17 Aug 2026 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980433;
	bh=zPyv0S0f3P1J+Pxv7P7q899d4WlohMDPp2dHHothgvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+x+nvSeLRtcs8QUiSzgCRqkLA2prtEUxtMFAX2Hg3hjK4Qd9La/c/cnv2mCfSuH6
	 VpatIvQXjvap4G7l4NW0OIER2xm0RXwLyCRXIaW2ny3/eT14aOO/Su7X1LgGqZ4Lx0
	 2pImWkdhwPxaST14hIMWZ3fltUyvyH9mhNeDZB7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 531/609] tls: dont abort the connection on signal-interrupted sends
Date: Mon, 17 Aug 2026 15:33:47 +0200
Message-ID: <20260817132601.565007420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>

[ Upstream commit af0e5cdd031f4f4a8f6d4160bfbda4f36872b0ed ]

When a signal interrupts a blocking send, tls_tx_records() treats the
resulting -ERESTARTSYS as a transmission failure and marks the socket
errored via tls_err_abort() with the raw error code. Later syscalls
return the kernel-internal errno 512 (ERESTARTSYS) to userspace, as the
signal it stems from is no longer pending during syscall exit and thus
never translated.

An interrupted send is not a connection error: the partially sent record
stays queued and is resent later. Interrupt error codes are therefore
excluded from the abort in the same way as -EAGAIN.

Fixes: b341ca51d267 ("tls: Fix tls_sw_sendmsg error handling")
Signed-off-by: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
Link: https://patch.msgid.link/20260805063109.1772314-1-maxbr@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1b4e35dcb996b..5eec7c10acc20 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -457,7 +457,7 @@ int tls_tx_records(struct sock *sk, int flags)
 	}
 
 tx_err:
-	if (rc < 0 && rc != -EAGAIN)
+	if (rc < 0 && rc != -EAGAIN && rc != -EINTR && rc != -ERESTARTSYS)
 		tls_err_abort(sk, rc);
 
 	return rc;
-- 
2.53.0



