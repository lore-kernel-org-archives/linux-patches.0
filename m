Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5154E1AC8BB;
	Thu, 15 Aug 2024 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730592; cv=none; b=B9es9mBjO0zHJcTrgekgbOteCxhEY5S1m+qbqNU6iL/SLPJx4CpK4Yz2w1r+UFoPlP1Sv+lnrlRpNG7gBEv8IG4pgeQmEJg0x8g/fobeP85fwqiMmfKFeI0Lhr/sKtYlqhCzsYEiI8VF0Xu9jo6nJmJ2AX87qFK6cB+1WOv/j9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730592; c=relaxed/simple;
	bh=XFMXoQLdaMmumu4Br9HlEyN3CDtbIAlEkLGn1ENkCI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4XEUHeOMDcWtRVsJtL2s5tWq1yc0shogheB0JKBsth0x3rKHueCyuct8Upvii5b8qdNbWk5WJGRucLBrq2d4bLbf0qZX8Fz4ZvpJ2MdYS0Lq9hh19sSq3nzznfB6fgx/qafltWDQ5el+jsa8qKjcPi4ERkmmOANp3WoNE1cIdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NCd8XTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NCd8XTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B169DC32786;
	Thu, 15 Aug 2024 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730592;
	bh=XFMXoQLdaMmumu4Br9HlEyN3CDtbIAlEkLGn1ENkCI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NCd8XTkRA8FrPKiFg8CqsTO6yyL07eYY2dbav1EzwNU7Jjbi0bhV3Ib1NTJzCCDX
	 WFaG7VeJD2Dnag9nSUrC961A8u5mulwSwPU1L2zL3OFqU8iIRS1Rzlm3K05e7KmvRg
	 Dgzn5CBJEYB8MBPHZo2BWNJgMy23uhT4bNYx2NzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 456/484] mptcp: pm: only set request_bkup flag when sending MP_PRIO
Date: Thu, 15 Aug 2024 15:25:14 +0200
Message-ID: <20240815131959.080875055@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 4258b94831bb7ff28ab80e3c8d94db37db930728 upstream.

The 'backup' flag from mptcp_subflow_context structure is supposed to be
set only when the other peer flagged a subflow as backup, not the
opposite.

Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in pm_netlink.c, because the commit f5360e9b314c ("mptcp:
  introduce and use mptcp_pm_send_ack()") is not in this version. This
  code is in mptcp_pm_nl_mp_prio_send_ack() instead of in a dedicated
  helper. The same modification can be applied there. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -699,7 +699,6 @@ int mptcp_pm_nl_mp_prio_send_ack(struct
 
 		if (subflow->backup != bkup)
 			msk->last_snd = NULL;
-		subflow->backup = bkup;
 		subflow->send_mp_prio = 1;
 		subflow->request_bkup = bkup;
 		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPPRIOTX);


