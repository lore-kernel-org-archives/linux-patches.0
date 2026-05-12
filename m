Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7014C352F86;
	Tue, 12 May 2026 18:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609615; cv=none; b=UsRJsomY+zNssUdRRBqBJWgstxbBpPRb9Jlg/FVs9dGovQqtatx0HMP13krB03P/WtH/JzoZccm8VKfv687QUWOPYX6ra7Oc0su0QmcrFI+GRVUuL9VTi7i9cTu07vWdq5t6Uxq8ecpILjp4kLwCtGsWmttrRGkF8+So5CGg2/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609615; c=relaxed/simple;
	bh=7iMihikD4YJr+bg5GQhuEcn8mNteME1RJllMuIGc+UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIgGjeuYFBpMrNtx5vECnTs24Gab0qGGw/7qF/lELWi1owtkz/Kciy0OS1go0alP4q9zEAfoa0QCv/mBTd+5q1gJYv3m+/Yb5EDModg84mw25k/rkaNAgM8k66qNRGVsFDdtduPVgaWVmGolw8nn62Js4UYVliYr5a4OiLhlq+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gucUq92R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gucUq92R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068FEC2BCB0;
	Tue, 12 May 2026 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609615;
	bh=7iMihikD4YJr+bg5GQhuEcn8mNteME1RJllMuIGc+UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gucUq92RChp2yi+6knYuAj75yW/WuoT08ttUMtRR1/0U68hz8UzAS7LeiqMU0Borx
	 Rb17e5aWDNgYAsZ+VB2mECi+sDdekAjSgJ0iQV+psUMbcjWxvg8HdRmd051r2mGD+3
	 F4PMsxuARlGDTpcmdYMUcJyCx8fxoT7sbVpS3k2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 265/307] mptcp: pm: ADD_ADDR rtx: resched blocked ADD_ADDR quicker
Date: Tue, 12 May 2026 19:41:00 +0200
Message-ID: <20260512173945.722347417@linuxfoundation.org>
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

commit 3cf12492891c4b5ff54dda404a2de4ec54c9e1b5 upstream.

When an ADD_ADDR needs to be retransmitted and another one has already
been prepared -- e.g. multiple ADD_ADDRs have been sent in a row and
need to be retransmitted later -- this additional retransmission will
need to wait.

In this case, the timer was reset to TCP_RTO_MAX / 8, which is ~15
seconds. This delay is unnecessary long: it should just be rescheduled
at the next opportunity, e.g. after the retransmission timeout.

Without this modification, some issues can be seen from time to time in
the selftests when multiple ADD_ADDRs are sent, and the host takes time
to process them, e.g. the "signal addresses, ADD_ADDR timeout" MPTCP
Join selftest, especially with a debug kernel config.

Note that on older kernels, 'timeout' is not available. It should be
enough to replace it by one second (HZ).

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-6-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -355,13 +355,8 @@ static void mptcp_pm_add_timer(struct ti
 		goto out;
 	}
 
-	if (mptcp_pm_should_add_signal_addr(msk)) {
-		timeout = TCP_RTO_MAX / 8;
-		goto out;
-	}
-
 	timeout = mptcp_adjust_add_addr_timeout(msk);
-	if (!timeout)
+	if (!timeout || mptcp_pm_should_add_signal_addr(msk))
 		goto out;
 
 	spin_lock_bh(&msk->pm.lock);


