Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BD947ECFC;
	Thu, 20 Aug 2026 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244468; cv=none; b=sZOzAqnU1n3hdHDn2i0P18KCPY2p6rOZxiuZb2Rfuc/lHsRkrnv0LiezS99dO5DfkJEf11EkHJhL/FsEu+sdGfq6fLz9y4qhTyagYpj3yR28VRXXdnAuVRDezg/t08LeYqiLNl0WBmRW6FFFSL/HnVeb+nroeWL7qbNbEJ4j/NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244468; c=relaxed/simple;
	bh=f3PmONr7TY65A4u1wOitTzp29kOdIrzUnIbHj8KRhPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLlS+52KCfADcysfI4AzuKlR3mkApec8uFLSE0VI9FfkcvY5K9VKki9dKUBc3EJjHU92sUeTmv3VeQ4QlyMpUHtji1fpKkSO3tg+j2P7XnGdEDFBgjXXKbJegUpkgsmH3XBRuPIxsPF+Ry0BReyu4ufI3t91gu9ec5ydWA3mF9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azmZ8y7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azmZ8y7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9465A1F000E9;
	Thu, 20 Aug 2026 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244467;
	bh=G/g3GKLNLvSGgdGjvg6vRWW07Z51wyl0lUCdQ129uTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azmZ8y7HKWEF5VaVjyI1Fv9twhCaL+Jg7UjvGlDpy5slS0/qA1kg35BLzojvUGlUd
	 TJlKpWV6PIMkUzT309ZJ1G9IMNoSD8WwrMn44Zueb+CJF1/Vjr7i/vLk7srYlDAew7
	 fMblD4TfRoBiLU+lyP4dt27LaLf+Zp8ePyaMeUeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/235] mptcp: decrement subflows counter on failed passive join
Date: Thu, 20 Aug 2026 16:56:53 +0200
Message-ID: <20260820145221.884191848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 net/mptcp/protocol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2663,8 +2663,10 @@ bool mptcp_finish_join(struct sock *sk)
 	if (ret && !WARN_ON_ONCE(!list_empty(&subflow->node)))
 		list_add_tail(&subflow->node, &msk->join_list);
 	spin_unlock_bh(&msk->join_list_lock);
-	if (!ret)
+	if (!ret) {
+		mptcp_pm_close_subflow(msk);
 		return false;
+	}
 
 	/* attach to msk socket only after we are sure he will deal with us
 	 * at close time


