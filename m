Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC463F0A86;
	Mon, 17 Aug 2026 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979495; cv=none; b=P8etREm1duq1o2oMBLbu2JombVfct2EVxXVnI0YT78veOHl+Y9xIoXqxOo3DbnuXBYDNxUm6yq6cLZr+xkOtNDR0uomMKK7Z9BXpf0G00U2H2VaMV1urbV0bSJ5Bwt6sMij1Qxrjc4ty3HjSKmTDuHpBDFrlyo8EYj3q972gfSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979495; c=relaxed/simple;
	bh=a8a+6s1jtHbAqFo+/gXxL0G4pXv88QGmd13jYRuO/8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzEcxOf/SImhu0QRteEAW7xtIUPun1VvXTt7HUpLyumKXIE13lNYNCpIT6+Rwvg1fk/dWkFVgJJje4rQc/SrpaO+n1Po2KWRRwhr6zIukpC6Bm8mFPGVcyKwPqw9ahTPhQRw2OW2UNhiZOc5vUyIPwtEmMt0lk3C7ayXCOD4Al4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZ1wnm19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ1wnm19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631741F000E9;
	Mon, 17 Aug 2026 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979493;
	bh=qYmRCkptD8cWxueIq53Ml/4jgjMZGGIYgA5/Nz03+Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZ1wnm196awOH/CRcJMTPZK0XvUOrF2BoIYzGsPLr4mdmU5dmFKRdHeLJ8W+WZKx6
	 NLu39ApWbHCBJzIpq7rIJPIeZBu5bkWGPsRrgfs8maiuhr3rARh4wcW8hCeTy2pQbN
	 lS6U8nqroZtRrbBgTlZX4IdmsZlyiv3Cn2MKIcQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 246/609] mptcp: decrement subflows counter on failed passive join
Date: Mon, 17 Aug 2026 15:29:02 +0200
Message-ID: <20260817132552.316799498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -3795,6 +3795,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	mptcp_data_unlock(parent);
 
 	if (!ret) {
+		mptcp_pm_close_subflow(msk);
 err_prohibited:
 		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
 		return false;


