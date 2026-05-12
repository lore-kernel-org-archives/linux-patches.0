Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95396343D9D;
	Tue, 12 May 2026 18:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609620; cv=none; b=KqtR3DBE6XJWVQSMw1bOwu4NXevUTc3SjbeBO7bqalqg1E3MDVM7nVycylSaCOYlvLKGLATKDajSFRZp7k0vKCWN4cp30Db/ofV4Kx4l20gWQaNcDzW1NJwlftuRuaZ/8r/vJpYEcsSOke8zkYHKFq5vduyTUqNfIkaPb92lc/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609620; c=relaxed/simple;
	bh=ghTIlc2akNG5ldbyLK0Wsr7nuRcRWm29YobqZJD+6KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+x1DxBbxIWLUJtFFGBApclih6co1ub3/3oB1ua9oGJlfXeyBSuljG+66pRGuu/4zi939/Cm8mUC0iSPEUX7tU1IvXfjb8fGwuibcyplRB1ZQBPMS80gogVfoZu6BBikE3xY5Q7JwoHGiqMabtbBDd/30UDSh7iO8/2nZslvFHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diXMO2SB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diXMO2SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1DDC2BCB0;
	Tue, 12 May 2026 18:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609620;
	bh=ghTIlc2akNG5ldbyLK0Wsr7nuRcRWm29YobqZJD+6KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diXMO2SBuZ8PEzo/VmI2YLXPANqDhgCbojxZmAgF8OaQbAxX6w0Es2iuyluY38Ezb
	 UM9UkIN+nr3aaGbrfH1mRnqZ8h7Ngo8ooGxnykqm68L/nUa6tIvrfD1NbhdyHtXVdc
	 LdsM7+xQM2p32UqA955LVzerbkTU1ycHNl+P0zQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 266/307] mptcp: pm: ADD_ADDR rtx: return early if no retrans
Date: Tue, 12 May 2026 19:41:01 +0200
Message-ID: <20260512173945.743006104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 62a9b19dce77e72426f049fb99b9d1d032b9a8ea upstream.

No need to iterate over all subflows if there is no retransmission
needed.

Exit early in this case then.

Fixes: 30549eebc4d8 ("mptcp: make ADD_ADDR retransmission timeout adaptive")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-8-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -311,6 +311,9 @@ static unsigned int mptcp_adjust_add_add
 	struct mptcp_subflow_context *subflow;
 	unsigned int max = 0, max_stale = 0;
 
+	if (!rto)
+		return 0;
+
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct inet_connection_sock *icsk = inet_csk(ssk);


