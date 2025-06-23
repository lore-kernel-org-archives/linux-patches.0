Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B26313A265;
	Mon, 23 Jun 2025 13:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684596; cv=none; b=BSEqjUzD/wrAK4CKzPDUXA3WHSrnafnM2IypT/k4QMaAOsCSrdFM4A8YZwBMbHd1WiE+7eIx7fiQgDJpuSBdPDBY0oYiSkFdn16N8lOxN8TV3198ZON0pCdqYkKFAyW64nKS/EXl93SmmYeAz0HxAtWJp7XwqHV/g0jyibZS4ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684596; c=relaxed/simple;
	bh=dy7YIIrLYlJUlgykp1AXC5PSrNCZUWsUxCtkqsNUeXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbeIlBbmMVQGgjbcp+RdQJ4pgVhb5ZcofRbPP3IgaSKPOOUG4rg64kBSmMeehsfuCa34/Ogx0fqdh/x/uEIUgFK3QY5Fh96Ja3Cl6gJNtxwHOxdk13dDLR06t38ejnUrA+jrhQVGqdS5ukCC3qWAZy+foxw5q6/t0/miuHR0i2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtsDVfNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtsDVfNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD209C4CEF0;
	Mon, 23 Jun 2025 13:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684596;
	bh=dy7YIIrLYlJUlgykp1AXC5PSrNCZUWsUxCtkqsNUeXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtsDVfNS7PQW5taCpcOpilESevz11ivUn7efEwWKY2nJBK2y69rHRKUwPb8Z0EEa0
	 DFS27ts04f8WAk6MZ3h5bWV9aM3KLyE568DwnTx5HkOQTtCbZulroIvVuBcZjSnDQn
	 eZahGwx2hk+5dBU66CQ9939zQDxSIvocED5uA3So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 128/592] net/sched: fix use-after-free in taprio_dev_notifier
Date: Mon, 23 Jun 2025 15:01:26 +0200
Message-ID: <20250623130703.315941024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit b160766e26d4e2e2d6fe2294e0b02f92baefcec5 upstream.

Since taprio’s taprio_dev_notifier() isn’t protected by an
RCU read-side critical section, a race with advance_sched()
can lead to a use-after-free.

Adding rcu_read_lock() inside taprio_dev_notifier() prevents this.

Fixes: fed87cc6718a ("net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/aEzIYYxt0is9upYG@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1328,13 +1328,15 @@ static int taprio_dev_notifier(struct no
 
 		stab = rtnl_dereference(q->root->stab);
 
-		oper = rtnl_dereference(q->oper_sched);
+		rcu_read_lock();
+		oper = rcu_dereference(q->oper_sched);
 		if (oper)
 			taprio_update_queue_max_sdu(q, oper, stab);
 
-		admin = rtnl_dereference(q->admin_sched);
+		admin = rcu_dereference(q->admin_sched);
 		if (admin)
 			taprio_update_queue_max_sdu(q, admin, stab);
+		rcu_read_unlock();
 
 		break;
 	}


