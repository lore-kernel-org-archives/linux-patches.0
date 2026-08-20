Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D159D47CA8F;
	Thu, 20 Aug 2026 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248606; cv=none; b=LdCRB3NZWHOkczTZkZBMWV4bNJEi8Wohts4h4K0VuRLPY2aI+OvUn6kCEMhE4oD6c99kS3afnj8HNKEDSPFKhrWE1/ZwesgdGcuZ/YB2d2lcboR0b+LeZgbD5IVg1pg6tWNzM7QD4y/eUAmEBxndtHV/zIlyp8nTkfGnczCWM+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248606; c=relaxed/simple;
	bh=Ft4nH6MmHSQQ/C2psDzBghp2m4U5754sQLgb2msMXBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCaLXafn8mC86IVIcoyJT5Ycia17rYJIiW8ITIu5dHvhsNeLnAdvIdZjzm/ug8TzF37MXlChexmOq9WHZCeETDgkkGf+NAePDZtH+nAkQdIwbz9B5SA4E0aOLA+KaUSUCPJAblNqxYyTjcCJFH+eIpTZOOKjT11eDV5QAAA6BEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zktYpigJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zktYpigJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3708B1F000E9;
	Thu, 20 Aug 2026 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248605;
	bh=fgEaj9neuPvRuCrAYDNeokSTJzN3KD2c2GuuVqf5u/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zktYpigJNLIZpho13WshmU85UEpWBaZ5w+/d9HlpUAgJDGhfPjsGkbzJq8qZlLyGs
	 u7hVUD0WEvt9d+CdOeBbH3s7oJbDeL8eY+Udw0Yb5RfEPcwNHjVdaKyi6/FsQmxzUx
	 Mz1kYxgSMLiLLXjtC1eR0pPA7ucU+z31ts2c50Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 287/303] net/tls: Fail tls_sw_splice_read() after a failed async decrypt
Date: Thu, 20 Aug 2026 16:57:03 +0200
Message-ID: <20260820145302.099297953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 976df67f463db1fddaf2a32fb04f57ad2891a23d ]

When an async decrypt fails, tls_decrypt_done() records the error in
ctx->async_wait.err and calls tls_err_abort(), which stores it in
sk_err. tls_sw_recvmsg() and tls_sw_read_sock() each read
async_wait.err once they hold the reader lock and fail the call: a
record that did not authenticate breaks the connection.

tls_sw_splice_read() has no such check, and sk_err does not stand in
for one. tls_rx_rec_wait() tests sk_err only inside the loop it
skips whenever a record is already parsed, and the first reader to
reach sock_error() clears it, while async_wait.err persists. A
splice therefore keeps delivering records on a connection that
recvmsg() and read_sock() refuse to read.

Read async_wait.err in tls_sw_splice_read() as the other two readers
do.

Fixes: f314bfee81b1 ("tls: rx: return the already-copied data on crypto error")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260806-tls-splice-crypto-fix-v1-1-a2624005a286@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 5eec7c10acc20..1b336522ca67d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2350,6 +2350,11 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (err < 0)
 		return err;
 
+	/* If crypto failed the connection is broken */
+	err = ctx->async_wait.err;
+	if (err)
+		goto splice_read_end;
+
 	if (!skb_queue_empty(&ctx->rx_list)) {
 		skb = __skb_dequeue(&ctx->rx_list);
 	} else {
-- 
2.53.0



