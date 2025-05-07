Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AF5214813;
	Wed,  7 May 2025 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645116; cv=none; b=SSSgZUwSITXou2AyA0l7EwTQSw/6Kg1FLH4C7kys/HQZCA0xXJsA3e3qOP1i2aVwVSPP9oZ1/1KevgBHCeZ/KBnDJvSQtUOtRxZqw9YtFBOCIxc14Sqe7ghJAUkZNmSPWqHWfCqkbGstsaIPR2UPjCzLnu1aJcKZhTJYDto2gdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645116; c=relaxed/simple;
	bh=K6+X0bw4JIUNNCVTPUYAzqlMDzWICCKLkoqAWSD/ZuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPiNal6AmCAdFeL0gVk25sLG8xrG2XrXrLpmvO2ChSworRv5XKLuZogVtPHsHnBPJbrRfPNkOCQfOQYzfm17bF/+GmQUgyArCp3923qk9u0yGLbYn6fRfIOxGqr2k4FxGYvjagOGzLskcRW4ocwAdLC0nBWcf2dPU0nz1tsRNoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCf+/abf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCf+/abf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3F8C4CEE2;
	Wed,  7 May 2025 19:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645115;
	bh=K6+X0bw4JIUNNCVTPUYAzqlMDzWICCKLkoqAWSD/ZuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCf+/abfR8X5O1yyY6QPcSP8ZzqwXGyQg4kdtDNDimSrR74XA2v+o3GYGYgJeu35n
	 bg9gym//0SO/EBy6/ittX7WtVJCB+IudqgqdVqMR2s7TTo627StoYAHh/U9lrPugSh
	 RNm5OAkjAjojfV6qdTKOLKng1zXH9LOg9FipZYuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 099/129] sch_htb: make htb_qlen_notify() idempotent
Date: Wed,  7 May 2025 20:40:35 +0200
Message-ID: <20250507183817.513245477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1485,6 +1485,8 @@ static void htb_qlen_notify(struct Qdisc
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 


