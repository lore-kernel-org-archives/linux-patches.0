Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E6A1C9DDF;
	Tue,  8 Oct 2024 13:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392476; cv=none; b=A+QKwL2yW3Qlgyye/oIRbCRgxP1XWcsQH01HPFWoBU2XKZPgngqvJ3Zwa0JnTNpGcKGqyy/HtKQj45mpYnzGWS9oMCgVvLSWVtQx1vXCRmTJA0MmFOE5Jm13mDg859NlQ59IF4RmBJ96bnhsrW3bpaNqAA1Bdw6gGK1M2yOXrgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392476; c=relaxed/simple;
	bh=FDP4Ud6k6C9DVIsStYhi/RcmYRX9LG/QGx7NhqkxUWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQZXj8+8dPAS/2P2TqL6ClFi1YzGQnmhLDQ8mNw6h5A1RXm1V+dWgrQioEI3RF6DCTNuuoDhElXO/25jqVe2BqAjEFF88Un6kM2ugJ8x1jPcwacYdQZ6mWhhaq6r21mSLAacI6I2/up3VxdvMwSyqlYvIjmFRD3r0CgvsSk3hNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5LY0sM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5LY0sM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF1BC4CEC7;
	Tue,  8 Oct 2024 13:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392476;
	bh=FDP4Ud6k6C9DVIsStYhi/RcmYRX9LG/QGx7NhqkxUWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5LY0sM4y/wwzuctGzCrhCOkRuouV0ybmDT6PUrShP9q3XnclxA8G8dJKX8XVmdzr
	 WKnNUyyk9IdvV1A+0CODQYAgus1dAtpBrfH94NqIsnPbU4SmHkcO1c3Xdf7Uopvk5/
	 btqxq5uUEB7kHrvr4Org3I4VpGtm+r44QxJbQOVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 6.11 427/558] sched/core: Add clearing of ->dl_server in put_prev_task_balance()
Date: Tue,  8 Oct 2024 14:07:37 +0200
Message-ID: <20241008115719.076636158@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Fernandes (Google) <joel@joelfernandes.org>

commit c245910049d04fbfa85bb2f5acd591c24e9907c7 upstream.

Paths using put_prev_task_balance() need to do a pick shortly
after. Make sure they also clear the ->dl_server on prev as a
part of that.

Fixes: 63ba8422f876 ("sched/deadline: Introduce deadline servers")
Signed-off-by: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/d184d554434bedbad0581cb34656582d78655150.1716811044.git.bristot@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5789,6 +5789,14 @@ static void put_prev_task_balance(struct
 #endif
 
 	put_prev_task(rq, prev);
+
+	/*
+	 * We've updated @prev and no longer need the server link, clear it.
+	 * Must be done before ->pick_next_task() because that can (re)set
+	 * ->dl_server.
+	 */
+	if (prev->dl_server)
+		prev->dl_server = NULL;
 }
 
 /*
@@ -5832,14 +5840,6 @@ __pick_next_task(struct rq *rq, struct t
 restart:
 	put_prev_task_balance(rq, prev, rf);
 
-	/*
-	 * We've updated @prev and no longer need the server link, clear it.
-	 * Must be done before ->pick_next_task() because that can (re)set
-	 * ->dl_server.
-	 */
-	if (prev->dl_server)
-		prev->dl_server = NULL;
-
 	for_each_class(class) {
 		p = class->pick_next_task(rq);
 		if (p)


