Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081232E7631;
	Sat, 12 Sep 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220564; cv=none; b=cqzrjAM+coPXA9Alu3mpnP3dQ1BUwQ0VurrGR2xUHN2dqezPAvZoP324ChLWW1UtbxB1VJrVJOQoWYr+HZ+p1BnOS0PRtsLivYIp3fPG8A3UPNvV4PNesVLTjqacqaayCChI1beJ1I+wLj6X7AWWEuUjsPs5AaYblULsxFvtN3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220564; c=relaxed/simple;
	bh=YV3pDWNCDSAU4uwaoXi6sdVrEiIYOdGC4L/vzbOOWfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGw7dXBsRm0kmYKP+msJLEU5Zekt+3MSqepenFp5K3N7+nAWMIhYgFS00dMjsGcscz5xKjqEZgdyz+Isxq3x+2gDHMrgJ84E8F+eE80vb8JyzKVp+k+4EDud4UOFLFSlG6WtL0zalOpPYmwc8E6mhK2tHSxhqILzhQ+Zt25XZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W08tdd37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W08tdd37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C746C1F000FF;
	Sat, 12 Sep 2026 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220562;
	bh=YXRz5ubMCyC5qdxzdf4zT/5Bh5B2kp64YElkWw1Bl1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W08tdd37shyx8qw8ROGymk8zVgt6aRtamNSxRFcms8YT2GV+6P8030H8N1Jo2qHor
	 CVpMdPNM32U6dw90QYFUnS88hzO/7GxQUiOEVF7CM+CfmMe9bszd84K2fSWOkAwgwF
	 C2bG2t5i5AEL0/1eWkXzUgNBt6qjblXDliQTQPo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0201/1424] sctp: stop processing a packet once its association is deleted
Date: Sat, 12 Sep 2026 08:43:53 +0200
Message-ID: <20260912065611.793988968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 47e15a8d12e366d0d261bcbc394394f44418938d upstream.

sctp_endpoint_bh_rcv() looks the association up only when chunk->asoc is
NULL, and caches the result in chunk->asoc and chunk->transport without
taking a reference.

A packet that matches no association is handed to the endpoint, so a peer
can bundle COOKIE ECHO, SHUTDOWN and SHUTDOWN ACK in one packet. The
COOKIE ECHO creates the association, the SHUTDOWN chunk caches it, and
with the outqueue empty the SHUTDOWN ACK reaches sctp_sf_do_9_2_final(),
so the association and its transports are freed.

The endpoint loop has no counterpart to the asoc->base.dead check in
sctp_assoc_bh_rcv(). The next chunk writes to last_time_heard in the freed
transport and is then passed to sctp_do_sm() with the freed association.
The transport is freed through RCU, so this needs the packet to come off
the socket backlog, where the loop runs in task context.

The endpoint loop cannot do the same check: it holds no reference on the
association, so reading asoc->base.dead would itself be a use-after-free.
Mark the packet for discard in the command interpreter, just before it
deletes the association. That is also before sctp_inq_free() releases the
chunk on the association receive path.

sctp_sf_do_5_2_4_dupcook() issues SCTP_CMD_DELETE_TCB for the temporary
association, while the one the packet belongs to stays alive. A restarting
peer can bundle DATA behind its COOKIE ECHO, so compare against
chunk->asoc and leave that case alone.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/an-YYtoqw1QpTXUL@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1326,6 +1326,10 @@ static int sctp_cmd_interpreter(enum sct
 				sctp_outq_uncork(&asoc->outqueue, gfp);
 				local_cork = 0;
 			}
+			/* No chunk left in this packet may use this asoc. */
+			if (event_type == SCTP_EVENT_T_CHUNK &&
+			    chunk->asoc == asoc)
+				chunk->pdiscard = 1;
 			/* Delete the current association.  */
 			sctp_cmd_delete_tcb(commands, asoc);
 			asoc = NULL;


