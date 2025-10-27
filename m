Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A3E18A6A5;
	Mon, 27 Oct 2025 19:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592328; cv=none; b=WpvhqFxby//T1NDN3TG0zg0XDGFNetNVSmITCvm4ZCDZaO/dtJZAjjWnA2kkwmSU2YGDMK14KeiXjrS1MghBRx64JpIHYYqcMrCFhrX1xPmXfBNBWQuC5h9Bdb+seXS3L8c0jRa86yw3i0LTW/rmkfPDNziKc09W5LXywXG2kiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592328; c=relaxed/simple;
	bh=u7UTFr/1aOeLMMKIBdAT7xVxFBgq6lC/UJHBDtN8tIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHNbh2gK86e0izr9jVwY2lB/94MP+ubMeomMdY1HlIqffjxDwOoMRAfV0XFeEsS08fuRxFXgiHWC5Im2BiESGF6xZjX3wrqqnhjZP37YChybIJFWHZY/DwTcZaEgkvmQ6sXcHdydk1KRJHAb71vjWYwN54YjDUqCYcNKd+Urj34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQmokOt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQmokOt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E3DC4CEF1;
	Mon, 27 Oct 2025 19:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592325;
	bh=u7UTFr/1aOeLMMKIBdAT7xVxFBgq6lC/UJHBDtN8tIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQmokOt7NC7zWjNcKVupAc6rYRFDesmFjNo4RoosrjJWfM1CQkszHqydciJ+BlCCe
	 0JRhr8da1/0n1XitZyZRZDh369kt+wXUFHSFj45kfx1LH7+qTgNzXpXOKPhf95wMLi
	 sTdNym0dnVbRrRMLiY7N/PvfqskBPPNN0BJBDRKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/157] tls: dont rely on tx_work during send()
Date: Mon, 27 Oct 2025 19:35:10 +0100
Message-ID: <20251027183502.608271558@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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
index baed07edc6395..e7f151c98eb93 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1109,6 +1109,13 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
@@ -1163,6 +1170,12 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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



