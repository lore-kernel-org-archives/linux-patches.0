Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AA73EDE43;
	Tue, 12 May 2026 17:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608778; cv=none; b=uMg6cG4wsH9C8tjEZ9A5IbpChLEFClCeSBvs2/8OZDoGXp2M4cIOhzi3/wrxglrZZ2oPTv4ifjc4SryP1jQNyxPVSAGMXHD1YfWtWi0BaPdsa7xNhbdtnH11P/FioU/MVZziKBGYswKGLNaTZmnM8uipqaPwj+6sZulptEOrG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608778; c=relaxed/simple;
	bh=yfgMRPvqUQdJBpag187+Xap4cJLWHSNo7Xzqr2xZ/DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7VD1zBtuG+xhB/u4hO2SSVQ+H9SPWOQNKfYjLGTgeudm+znHFi5RYZAH7cUF0mn4CLEqU0sHsNPMkNBb8WOzyFDbNV5+r5fag76g6gVTR7Iur11M9F40iqUqLG3h5OzSKoKWnoSvyeP1/8g6jRpb1639eKDuENqfAHglI82QIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMf0JZFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMf0JZFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A9AC2BCB0;
	Tue, 12 May 2026 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608778;
	bh=yfgMRPvqUQdJBpag187+Xap4cJLWHSNo7Xzqr2xZ/DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMf0JZFIAoXcQk2jmnCPyWj/vxH2HTvFKs3BoB/fc4kHWn5Ta+hiLMAqHlYyNzr1l
	 NK5U+zlB4x9tBp5LslP8pU1d/jiS8TnCAr+y6wtMCPz16q6qm/J5hup0hWa+xK6o7r
	 0ePSIxWnq0duHQlFmjBk5nZQi1MTvpZv1LtdLB1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 209/270] mptcp: use MPJoinSynAckHMacFailure for SynAck HMAC failure
Date: Tue, 12 May 2026 19:40:10 +0200
Message-ID: <20260512173942.848068549@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -580,7 +580,7 @@ static void subflow_finish_connect(struc
 			 subflow->backup);
 
 		if (!subflow_thmac_valid(subflow)) {
-			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINACKMAC);
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKMAC);
 			subflow->reset_reason = MPTCP_RST_EMPTCP;
 			goto do_reset;
 		}


