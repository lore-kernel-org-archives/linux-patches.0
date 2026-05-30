Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF70349CCF;
	Sat, 30 May 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163736; cv=none; b=iDdFf1pZTzvVtyPUGPLpI4LfW+AK4NCYh9zXkZZxeHPbfYKRfcHCBnhSVeNzMIDeKc+E4D0eKvq8JNPl85QcPeHDxncqsQof04/Y2TIC0L7vBEZw/WQsBwBpX6ZSk4yb0tD5WZ5nItn+vuKrysP0dLxT4wC7p0Y+aPKKBbwbPEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163736; c=relaxed/simple;
	bh=1nDQn01LXTR8AGIVJ31r4EihXjkSHJ2Z6nv1h9Ek0bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1iI/1Run5v4UcWCDHatjw81Z6z6wuKQbgV8XMmejKTb9RRkZ1Vwit7XI7/ort10nhke69HWK+j9nuTF155yyxbTdSVkBwJs+co1UzIJUonC5FnNbj5ymJUkhAw8cCSnYDJjNdpZS44uUMU9vOS1AuZ6gEPV4bjBUH9F65PVJFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9hT+ydL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9hT+ydL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2DB1F00893;
	Sat, 30 May 2026 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163734;
	bh=Zhw8LC1ilvbqPHzP/FqowFoUM3gQMWXJ8ykFeDsfYoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9hT+ydLtq8L8bjFfLWnnCTQERlBu5bChtK/Y6AT9FbBfIe2O96lKQ00IJFg/cuFI
	 Q1SfnjE0EBmVBny6mOXGH07/GCesYnvQUoYcK7y4Ry14bO3h3oBjb7Wn/IsWy1yztO
	 +gxWz4IH7szVRomEH8K/YmSvOYiljAi+qaB0gSP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 346/776] mptcp: use MPJoinSynAckHMacFailure for SynAck HMAC failure
Date: Sat, 30 May 2026 18:01:00 +0200
Message-ID: <20260530160249.520874852@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

commit c4a99a921949cddc590b22bb14eeb23dffcc3ba6 upstream.

In subflow_finish_connect(), HMAC validation of the server's HMAC
in SYN/ACK + MP_JOIN increments MPTCP_MIB_JOINACKMAC ("HMAC was
wrong on ACK + MP_JOIN") on failure. The function processes the
SYN/ACK, not the ACK; the matching MPTCP_MIB_JOINSYNACKMAC counter
("HMAC was wrong on SYN/ACK + MP_JOIN") exists but is not
incremented anywhere in the tree.

The mirror site on the server, subflow_syn_recv_sock(), already
uses JOINACKMAC correctly for ACK HMAC failure. Use JOINSYNACKMAC
at the SYN/ACK validation site so each counter reflects the packet
whose HMAC actually failed.

Suggested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Fixes: fc518953bc9c ("mptcp: add and use MIB counter infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260501-net-mptcp-misc-fixes-7-1-rc3-v1-1-b70118df778e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -460,7 +460,7 @@ static void subflow_finish_connect(struc
 			 subflow->backup);
 
 		if (!subflow_thmac_valid(subflow)) {
-			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINACKMAC);
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKMAC);
 			subflow->reset_reason = MPTCP_RST_EMPTCP;
 			goto do_reset;
 		}


