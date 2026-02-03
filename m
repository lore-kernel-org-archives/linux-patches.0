Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2653BFE5E;
	Tue,  3 Feb 2026 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770134404; cv=none; b=ORVGnMvrRmvf6QZC/sdSyOIWTq0HBQ04uEiAaIeTHpYfPELK5fVsm9xkzGhJlDowX/kN5rMOBI1hWXyEZl7/WTDwtaMfCQ6gkwo1DOigDjXR13yAm2YNb3nytKfP59N7RM30bQlTEMUDzXA+n3I4VL4/JXES4JP/TNcAL+gXDm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770134404; c=relaxed/simple;
	bh=lQsOTUMduDTmDGOcZDV9kazq+nu2hUBGi53sa4ZKfjc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=ACyfR4B2C1kQk007Geftljw0vvKt/xaQAhuYQWXWQXuTUaabYd8kf16vxH6vjSRT/O5imBYETbydPuUdOXPNmhOhur+gQHiAxwreqqA2BsgYS5GDs/Kma+ZZYpH9FAB/DHOGel2i+BkvOsmQl3fcSxvCdNJXNbPOXEMah/MS6Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usx3h4xU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usx3h4xU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE33C116D0;
	Tue,  3 Feb 2026 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770134403;
	bh=lQsOTUMduDTmDGOcZDV9kazq+nu2hUBGi53sa4ZKfjc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=usx3h4xUYXeHdwhDT7gfk/0vJLCoGeCESD/yxwxehOen62jzjO1cfeu9E5oxlSK2I
	 1tRWV7UlLD0eRod2SgwRKXRgMjQOBOzyFTljfXD4y2kDBz8NFQz31R13aV4o59SICw
	 8TNGjCwv5Qmn+VdkD/X7anDU+jGNoGuWToamqiuA=
Subject: Patch "sctp: linearize cloned gso packets in sctp_rcv" has been added to the 6.1-stable tree
To: 1468888505@139.com,davem@davemloft.net,edumazet@google.com,gregkh@linuxfoundation.org,kuba@kernel.org,lucien.xin@gmail.com,marcelo.leitner@gmail.com,nhorman@tuxdriver.com,pabeni@redhat.com,patches@lists.linux.dev,syzbot+70a42f45e76bede082be@syzkaller.appspotmail.com,syzbot+773e51afe420baaf0e2b@syzkaller.appspotmail.com,vyasevich@gmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 16:59:09 +0100
In-Reply-To: <20260130071038.3931297-1-1468888505@139.com>
Message-ID: <2026020309-lyrics-shed-2f77@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    sctp: linearize cloned gso packets in sctp_rcv

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     sctp-linearize-cloned-gso-packets-in-sctp_rcv.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-212845-greg=kroah.com@vger.kernel.org Fri Jan 30 08:11:03 2026
From: Li hongliang <1468888505@139.com>
Date: Fri, 30 Jan 2026 15:10:38 +0800
Subject: sctp: linearize cloned gso packets in sctp_rcv
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, lucien.xin@gmail.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <20260130071038.3931297-1-1468888505@139.com>

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit fd60d8a086191fe33c2d719732d2482052fa6805 ]

A cloned head skb still shares these frag skbs in fraglist with the
original head skb. It's not safe to access these frag skbs.

syzbot reported two use-of-uninitialized-memory bugs caused by this:

  BUG: KMSAN: uninit-value in sctp_inq_pop+0x15b7/0x1920 net/sctp/inqueue.c:211
   sctp_inq_pop+0x15b7/0x1920 net/sctp/inqueue.c:211
   sctp_assoc_bh_rcv+0x1a7/0xc50 net/sctp/associola.c:998
   sctp_inq_push+0x2ef/0x380 net/sctp/inqueue.c:88
   sctp_backlog_rcv+0x397/0xdb0 net/sctp/input.c:331
   sk_backlog_rcv+0x13b/0x420 include/net/sock.h:1122
   __release_sock+0x1da/0x330 net/core/sock.c:3106
   release_sock+0x6b/0x250 net/core/sock.c:3660
   sctp_wait_for_connect+0x487/0x820 net/sctp/socket.c:9360
   sctp_sendmsg_to_asoc+0x1ec1/0x1f00 net/sctp/socket.c:1885
   sctp_sendmsg+0x32b9/0x4a80 net/sctp/socket.c:2031
   inet_sendmsg+0x25a/0x280 net/ipv4/af_inet.c:851
   sock_sendmsg_nosec net/socket.c:718 [inline]

and

  BUG: KMSAN: uninit-value in sctp_assoc_bh_rcv+0x34e/0xbc0 net/sctp/associola.c:987
   sctp_assoc_bh_rcv+0x34e/0xbc0 net/sctp/associola.c:987
   sctp_inq_push+0x2a3/0x350 net/sctp/inqueue.c:88
   sctp_backlog_rcv+0x3c7/0xda0 net/sctp/input.c:331
   sk_backlog_rcv+0x142/0x420 include/net/sock.h:1148
   __release_sock+0x1d3/0x330 net/core/sock.c:3213
   release_sock+0x6b/0x270 net/core/sock.c:3767
   sctp_wait_for_connect+0x458/0x820 net/sctp/socket.c:9367
   sctp_sendmsg_to_asoc+0x223a/0x2260 net/sctp/socket.c:1886
   sctp_sendmsg+0x3910/0x49f0 net/sctp/socket.c:2032
   inet_sendmsg+0x269/0x2a0 net/ipv4/af_inet.c:851
   sock_sendmsg_nosec net/socket.c:712 [inline]

This patch fixes it by linearizing cloned gso packets in sctp_rcv().

Fixes: 90017accff61 ("sctp: Add GSO support")
Reported-by: syzbot+773e51afe420baaf0e2b@syzkaller.appspotmail.com
Reported-by: syzbot+70a42f45e76bede082be@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/dd7dc337b99876d4132d0961f776913719f7d225.1754595611.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This patch is lost/missing, as it has already been added
into stable branches less than and greater than 6.1. Previous patch in
https://lore.kernel.org/stable/20251022075549.195012-1-kovalev@altlinux.org/ is still not added.
So I resent it again.
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -114,7 +114,7 @@ int sctp_rcv(struct sk_buff *skb)
 	 * it's better to just linearize it otherwise crc computing
 	 * takes longer.
 	 */
-	if ((!is_gso && skb_linearize(skb)) ||
+	if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
 	    !pskb_may_pull(skb, sizeof(struct sctphdr)))
 		goto discard_it;
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/vhost-scsi-fix-handling-of-multiple-calls-to-vhost_scsi_set_endpoint.patch
queue-6.1/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.1/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.1/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.1/ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
queue-6.1/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
queue-6.1/sctp-linearize-cloned-gso-packets-in-sctp_rcv.patch
