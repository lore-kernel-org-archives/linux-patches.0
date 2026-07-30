Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865BD446BEE;
	Thu, 30 Jul 2026 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427804; cv=none; b=SK5KiS+H4XnHhm+aVZG9Yu1V4l9fdrrhcJy73grGiAqJsjYLiPcaSH+0ru0iUYB8/YVQ2NJXpOzmyt3vQGsJA19OTUSupYfY8i+7jixYVB0CCFT0Yq5thOWAL3BFopxRjZnRB72g0M15me7lk6frbXTUPU6O92GzVRIoLQW5Rz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427804; c=relaxed/simple;
	bh=n64mcx6JzSG7yZ1+AqyUAqJQo6QH5zhXz9d6AjoI6/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUXmsGulB8zFeNoNmZGCh+pcKjtVHKo+SwRptj1Hi+irBqW4XDjfTcoDJKLZCzXF04Mtoxl8UthBCRNkF+UZDhfEnhBO8HfhWVTnKXMg0YQC3+2jT6G6XfbZZCGL77VzA+r+m91AtInN/G/tN7s8pVEv3I96as+U4T5iIwObOYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZ02f5Xr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZ02f5Xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1916B1F000E9;
	Thu, 30 Jul 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427803;
	bh=AkyX9lMsuuAUeD43/J4qjKLiMh+AzeIZW4UOysaaQ8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZ02f5XrsL29KiKEeZDC33doHxGw6ifzq+CsK2GOeH4Pi22Xf6ZCjDNAUoDFDet3y
	 TetTHu/9dVm9pZahIZ2FAimUg5V/8Rfr2ItuJrOO0E84DnslH/vSfVpgkBRQR0QtMF
	 tkE8uTV+o3/LrZkttnE5GjbeUlg6lfQvZBCADBMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 299/484] mptcp: decrement subflows counter on failed passive join
Date: Thu, 30 Jul 2026 16:13:16 +0200
Message-ID: <20260730141429.986663449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

commit f3ca0ee2cc308e33896536789cbc5f3a12ca7b30 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3786,6 +3786,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	mptcp_data_unlock(parent);
 
 	if (!ret) {
+		mptcp_pm_close_subflow(msk);
 err_prohibited:
 		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
 		return false;


