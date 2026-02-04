Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08FF2D879E;
	Wed,  4 Feb 2026 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219140; cv=none; b=a98TL3g+jl2l2xCXW+/fa5L/r4NnYKER6CgZewWxTOoTPya5VdN0D9CzFMiOk+6Z8Owvp9qx9jGhjvxKVugm4EFm7bkqOItX2G+04gXWjxuI1gI7JDhP97+45nrnMIprzo+X535FZoYLBlPL9un7zcbFA0h0RVdJMo6ST2D2S1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219140; c=relaxed/simple;
	bh=NLOJcV3bTmbfNZpp6FsC0HTlCiMEXeEV4E0qHO+lvtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVHKpoZGMRpB/jdY+F0DxyduMzNdvoBePCseS7C3YgSZmmXsdgPzOKunCSVXtiMBscjH33uQW/rLqan10mE2pnp8in8FEmneXCvFVL+3isripaNCcuka5ajSAR2TP1f4qdAi8+7FcsHHEOGFCHts1Of6h45hC/RaLeXhqFTUEuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZy8oJpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZy8oJpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4EEC19423;
	Wed,  4 Feb 2026 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219140;
	bh=NLOJcV3bTmbfNZpp6FsC0HTlCiMEXeEV4E0qHO+lvtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZy8oJpSC8VlHz2PAOn2GxiorqGA2l6s4Y5XrBdRPlWJoqbeypaq3Kr0qJD0eNXQg
	 f4e/JgtsqfcL5JlKjskBaYanBTlyjP75/phNyv9ZrsW/EOtwgu1jWgBNZBAt5vMCsW
	 Y+Ayo9Nn186XbqSqI5qplfGEeJzg75e0BmjObJV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 079/122] mptcp: only reset subflow errors when propagated
Date: Wed,  4 Feb 2026 15:41:01 +0100
Message-ID: <20260204143854.694661524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit dccf46179ddd6c04c14be8ed584dc54665f53f0e upstream.

Some subflow socket errors need to be reported to the MPTCP socket: the
initial subflow connect (MP_CAPABLE), and the ones from the fallback
sockets. The others are not propagated.

The issue is that sock_error() was used to retrieve the error, which was
also resetting the sk_err field. Because of that, when notifying the
userspace about subflow close events later on from the MPTCP worker, the
ssk->sk_err field was always 0.

Now, the error (sk_err) is only reset when propagating it to the msk.

Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260127-net-mptcp-dup-nl-events-v1-3-7f71e1bc4feb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -784,11 +784,8 @@ static bool __mptcp_ofo_queue(struct mpt
 
 static bool __mptcp_subflow_error_report(struct sock *sk, struct sock *ssk)
 {
-	int err = sock_error(ssk);
 	int ssk_state;
-
-	if (!err)
-		return false;
+	int err;
 
 	/* only propagate errors on fallen-back sockets or
 	 * on MPC connect
@@ -796,6 +793,10 @@ static bool __mptcp_subflow_error_report
 	if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(mptcp_sk(sk)))
 		return false;
 
+	err = sock_error(ssk);
+	if (!err)
+		return false;
+
 	/* We need to propagate only transition to CLOSE state.
 	 * Orphaned socket will see such state change via
 	 * subflow_sched_work_if_closed() and that path will properly


