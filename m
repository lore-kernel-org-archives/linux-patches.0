Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37E8757EA;
	Sat, 12 Sep 2026 19:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241411; cv=none; b=V6dp6Py4FvOJ3jUQ/lGrcu1dH7/QE+rmYCydRt8BwSQ8huZbrLg8b/7zMPBEmFKpAPCNkYNUCtkzK/bwcMlX5Hh96dkPgdHE58Zrn6uPFvf4wb+RPo3N3mzd0zHHmnfzzbMwX/WNcL6ZB5CI/ddECgR9KJcr3aHl0FmFRUOxuXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241411; c=relaxed/simple;
	bh=Vk2SMqPkTI5/Xem08YeBswbKGmj9l400D+UW+DnUqNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHR6arQCoxrfXYmJdhggJJC+J4riYgPKSiPNhoDPi+7I86Ax4AtHMeQVEeR8+Usu9GIhURVlwz4tdoe0uyiAWf3cPNTJYM3vgt8z0hCBzoOOO+jhb5xa3WaCnVrMS55BGXbWqUwupTtSNfwhUahsZNXsydsqMvXV3x+msUutDO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh7Q/qiv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh7Q/qiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8C1F000FF;
	Sat, 12 Sep 2026 19:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241410;
	bh=M2ouzhrigRo48OqfhnqRF0/kfn2D43juxidVi4uof90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh7Q/qiv0tCGwRD45EwSbjtCHVn8nJitMaYifLuTI98k4X/mPZIBTZkQM2y6xWTsZ
	 HfiereMhHlcBqii+/uU79y/NLkZMO+qDJS8dsoXYHP2xb4cCg2+9xBwFcCGTqQS4c7
	 xyAapUEzAjrmKcEbcsEy3Uiz9wSZDu5B+5DrWvJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 130/798] sctp: stop processing a packet once its association is deleted
Date: Sat, 12 Sep 2026 08:55:58 +0200
Message-ID: <20260912065519.954223509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1321,6 +1321,10 @@ static int sctp_cmd_interpreter(enum sct
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


