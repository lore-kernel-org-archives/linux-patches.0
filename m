Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB38337E5CB;
	Thu, 20 Aug 2026 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238605; cv=none; b=raMRTyGTP0xaiM7nVU03T73WZVN1iCaydKADPD9iPv6PVc5w7GM6H31T+A1yqPhfmn6q6Kk5FmD6u4AqaNbdViIpoyGlH5Jqo7UsaS/vqfY0xAGwt0yCwDKRAEmCNjaxy323z4zsK2TVG/luLWuhRyZpaTG+P1egZCDKgb1fFbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238605; c=relaxed/simple;
	bh=UdlHkRXUozg2rZ3v2N+VksusLmPe8W9VmFt+z/+Zy6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRkpjNZPsJtWpHn/5HXtS/6Mxiwuw05jne/WBl7VhDCZ0BgMCCX9XmflKjOWjrBdwOSIsTskz++2wZEboRfOEPxyPV4iZkPMw1POCzvfsp8+Yza05/qc7Zzu2XASzLdQlIEqDdYW1IZhu7/KXtvo67XCOztc4RTVauuZIjd956U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzft0lJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzft0lJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B4D1F000E9;
	Thu, 20 Aug 2026 15:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238603;
	bh=cN2hi31Cno9cYoCT0OW5/mEN2lr1PY1W8VWGs2+CTZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzft0lJJHV+HVsxnMd5fEnQzT0tFVr8nLxNUIu8QXvwLV7B/7SUuoY9hQogVjxe+p
	 SFHPkG3TxelfmtI/yh9fi5QmUZH5G63g/zRRKN4Ce8KwrBAqqymeYyk6Ly3R4e/1nW
	 4qgJbtWhh4EUgnSUtFa18UZIWdYv+uw4cnvPu4NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 205/228] net/tls: Fail tls_sw_splice_read() after a failed async decrypt
Date: Thu, 20 Aug 2026 16:55:47 +0200
Message-ID: <20260820145251.265245273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e9aea371331b8..ca0f657121a3b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2319,6 +2319,11 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
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



