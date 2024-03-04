Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143AB10A1F;
	Mon,  4 Mar 2024 21:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587725; cv=none; b=g9FquISK/3RdLFcnFZIqh0/hFShvW8FsJVRl2K0TFdyFHyPZT8PCHBEOIfBa/AVYQgxecx2e6Kay8uUqvjUWO/mlTgkbFsyDUQ2BApsMC6HiuCWOY+bBuLoEXnpSA0alyTwGo67d0US1szQp4ZgxcqnGccq2lsSMSr8DD8zdVwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587725; c=relaxed/simple;
	bh=4k2jw9Zgt4pzDVRiiww8rKSVMxrcha9oXmGeBeISeBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2USglBpbJu6o9AGGIi3l1q3bNXb9wQ44rGPfjlffo51DtaGqfQ5TZ37Bmjf+/hUXEq9pK+OvViKsqvEhI9LJx/aig7GG33n/JXK2NhmVpE0slNdViJbZT3e4tLGEnTXPJC5fwOrSPBrSz40cPFBh7fczslRGYVE9inwLURceZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUTn+9yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUTn+9yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D77DC433C7;
	Mon,  4 Mar 2024 21:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587725;
	bh=4k2jw9Zgt4pzDVRiiww8rKSVMxrcha9oXmGeBeISeBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUTn+9yx+/SjcQxM6gsTajADibWzAkjngu0EzVUXWwWdee2DvWcriFKbIITWFvdy8
	 hgtg0WvCfFGi6uKwGek0wb4NK2Smb/UAtbmaOxk+cuYhLO8NW4Q60xg3Nj4I0mcyRo
	 uL3QQrrTqp6FpVg4yLkJ0pvVcqFY3wRRASK3kqqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 041/162] tls: fix peeking with sync+async decryption
Date: Mon,  4 Mar 2024 21:21:46 +0000
Message-ID: <20240304211553.165332994@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 6caaf104423d809b49a67ee6500191d063b40dc6 ]

If we peek from 2 records with a currently empty rx_list, and the
first record is decrypted synchronously but the second record is
decrypted async, the following happens:
  1. decrypt record 1 (sync)
  2. copy from record 1 to the userspace's msg
  3. queue the decrypted record to rx_list for future read(!PEEK)
  4. decrypt record 2 (async)
  5. queue record 2 to rx_list
  6. call process_rx_list to copy data from the 2nd record

We currently pass copied=0 as skip offset to process_rx_list, so we
end up copying once again from the first record. We should skip over
the data we've already copied.

Seen with selftest tls.12_aes_gcm.recv_peek_large_buf_mult_recs

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/1b132d2b2b99296bfde54e8a67672d90d6d16e71.1709132643.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9f23ba321efe6..1394fc44f3788 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1950,6 +1950,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
 	ssize_t copied = 0;
+	ssize_t peeked = 0;
 	bool async = false;
 	int target, err;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
@@ -2097,8 +2098,10 @@ int tls_sw_recvmsg(struct sock *sk,
 			if (err < 0)
 				goto put_on_rx_list_err;
 
-			if (is_peek)
+			if (is_peek) {
+				peeked += chunk;
 				goto put_on_rx_list;
+			}
 
 			if (partially_consumed) {
 				rxm->offset += chunk;
@@ -2137,8 +2140,8 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		/* Drain records from the rx_list & copy if required */
 		if (is_peek || is_kvec)
-			err = process_rx_list(ctx, msg, &control, copied,
-					      decrypted, is_peek, NULL);
+			err = process_rx_list(ctx, msg, &control, copied + peeked,
+					      decrypted - peeked, is_peek, NULL);
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek, NULL);
-- 
2.43.0



