Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529CD1A3029;
	Tue, 21 Oct 2025 20:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077472; cv=none; b=f3rpCN6CG1ge6qJYvnTkIpJkeuO4B6DtJRmJY6GrhnDVtO+vjYBd6l2pMIZu5xuRSGU9F2/MicYDCFHvGaUqwS2wnF3s3gescB5xKEISaWLTJ6NmhEe3n/2TQ8yFo+W6M4dDxCp4HhvmzDBjRLPnTQoCduYDpYmtrRlAVICC9eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077472; c=relaxed/simple;
	bh=Zs5+HwIj5iUXilbLa9M+3MGLBJeaV2xyUTUvOH0g/RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISJfXbRVkeil4+wyEemJiKQ8CU+8/f3DWol5WgKbjZTLIYT1SQpnLT3HeN9tXSXKdXG3AG5+805hs9S9FU6ZHrvkWZ1BGAIjpElIdxDiQJ0wOx2iOBT31q6d4yJj/FWhBm/rCE9Vzo1jp6MH732u7MRW84vaTcbUGuohcPopHlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vs+/BZmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vs+/BZmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF14CC4CEF5;
	Tue, 21 Oct 2025 20:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077472;
	bh=Zs5+HwIj5iUXilbLa9M+3MGLBJeaV2xyUTUvOH0g/RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vs+/BZmL7UamNPgYanmsHjY9U7hZZmlgp1abYgxspuMfEbHmotQ8z5d86QoU7HV68
	 tUB6WbBOPWaPtqrKzH0nuAw5BaCb3OEy3LJat3ODsoqpTnNxe/lPenLM9x/zMlUL4/
	 Kf+hKNP/IzXmL6T0ocyj1DuwcopnqQzO7kyqU7II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 089/159] tls: dont rely on tx_work during send()
Date: Tue, 21 Oct 2025 21:51:06 +0200
Message-ID: <20251021195045.328687795@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 7f846c65ca11e63d2409868ff039081f80e42ae4 ]

With async crypto, we rely on tx_work to actually transmit records
once encryption completes. But while send() is running, both the
tx_lock and socket lock are held, so tx_work_handler cannot process
the queue of encrypted records, and simply reschedules itself. During
a large send(), this could last a long time, and use a lot of memory.

Transmit any pending encrypted records before restarting the main
loop of tls_sw_sendmsg_locked.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/8396631478f70454b44afb98352237d33f48d34d.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e3d852091e7a4..d171353699800 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1152,6 +1152,13 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 				} else if (ret != -EAGAIN)
 					goto send_end;
 			}
+
+			/* Transmit if any encryptions have completed */
+			if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+				cancel_delayed_work(&ctx->tx_work.work);
+				tls_tx_records(sk, msg->msg_flags);
+			}
+
 			continue;
 rollback_iter:
 			copied -= try_to_copy;
@@ -1207,6 +1214,12 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 					goto send_end;
 				}
 			}
+
+			/* Transmit if any encryptions have completed */
+			if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+				cancel_delayed_work(&ctx->tx_work.work);
+				tls_tx_records(sk, msg->msg_flags);
+			}
 		}
 
 		continue;
-- 
2.51.0



