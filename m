Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E46E46D0BD;
	Thu, 20 Aug 2026 16:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243867; cv=none; b=TiVclBJN+d7CFRYscjydzFcQf7Z+aqanvEInFrhb7HD8GNAYv0ox9SoZS7N2kD36dzR5upTGlxfjhUKwH0eOpBumcHmm+uJ06akQKp+esdPfUQVWCg1sKKueWQbsRrcEKmgPkCdcA9dsplj9o1J4GSSsNe3BxbF2PwvC/YI4WnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243867; c=relaxed/simple;
	bh=OBVgQf20GQalMg/cWXB0vuP8LnkFgExSi5abHQsFPXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWB2OKDrUZ43BQZKXJqwFL5biSEm3zKrVlCcmQAuF9bbHyjiscBZT9qgN2nF/5EeUNQsXkFcQhct7Y96AXl+PSNwxJugrQCemOcPU2/WvX5llfze0T5s8WNLDhGz5m8Ilr3o2e3NlJ0GHiP8myBaAwOHe3nhG+iXI0bxGD8lH7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEyIx0SL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEyIx0SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC07A1F000E9;
	Thu, 20 Aug 2026 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243866;
	bh=4dkEjcglxn3SGyLTebPFrGXis1NhljxYZ1dhVgTufU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEyIx0SLleCfY+yx8+eE9y118+iOogF8qcAK6/rsySNu7CgypfXZLGgdPl+4qSvgD
	 6NjdsrEz7dR9ePwyPWoByQRJONZDAXhUz788cr6T+WPz0gaez9Joj+ToHVVN3Ukc6Q
	 reEtaqlLqEhpwre3fLUxJrUug/vXUNqu3RRLqsAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/272] mptcp: decrement subflows counter on failed passive join
Date: Thu, 20 Aug 2026 16:56:28 +0200
Message-ID: <20260820145237.613154657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit f3ca0ee2cc308e33896536789cbc5f3a12ca7b30 ]

mptcp_pm_allow_new_subflow() increments extra_subflows before
__mptcp_finish_join() on the passive MP_JOIN path.

In case of race conditions, the subflow is dropped without calling
mptcp_close_ssk(), so the counter is not rolled back.

Call mptcp_pm_close_subflow() when the join completion fails to
decrement the subflows counter.

Fixes: 10f6d46c943d ("mptcp: fix race between MP_JOIN and close")
Cc: stable@vger.kernel.org
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260722-net-mptcp-misc-fixes-7-2-rc5-v1-1-6fb595bc86ef@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3361,6 +3361,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	mptcp_data_unlock(parent);
 
 	if (!ret) {
+		mptcp_pm_close_subflow(msk);
 err_prohibited:
 		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
 		return false;


