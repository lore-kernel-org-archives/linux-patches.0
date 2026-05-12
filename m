Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5E63EDE59;
	Tue, 12 May 2026 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608904; cv=none; b=di/bo9qZTTaoU444ESOVMlaf6XOjdk7sChLaDaAsbONk3tKzfX1cAmtmKbeRqsizftA5xKhFALISy4OJQW0leIRze4KXKqjKR5gL6BlfrAmUVOgWtUqP4iatKBYZ4VpAkSWf1LNJJkXe6il1JkT5BBFKHKje8vhSqD5SPkDUx7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608904; c=relaxed/simple;
	bh=WWOvr692mQzdAkiC4NbKbsBIcVwzpiHZLeCqhgIrEzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcxUsveu/qx1bRY+XOTJYL5xZhLCcJS10GoawwwUBVobV5oNkciyg2oh57tWAv2FMwORa/aZkQPCJRVOimOCMt3ZsvZgxB06vjEE6ESk0uQKYjmlnBH+b9iP8FP9wxDEvrXVcYdKdApUedMOPKV9MFtm52x6ScO8IUhua63hMF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCgkDpXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCgkDpXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E22C2BCB0;
	Tue, 12 May 2026 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608904;
	bh=WWOvr692mQzdAkiC4NbKbsBIcVwzpiHZLeCqhgIrEzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCgkDpXlr9HdMYqHdr+R5z3kG3WdqkuL9Tz7+JJq28X3xkA9n6wzmVwW8aCydI96k
	 mz5jYdHi/fc9xB+MoL8wE4IwiddzIepplaq9Du5Y3mayUqIKUy4NeCAuivMHRdf/53
	 9IZaGg/0Jhq/L/VRdjJbh23HyG5FlWApkCnoWt+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 219/270] mptcp: pm: ADD_ADDR rtx: always decrease sk refcount
Date: Tue, 12 May 2026 19:40:20 +0200
Message-ID: <20260512173943.056478076@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 9634cb35af17019baec21ca648516ce376fa10e6 upstream.

When an ADD_ADDR is retransmitted, the sk is held in sk_reset_timer().
It should then be released in all cases at the end.

Some (unlikely) checks were returning directly instead of calling
sock_put() to decrease the refcount. Jump to a new 'exit' label to call
__sock_put() (which will become sock_put() in the next commit) to fix
this potential leak.

While at it, drop the '!msk' check which cannot happen because it is
never reset, and explicitly mark the remaining one as "unlikely".

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-4-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -344,11 +344,8 @@ static void mptcp_pm_add_timer(struct ti
 
 	pr_debug("msk=%p\n", msk);
 
-	if (!msk)
-		return;
-
-	if (inet_sk_state_load(sk) == TCP_CLOSE)
-		return;
+	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
+		goto exit;
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
@@ -386,6 +383,7 @@ static void mptcp_pm_add_timer(struct ti
 
 out:
 	bh_unlock_sock(sk);
+exit:
 	__sock_put(sk);
 }
 


