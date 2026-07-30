Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CB043E4B5;
	Thu, 30 Jul 2026 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426336; cv=none; b=OQ7H7bxURAy92aNhclxy/94ehIwDWXbUCuuPstW87irkzUkB3iGS+vM5rDueS0Z9/5cslpYyIjgu0aIZnO27hH8/zJbAjPfWZQj0rPeyCU/aD6Cb+3aHlvoKtZk8+vRdYgJ+/96Y3OvsGjGfYbY3CdrK2dxIiuY6J7TOhpRpU/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426336; c=relaxed/simple;
	bh=MDSbE0VYJTHNEl2lt/bc3YcGaNe5IGVqU0BKWGdaz90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0LDrKUMvMOS0OcaTW/j86LUWuoDDg3rF9fvx56HoC3L+N+zh9RMW/X2LJClAWnNcgBRFJHxUG6KIgRbETU4ICVeLzWvLk2fr4HBGVatM7o2LKPQul/Mf37sVFSA/ARd9ETMMRZAgKPxy941g8sO3trSsXDGnAc+xaDqXOnRiXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHn629sr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHn629sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F4D1F000E9;
	Thu, 30 Jul 2026 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426335;
	bh=ctJ048HQo8bASWVUvXdByf1+LS5UF60n6cz4I9e7P3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHn629sr43JQ4j2v0lYdh8XX53wfATrTRtRHEaD9ER6aMLVZATp3q1UIfiPNoCH3P
	 H7Y76ITJMAjT2Qx7gs+NCkcepTxRR/BUChCJaqoBE7p7zQ/6ga6ofEJy6hMDH+uGMf
	 g5bCXoBSzMy5YXeQZlMllIDaM9Kb7k2n46cw8aWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 384/602] mptcp: decrement subflows counter on failed passive join
Date: Thu, 30 Jul 2026 16:12:56 +0200
Message-ID: <20260730141444.029216820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3825,6 +3825,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	mptcp_data_unlock(parent);
 
 	if (!ret) {
+		mptcp_pm_close_subflow(msk);
 err_prohibited:
 		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
 		return false;


