Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D30273D9F;
	Tue, 21 Oct 2025 19:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076493; cv=none; b=uz3629E7MOvnU1SbmTJ6+xn2wFmSq2bon9HZpw8I17Fyz/O5mvGMpdjkPaklEAVwMtUUPUTWlJGxzQ51TTnLqBeTVrzSDKcbEmfnw6CBDv85d3Tzb01vca1UC8pYHqVUq78vUSbrS+jVLzIF43PPfl7TYtyZxnCOqHGTye/eNpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076493; c=relaxed/simple;
	bh=02QWRn99byKxGzN9Elqa1ia6cmVU7yZTJ7Kt5zujAzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAQJM/FtTwUb+Fj75wBAjx25bJi2sP9xA5RhWb5943hC9h8F1xp6JwjUuOU7FrVte06w/06tPVr+Q1Bg2QH8qAs8L1tpnVv+i1HY0XF49wN0cCN9/7B/7zHowAki4rKR/XzBAXRpNtALpbkrQxvLo+hiUKMAPBD3pZ5yDLDLyjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VELrqZ4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VELrqZ4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FD6C4CEF5;
	Tue, 21 Oct 2025 19:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076492;
	bh=02QWRn99byKxGzN9Elqa1ia6cmVU7yZTJ7Kt5zujAzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VELrqZ4r3hd4T36i2peHhAlP2A37SI+pxGOBSV2cNOVRPX50bYlITYQIREGlnZb6n
	 13GhBfXz/KDXhWnjAokslS6E9UtACMAZU5S2k3obI7WGUWwvj5D6LQhIPjbyYBF0wF
	 nQKA2qGMVs4y7cMhdOHohAR8qBaSvibw0CtOxqzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/105] tls: dont rely on tx_work during send()
Date: Tue, 21 Oct 2025 21:50:58 +0200
Message-ID: <20251021195022.845688585@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6ea557ebab171..410e39e4b79fd 100644
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



