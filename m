Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B4C3F4114;
	Wed, 20 May 2026 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296597; cv=none; b=Xc17bEKlS1+62HEi7gMG7imftZICPCC9vJd0VQ56Bgbc53jGs/WOO1EecupQDqCRBjvQOU4eMuht8C3PXAcBsSUDY8rlZUs3zpTXPSpnZQpA0NS+2Fsbd7kJAVoF8SCtPxBm+xME9YMkrVKCxlEniuK4IcVUJOOuSg/HdEX4kgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296597; c=relaxed/simple;
	bh=VI//Vnt5Yfd5xlk0gCn66FUnZeYbzWNQqyAW8O5jsoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWlJEPkfrD8pzjml59PdSRZL9nBKc1YuazWNBSXIpkC46Ja1T6pQHo5tAGthB/Vu73CaN9rTJtr+SDmHwsr6AItr4oxLlBYVmLUSzQPj/ASk03danvTQGE1mTPpkzbmg5dSYwBQCxeWnSocBNZViDVwn6yLDej+P+nxls3AMC9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiLUzYYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiLUzYYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D91F000E9;
	Wed, 20 May 2026 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296595;
	bh=/dcnPKswT5K/Ccxu/sXoRvqdjIViaFfQmwamXWBFXcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiLUzYYz3K99nY5l2vR78bIfADYVpx7oaT3zdF3K5wDcJ9a6AdkzRv5CfBk0pWLbU
	 vDecw0vRlV0SdMtiNw9l5h0/D9Nw5D0wLzzDIOaz0FC/odoYzdav7e9IsfXR7DGzeD
	 guA7ydunZkvQATDQKY5vdryZFBfK5kSVBlZ5cm4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0858/1146] tcp: send a challenge ACK on SEG.ACK > SND.NXT
Date: Wed, 20 May 2026 18:18:28 +0200
Message-ID: <20260520162207.657460616@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 42726ec644cbdde0035c3e0417fee8ed9547e120 ]

RFC 5961 Section 5.2 validates an incoming segment's ACK value
against the range [SND.UNA - MAX.SND.WND, SND.NXT] and states:

  "All incoming segments whose ACK value doesn't satisfy the above
   condition MUST be discarded and an ACK sent back."

Commit 354e4aa391ed ("tcp: RFC 5961 5.2 Blind Data Injection Attack
Mitigation") opted Linux into this mitigation and implements the
challenge ACK on the lower side (SEG.ACK < SND.UNA - MAX.SND.WND),
but the symmetric upper side (SEG.ACK > SND.NXT) still takes the
pre-RFC-5961 path and silently returns
SKB_DROP_REASON_TCP_ACK_UNSENT_DATA, even though RFC 793 Section 3.9
(now RFC 9293 Section 3.10.7.4) has always required:

  "If the ACK acknowledges something not yet sent (SEG.ACK > SND.NXT)
   then send an ACK, drop the segment, and return."

Complete the mitigation by sending a challenge ACK on that branch,
reusing the existing tcp_send_challenge_ack() path which already
enforces the per-socket RFC 5961 Section 7 rate limit via
__tcp_oow_rate_limited().  FLAG_NO_CHALLENGE_ACK is honoured for
symmetry with the lower-edge case.

Update the existing tcp_ts_recent_invalid_ack.pkt selftest, which
drives this exact path, to consume the new challenge ACK.

Fixes: 354e4aa391ed ("tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260422123605.320000-2-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c                                   | 10 +++++++---
 .../net/packetdrill/tcp_ts_recent_invalid_ack.pkt      |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c6c55c51a6409..cb4bcc5a85787 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4288,11 +4288,15 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		goto old_ack;
 	}
 
-	/* If the ack includes data we haven't sent yet, discard
-	 * this segment (RFC793 Section 3.9).
+	/* If the ack includes data we haven't sent yet, drop the
+	 * segment.  RFC 793 Section 3.9 and RFC 5961 Section 5.2
+	 * require us to send an ACK back in that case.
 	 */
-	if (after(ack, tp->snd_nxt))
+	if (after(ack, tp->snd_nxt)) {
+		if (!(flag & FLAG_NO_CHALLENGE_ACK))
+			tcp_send_challenge_ack(sk, false);
 		return -SKB_DROP_REASON_TCP_ACK_UNSENT_DATA;
+	}
 
 	if (after(ack, prior_snd_una)) {
 		flag |= FLAG_SND_UNA_ADVANCED;
diff --git a/tools/testing/selftests/net/packetdrill/tcp_ts_recent_invalid_ack.pkt b/tools/testing/selftests/net/packetdrill/tcp_ts_recent_invalid_ack.pkt
index 174ce9a1bfc07..ee6baf7c36cfa 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_ts_recent_invalid_ack.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_ts_recent_invalid_ack.pkt
@@ -19,7 +19,9 @@
 
 // bad packet with high tsval (its ACK sequence is above our sndnxt)
    +0 < F. 1:1(0) ack 9999 win 20000 <nop,nop,TS val 200000 ecr 100>
-
+// Challenge ACK for SEG.ACK > SND.NXT (RFC 5961 5.2 / RFC 793 3.9).
+// ecr=200 (not 200000) proves ts_recent was not updated from the bad packet.
+   +0 > . 1:1(0) ack 1 <nop,nop,TS val 200 ecr 200>
 
    +0 < . 1:1001(1000) ack 1 win 20000 <nop,nop,TS val 201 ecr 100>
    +0 > . 1:1(0) ack 1001 <nop,nop,TS val 200 ecr 201>
-- 
2.53.0



