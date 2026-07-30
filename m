Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D56175A6D;
	Thu, 30 Jul 2026 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423055; cv=none; b=g/aNY7r+F28RI+opEBMnZaHYduqDZ7H7Lhgp1ZhMjJf72/lwndEzIXc0UtHFnanYmXdTwlmRA1xQGKG4ETPa5r63DSlCRGmPwOR38yjjF52T/6grjdJ2dXID2v3SeKY35S7CfHjB6YxXu9R1UyStMTepv4VrSp/O8IS+DgDkX7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423055; c=relaxed/simple;
	bh=SbdJi1JZlIi9ckvvWPU+RwbswzW5cQim0vagzbCNz5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbZP7YmaopAA9zv1mrc6g7ZntlwJFl65Xek/lvS6ToUbqtdtfwwFx8ZXJOxm8H+iZq5N4C7bsDx5Lgfz64povfJggv7kcaqgzM2ZBSygG3bo4hO0M2JnKS9jEI9x7XTe2QPlbpenPGPf/ExiZKbTfAXV9gT5BQLUA3sAt6jy/lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzsOzO73; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzsOzO73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1DC1F000E9;
	Thu, 30 Jul 2026 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423054;
	bh=u042Uns5i7ox6Aj0muCrpUKyoZwZ387YzGJAvPZpbn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzsOzO73dRTdNHzxmoLP8EehGt9zEG5nzi9RKk+0yRvZnRkC2smGZZSz6pz4y8hnz
	 Cy46SOUPbmWBLBndrS2w7hmpADfOa1jIQKEYuqa7v9xyF44eZeOkKHkb9Yeu6LMi8+
	 x5NFk49it9Y2V6bkfsVewFLm86WIavA78FzHo5MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 606/744] mptcp: decrement subflows counter on failed passive join
Date: Thu, 30 Jul 2026 16:14:39 +0200
Message-ID: <20260730141457.155901763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3907,6 +3907,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	mptcp_data_unlock(parent);
 
 	if (!ret) {
+		mptcp_pm_close_subflow(msk);
 err_prohibited:
 		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
 		return false;


