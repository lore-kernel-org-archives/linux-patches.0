Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA336B043;
	Tue, 12 May 2026 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609605; cv=none; b=GEtL89LvbZa6ZSq1pEyyi1OCUkt/JptuNzIObaOA9iWbszoYhviVtaHvOEbxbNTrqwTdu0Uow8j6CHC6wtp7HSGqyUq0nxX83zMZjpfFPo/xORNh9ShqK5BCd9t1CaKok0whWAmBOoEst04og/S74QDMVgWes/9silf7HL18X58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609605; c=relaxed/simple;
	bh=4eLS3Psc2czLJ73eCjaL6bofqbT+KyyU20s6xV8tr5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdL5o/Tyn197OyY/jbWw12zMVmjp0xrISUoCLbpyN5o/5ycFq8pS8ApMyzcD5lf3zOb8nf+N4QpIpmuHsxIzfMEluKyFRdEkeYin7s5fiyR0fiAP/ogPpx9aLKEWMlERcgZsZzbaB4V3U/l2sThNbkv2moRzHgc8MsvJWduC5dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFkUt5t2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFkUt5t2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B700FC2BCB0;
	Tue, 12 May 2026 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609605;
	bh=4eLS3Psc2czLJ73eCjaL6bofqbT+KyyU20s6xV8tr5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFkUt5t2EXg67zYj4c5rNyPJbWp28J1ANmuMRwQ/I5anuXJCA6zkg6mNAMpfrzvuC
	 vDPZHp2CI1GkMevENgwJW9ccB0Tgz/6+bZKBHsMFeYcqDGg3u300d3ndpYE2n7uG6m
	 hGqTE5UC2mwJWptauNvIvJYnJVLCHQ+bpwicHUfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 261/307] mptcp: pm: ADD_ADDR rtx: allow ID 0
Date: Tue, 12 May 2026 19:40:56 +0200
Message-ID: <20260512173945.636122599@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 03f324f3f1f7619a47b9c91282cb12775ab0a2f1 upstream.

ADD_ADDR can be sent for the ID 0, which corresponds to the local
address and port linked to the initial subflow.

Indeed, this address could be removed, and re-added later on, e.g. what
is done in the "delete re-add signal" MPTCP Join selftests. So no reason
to ignore it.

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-2-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -350,9 +350,6 @@ static void mptcp_pm_add_timer(struct ti
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
 		return;
 
-	if (!entry->addr.id)
-		return;
-
 	if (mptcp_pm_should_add_signal_addr(msk)) {
 		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
 		goto out;


