Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D4722128B;
	Tue, 26 Aug 2025 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216753; cv=none; b=fPlmP7LG8Oi3/EKA9mWbucrb1tqX83mIkfBPDz+tlg3MQioJ/OnOLdOA/bOJZH86KaDBKozRfgztCCnsxp+599SHAjBNyiWs0BA2pPfnhdbc0bsoM1NsVsuNZ+JJw1zg2/uJkb1hBdlBYk12X0DlpoSgSRYSRE5JN1Cx2W9x1Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216753; c=relaxed/simple;
	bh=AxINCqH/dX7+yBzGhjP+12JLXiLmh76WP9OMMsIrir4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3WEcq4UjyCPL1yXkkF0DWk2Px4fZ42VuHDa1VfU8HAyCM++qUyDuGe4jzobKYTgVt8fJYiTXvQahNDaHONNMQXpyOWFIBw5ha4ppl+w0vFe1Ay6aJ4Zu7W6YKV5JYqOf9hB+OejFG9d6Lekca0cw3eOGcHWPVuejW7QzVeFQNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2n/VyIpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2n/VyIpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A051C4CEF1;
	Tue, 26 Aug 2025 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216752;
	bh=AxINCqH/dX7+yBzGhjP+12JLXiLmh76WP9OMMsIrir4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2n/VyIpTi30REjBVbANuTFBdWQdooV1PMhBDZtpeAYpB0Cs4TL2R74ZN7S68XrD3U
	 k1jRHwXberZLRcdtYmzV+ey4sdhCy1iF1+kx8eyVwNa7PsGhRbSRhC/LQoaaTdXvSE
	 XFycb0euEc9Oc6yMa5LI7kGK+l5b6ZBdrRGSU+to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 503/644] sch_htb: make htb_qlen_notify() idempotent
Date: Tue, 26 Aug 2025 13:09:54 +0200
Message-ID: <20250826110958.963427907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 5ba8b837b522d7051ef81bacf3d95383ff8edce5 upstream.

htb_qlen_notify() always deactivates the HTB class and in fact could
trigger a warning if it is already deactivated. Therefore, it is not
idempotent and not friendly to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-2-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1506,6 +1506,8 @@ static void htb_qlen_notify(struct Qdisc
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 


