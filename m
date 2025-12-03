Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535C2328623;
	Wed,  3 Dec 2025 16:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778207; cv=none; b=Ojs9q2ZvqcEomy9ag0s4F6jr2ah9LoZi9yJ2vpWOeRjgAJTDjg7cM1qyHXUQTrvWzb/SLNs4O4aw8jhYHYfVDMW8D9IxbPQ2oxW4Hi2HV6si+AwvpTh4Cwhdpdjzw/ZF3QlueqKC+fi8smygD/F/Eb9dedUih6INRFmzu2MgVzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778207; c=relaxed/simple;
	bh=r2adOIODv89GoYW5mdkssJDn6snWoa81mhFVD1/fdmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfW3rmPuqggkvdbwiWzVO/09xENtsWO0w1PKULEvoB5eMz76NV47eet1kbwI8YDq/C2NYpELuw2SCD5qxhkz9It0UC2GB2s/5t/1Q2uXxzE94XUe4FF/HhlAk+PCjDDG70fXmS+YzdAWL3bvtPptP8ZTbRG6B5pjDgXTCKWs5tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRvI7V7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRvI7V7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410F6C4CEF5;
	Wed,  3 Dec 2025 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778205;
	bh=r2adOIODv89GoYW5mdkssJDn6snWoa81mhFVD1/fdmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRvI7V7clgyPV/UHonHjzG232TgWliAy2ANQCXMM91Ml8lwFxbPS2alG9aBUP5nNO
	 30RQPfa7Y46eenY+AcDyzzltfAPDv99otNaPKTLQZTi3EgGMYMH77M01eJXrc4SN3W
	 ImSSVn/KUZw5RW83Lx9dNcAnqgrIJzS4krDw7k6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f8c46c8b2b7f6e076e99@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/392] sctp: prevent possible shift-out-of-bounds in sctp_transport_update_rto
Date: Wed,  3 Dec 2025 16:26:32 +0100
Message-ID: <20251203152423.080795524@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1534ff77757e44bcc4b98d0196bc5c0052fce5fa ]

syzbot reported a possible shift-out-of-bounds [1]

Blamed commit added rto_alpha_max and rto_beta_max set to 1000.

It is unclear if some sctp users are setting very large rto_alpha
and/or rto_beta.

In order to prevent user regression, perform the test at run time.

Also add READ_ONCE() annotations as sysctl values can change under us.

[1]

UBSAN: shift-out-of-bounds in net/sctp/transport.c:509:41
shift exponent 64 is too large for 32-bit type 'unsigned int'
CPU: 0 UID: 0 PID: 16704 Comm: syz.2.2320 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:94 [inline]
  dump_stack_lvl+0x16c/0x1f0 lib/dump_stack.c:120
  ubsan_epilogue lib/ubsan.c:233 [inline]
  __ubsan_handle_shift_out_of_bounds+0x27f/0x420 lib/ubsan.c:494
  sctp_transport_update_rto.cold+0x1c/0x34b net/sctp/transport.c:509
  sctp_check_transmitted+0x11c4/0x1c30 net/sctp/outqueue.c:1502
  sctp_outq_sack+0x4ef/0x1b20 net/sctp/outqueue.c:1338
  sctp_cmd_process_sack net/sctp/sm_sideeffect.c:840 [inline]
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1372 [inline]

Fixes: b58537a1f562 ("net: sctp: fix permissions for rto_alpha and rto_beta knobs")
Reported-by: syzbot+f8c46c8b2b7f6e076e99@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/690c81ae.050a0220.3d0d33.014e.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251106111054.3288127-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/transport.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 687e6a43d049d..d279dda07b1ba 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -501,6 +501,7 @@ void sctp_transport_update_rto(struct sctp_transport *tp, __u32 rtt)
 
 	if (tp->rttvar || tp->srtt) {
 		struct net *net = tp->asoc->base.net;
+		unsigned int rto_beta, rto_alpha;
 		/* 6.3.1 C3) When a new RTT measurement R' is made, set
 		 * RTTVAR <- (1 - RTO.Beta) * RTTVAR + RTO.Beta * |SRTT - R'|
 		 * SRTT <- (1 - RTO.Alpha) * SRTT + RTO.Alpha * R'
@@ -512,10 +513,14 @@ void sctp_transport_update_rto(struct sctp_transport *tp, __u32 rtt)
 		 * For example, assuming the default value of RTO.Alpha of
 		 * 1/8, rto_alpha would be expressed as 3.
 		 */
-		tp->rttvar = tp->rttvar - (tp->rttvar >> net->sctp.rto_beta)
-			+ (((__u32)abs((__s64)tp->srtt - (__s64)rtt)) >> net->sctp.rto_beta);
-		tp->srtt = tp->srtt - (tp->srtt >> net->sctp.rto_alpha)
-			+ (rtt >> net->sctp.rto_alpha);
+		rto_beta = READ_ONCE(net->sctp.rto_beta);
+		if (rto_beta < 32)
+			tp->rttvar = tp->rttvar - (tp->rttvar >> rto_beta)
+				+ (((__u32)abs((__s64)tp->srtt - (__s64)rtt)) >> rto_beta);
+		rto_alpha = READ_ONCE(net->sctp.rto_alpha);
+		if (rto_alpha < 32)
+			tp->srtt = tp->srtt - (tp->srtt >> rto_alpha)
+				+ (rtt >> rto_alpha);
 	} else {
 		/* 6.3.1 C2) When the first RTT measurement R is made, set
 		 * SRTT <- R, RTTVAR <- R/2.
-- 
2.51.0



