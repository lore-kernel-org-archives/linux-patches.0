Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2B5340279;
	Wed,  3 Dec 2025 16:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780077; cv=none; b=bfNRH/i/iX6W5J62dJ3uou7UcD0Oc+OaPLbMpVdAbWWRIV1wJFzXrfD8WSYWo+rmfpTxjPDEsdBgsTd5Hn150NmTlyqAzDCBfJl9nto1P3ACPp6daZhrjPRmFNiCPkcj+0KhjnuM7yl6mI2s8xC19FQ8QDdy182UHWxqBYkbzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780077; c=relaxed/simple;
	bh=Oft86EjKIfjdQCLRHvFsX2r44NjVGtjpEpAquGyeJtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHyMffO9aXyzHPuNcuGXmxryvcJz/TyOnynwSZE6Vo5kcf8dYW0jH9068liPEmkliSEcb0ZpqDqjlz7jPUoRP1Z6F6yn+OXBUlHnlnag6Tq+XbN0b38c1DTNY0hUCBGw9aJ/uAfcMbU9FMedzR4s0MG3U10EArITHaGEhmxfjgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMiwTzWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMiwTzWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE631C4CEF5;
	Wed,  3 Dec 2025 16:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780077;
	bh=Oft86EjKIfjdQCLRHvFsX2r44NjVGtjpEpAquGyeJtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMiwTzWEs0Ey+lgT/i+ytvp4fWY0TfkT+DQfcz19J6CAcL0fVFppDu/QBWKqmWfLr
	 A5+urVyys1zaOxUQBmxqWLzfDExSW7WZL6aK/CIQhkdc/xsRA/YMM6waUKi8zXTTf9
	 II4DR8erHk8yRwhLFLg5TEaUwu9diB9mZMWH97uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 448/568] mptcp: do not fallback when OoO is present
Date: Wed,  3 Dec 2025 16:27:30 +0100
Message-ID: <20251203152457.116627423@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 1bba3f219c5e8c29e63afa3c1fc24f875ebec119 upstream.

In case of DSS corruption, the MPTCP protocol tries to avoid the subflow
reset if fallback is possible. Such corruptions happen in the receive
path; to ensure fallback is possible the stack additionally needs to
check for OoO data, otherwise the fallback will break the data stream.

Fixes: e32d262c89e2 ("mptcp: handle consistently DSS corruption")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/598
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-4-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -911,6 +911,13 @@ static bool __mptcp_finish_join(struct m
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
+	/* The caller possibly is not holding the msk socket lock, but
+	 * in the fallback case only the current subflow is touching
+	 * the OoO queue.
+	 */
+	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
+		return false;
+
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_subflows) {
 		spin_unlock_bh(&msk->fallback_lock);


