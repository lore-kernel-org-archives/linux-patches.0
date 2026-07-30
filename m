Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA023B5DEE;
	Thu, 30 Jul 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424750; cv=none; b=fHrfjkb8pqI0kkJMG38DEsDg4mgL/4boAJujftXCY1tVHCTtNNCcfopseF8UA2sEodDyuD/MAJuiBRHAckROyFwLG2unGNXuqi1k9L0qEMJIyR2z6xLUgHwcwQDnQOrdJJ5XMRwXvYuAILRT9UmDSXB3FOLzCx4sM4zL4MtGB/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424750; c=relaxed/simple;
	bh=pvbAVG1Thnlx0fay+ZXPTd2yILK6FZ1t0SHJmbQPreE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=li5epsBL5KiD73Rm/SQWyMVi+qN2QgnF/8v2zmY/aaXHzV/AYbCHBmXtqW2rmHHYLpf0wyz2Vfj8QgqEUJvgalv3Me68k5a62J9tmPcp2T3HAXySpNaXeaN/WVKe7yyYhqAkZrgnIfetuItlko4YtAABknKKkmQDNlp7+wKzTQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLNzLJPV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLNzLJPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D4B1F00A3A;
	Thu, 30 Jul 2026 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424749;
	bh=Bbouk1p4iOXfbT1mUwJNQTIiI4L8bXAfrOuZqlZjPVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLNzLJPVeBzz7MQxX31+8MRKs/aO2HjHvUIRiuWyc9N6QcjO3mnBwAsUaN1WO0XrE
	 diVubER9bTLDZurzMagPauj5TCw5RO/qT6v0LAqwxKW1tOqUuMDEop4JOb9i5I+uYO
	 SHXM5g+TmjUFO0K8y6wPWBvDvkvJdu8APSDWyQyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 501/675] mptcp: decrement subflows counter on failed passive join
Date: Thu, 30 Jul 2026 16:13:51 +0200
Message-ID: <20260730141455.775567126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -3758,6 +3758,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	mptcp_data_unlock(parent);
 
 	if (!ret) {
+		mptcp_pm_close_subflow(msk);
 err_prohibited:
 		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
 		return false;


