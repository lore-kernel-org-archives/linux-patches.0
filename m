Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782592C0261;
	Tue, 16 Jun 2026 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634967; cv=none; b=HlBm8MgXccMWRaTq+LNdslPo37fe4l+TgR1T5UBvCbbqhVLwCTYTWQrwI8BUn0inj7PsLBmOGru9Rdwi/KNwpUkuiGs6fbB6saHWKe4DxYcHB01NSHCUIBQq9TSLx4CF+JxwVDhTsfOtv8NDpfjUSDpBuFgeLMwJoRM9DSl8gvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634967; c=relaxed/simple;
	bh=EFAs9H4yzlnxMj9/By1HTaUBLl4E1Qo+eQlDhdtKwPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbWvVwUU7d6PubK+K+sO3AlpEhhB6kn0tyXzCrCIWCNz1VH+Qsg/fU0jbo6UCW8Fpf6sX/c2xdt4CDcWMwcO/PEhhk9RNWhuAVaUVD3MSFbVALioEwkEJtaqSkFdZRjTCOnKH1OzMuj6Qt89TtVFakWNpcJvbKybXu8jzBBnilI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1irMErG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1irMErG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B771F000E9;
	Tue, 16 Jun 2026 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634966;
	bh=0Jy3kKh0jko5JMrbAJYAKi+jCwdNElGMcBCA5uaocZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1irMErGOdyHZpsg21Ez6l5cX1gHgOpTaeOO4fUQfSymqtI37T/25fFQNodiY7ZmS
	 3fHE90nd2khTmrlwcaAIXzhosWitCcFC0j/U1DfrSVq2qClt4FqncwL2Gn/OxFbeqN
	 qU5jGGWLvI6q/Pxla7xve8cDoj0X3wxaysoiWZo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/411] mptcp: pm: ADD_ADDR rtx: resched blocked ADD_ADDR quicker
Date: Tue, 16 Jun 2026 20:29:30 +0530
Message-ID: <20260616145118.800259585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 3cf12492891c4b5ff54dda404a2de4ec54c9e1b5 ]

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
[ replaced `TCP_RTO_MAX / 8` with `HZ` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -338,7 +338,7 @@ static void mptcp_pm_add_timer(struct ti
 	}
 
 	if (mptcp_pm_should_add_signal_addr(msk)) {
-		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
+		sk_reset_timer(sk, timer, jiffies + HZ);
 		goto out;
 	}
 


