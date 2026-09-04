Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A223D6664;
	Fri,  4 Sep 2026 05:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499288; cv=none; b=IGpnDxVyYyLhB800P2Ft4iBm9hqfw9AwtYFgbRHIZFZRS4ZkCxpOsoUc2BrFvTI+S9xYAj3xTSFzbNuXJUjJrjbuMPq4TPJP7LXGLE94CkTDiVkXj71hCpk3T8NklGFlRCNU+xzbb/dIC5Oq4tbDnW0p6VdgoOC0d4QhiEYZZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499288; c=relaxed/simple;
	bh=kGg/2187dmNkwRkeEV5zQSvWia1B70yP2mEt4ksSCKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4vNOGj6pi2+KNdUWfTwpsZLCjmnPewt68t7nBI0fR56KVW4UB4tRnXxyu4KOvpfm1R+3I7Q6f+WtsZcou16wdg1m/+TIfhTYXyJHi++kKgTmI/yMmLvseOKTNofmFxcScM2osbPpHCTWTrajYX9vjCqd/3xWxfeiGpi/AvTTrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CW9CYQsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CW9CYQsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DC81F00A3D;
	Fri,  4 Sep 2026 05:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499287;
	bh=76LCbaHDJrJuEzwRP9XoX6VFo4+QIFSKFKpWGYTbk2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CW9CYQsRZYdN/OiQiCrCwqyD91A9Z2TnMPmVMhsX9NVJpV9QB1ZqfqX8ji2H+uVn5
	 wPZ8KYFZFd9mkpKWVZP2EAVNeeBc7ybQNpW0cy3IZB/sKdxJ4wCW9wyZBBqznRQnho
	 342TnOYdi5sIdn6ODvbZOoVEmBhISvH8ttH1HZ8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Varu <harshitvaru666@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 365/713] mptcp: fix uninitialized local_id in syncookie MP_JOIN reconstruction
Date: Fri,  4 Sep 2026 06:55:33 +0200
Message-ID: <20260904045812.010608079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Varu <harshitvaru666@gmail.com>

commit b878dfdd12d7a5b8722a78d35e313506140ca3d9 upstream.

mptcp_token_join_cookie_init_state() restores remote_nonce, local_nonce,
backup, join_id, token and msk from the saved cookie entry when rebuilding
the request socket for a MP_JOIN 4th-ACK handled under SYN cookies, but it
does not restore local_id, even though the SYN path saved it.
subflow_ulp_clone() then reads that uninitialized field and stores it as
the joined subflow's address-ID. Because the request-sock slab is
SLAB_TYPESAFE_BY_RCU and not zeroed on allocation, the value is the stale
byte of a previously freed request socket, which an off-path peer can
influence by sending concurrent MP_JOIN SYNs. This corrupts the path
manager's id-based subflow bookkeeping for the connection.

Restore subflow_req->local_id from the cookie entry, as done for the other
fields.

Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Cc: stable@vger.kernel.org
Signed-off-by: Harshit Varu <harshitvaru666@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260815115205.197151-1-harshitvaru666@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/syncookies.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/syncookies.c
+++ b/net/mptcp/syncookies.c
@@ -118,6 +118,7 @@ bool mptcp_token_join_cookie_init_state(
 	subflow_req->local_nonce = e->local_nonce;
 	subflow_req->backup = e->backup;
 	subflow_req->remote_id = e->join_id;
+	subflow_req->local_id = e->local_id;
 	subflow_req->token = e->token;
 	subflow_req->msk = msk;
 	spin_unlock_bh(&join_entry_locks[i]);


