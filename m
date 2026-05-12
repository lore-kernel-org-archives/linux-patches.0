Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0E42D7BF;
	Tue, 12 May 2026 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608802; cv=none; b=qRsLBzv+gOnQ+2XYmjYtv0GjwML8VzdB+p/jW7tR0pCHxP8QoONwlaeJx5bbrzZd8qs263lriI8hPWtMxCj3av6uCjZgt5Ti735Kjpgva7bTuaGYGxV5AvCc/xxPbwZnlb0mi+8sA3eThC2EfE9xhk4nX18ViOCDcYxFPfRjtwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608802; c=relaxed/simple;
	bh=mBnW4M5NQIbu5+7dzk0qu2NRpexca1RRQbqNLhbVudw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcI5jdQGpgPFmYse4KqaiLVrsuW+zZUc/1fE+2YPm6t2F/lWwcPJWt7UjzE63N+I0l4SbGiILtUBoZ6fVAAWbA7wcTBqOKmhy9rbWX3rPahV59iHD4ZN0irUcbsRkmy6WEU98IBQQZEMUS4wlbZ7Fma2HUrsjQRgtAN0nIawbsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qoiDeep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qoiDeep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3D5C2BCB0;
	Tue, 12 May 2026 18:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608801;
	bh=mBnW4M5NQIbu5+7dzk0qu2NRpexca1RRQbqNLhbVudw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qoiDeepDhoGOUoMMc8OUuaW93zx9cst4jP8l+dw++XqM8KS22iI8NqrZgjbXBa3i
	 jPs1+kRleY2s4HyzkzXIoui5X7AynOnJwA8v+FCPl0gBxmCxrW3OVbSAYHwPuPuiVW
	 WhplrYFgViGIAvceTJ3+7TfhNWlt46GNLxh9UsLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 221/270] mptcp: pm: ADD_ADDR rtx: resched blocked ADD_ADDR quicker
Date: Tue, 12 May 2026 19:40:22 +0200
Message-ID: <20260512173943.098222361@linuxfoundation.org>
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


