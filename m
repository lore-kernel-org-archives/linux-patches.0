Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB22690D5;
	Sat, 30 May 2026 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160627; cv=none; b=uSSp8zlJc29CMjsY9vDo0ktWL+q2sD3r+nkS1Y3kAbank9hpjNmI9ej1oW/YOEG1G5PksnHZnZstRFSB737vw+Ei/1W9rRpXxE92LpLgDISh49Z9oZqG6iEN84cVEXMvp51AvEzZ7Pf0SHLk1bkI6uTLd5h1UACpwI8Yx2q2ktY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160627; c=relaxed/simple;
	bh=4YC/to4BWP8nP5AHyApC4h7pqG/95qq4YpZ3e13lmm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEwpLl9O72PjpxdM/R30iA0skHlYoD6+FvQpqalqMW5p+yWSyeV31GEhMLi5c2bruBEZPJMCmsVLJPnLWFLrrPoZCtGKap9T8/pDaVhVDcspY2/FMp0w+Cirh2ciM31khDKZQU6INNoC9p9qA0lXyTajWrYPlhFUZSSjl+USlQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gu4p39Uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gu4p39Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08F21F00893;
	Sat, 30 May 2026 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160626;
	bh=bgCGHeDtp/xwGkx7kU1UEcBFb/3r6hSTQOlXQSGtsHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gu4p39UjBXxFyrBhmtx6VE1G210I7JUdolwzYpG03eN+2YyrKZ9H5M+kRp4vsKag4
	 k2ycwZZcy8UgLoIFIZ+lDh0CX47l3J70DdbtdQ2N+9VgOrgsqVusj3WNMuY/muErvv
	 37ZsryqyrImvrUgglkyrL5UNqvVMB115O7XMzZjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 371/969] mptcp: use MPJoinSynAckHMacFailure for SynAck HMAC failure
Date: Sat, 30 May 2026 17:58:15 +0200
Message-ID: <20260530160310.561340756@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -469,7 +469,7 @@ static void subflow_finish_connect(struc
 			 subflow->backup);
 
 		if (!subflow_thmac_valid(subflow)) {
-			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINACKMAC);
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKMAC);
 			subflow->reset_reason = MPTCP_RST_EMPTCP;
 			goto do_reset;
 		}


