Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B76F2459F3;
	Tue, 26 Aug 2025 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218080; cv=none; b=DekTS9F4/dMb53Kksl9ez87P+OBOrU+zib8O82PWdDmZpQQW9gDEwg8Hrqk61TvgtQ4M0i874FkiZ9x8/d4T31NH5iw8LYzNdPWZMynNHkHuJV6aIboUm5QKBMjIWX8w0lo/T8RXep5Ojonc06aET80+2Vgom2/5C0f9A6ZEIOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218080; c=relaxed/simple;
	bh=zcSuwowLJuQSfR4DfUJwN7froXm+6lpH7/Zu/D6MqMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtXd6PbZ7YllxDxVwn1DDR7LHDtAKXDv7XjZdlCDSELCndk8JAu3qMSMmVdQzmb3sdc9TusLl+6eJGFufK4fTncFAsAN/KddyovVgZT0zUALsMy9iPD+OPq2ghg3ReKKEp+pXNGs+0V1MCSF9UuMA07qPnwD7p46EVD2N0iXeDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVldsbr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVldsbr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6402C4CEF1;
	Tue, 26 Aug 2025 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218080;
	bh=zcSuwowLJuQSfR4DfUJwN7froXm+6lpH7/Zu/D6MqMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVldsbr+CjekXpf8O8ql3NpD7Gj8x6GAYw++m0YPaLeTqvtOnZqZShuT6ABSpsUU8
	 UG3YE8UTMPWhV+TXzdrz26W/gf062HrSVD36khA8df5aWHd6W/hJK6ApY5a1/93tUc
	 rALnIcqaLw0ckOnn9yEz+hOgtW6qIsZkNV1eMKnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.10 386/523] sch_htb: make htb_qlen_notify() idempotent
Date: Tue, 26 Aug 2025 13:09:56 +0200
Message-ID: <20250826110933.981148687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1173,6 +1173,8 @@ static void htb_qlen_notify(struct Qdisc
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 


