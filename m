Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6561DE2CF;
	Tue,  8 Oct 2024 12:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390799; cv=none; b=dmflDmwZoMYzSlGMS+WTmrG5+cqkUXDw7CPFhe+ypu9StIozOdSZq64eV6CLzMqyX+kz8ThVslqlZGwQ+La9FHbctO+V5AYlsQIjxX7phJ9pmq6UrVcyKovE1HZmwWKCZ1c8LV5QubbfO+dow7M7Q6RPGiF5PtJhjSEj3c/77Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390799; c=relaxed/simple;
	bh=R4ehnuvZNoDtCDP7PEtVDXF9mPANOXBu3J8orJJgJ1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVcSJ7fbS6i14fQidwEO+0bwtTazi8Wr+b45o0V3hpnxEbo5/AkwiVfpn8TUPk8mIgbmgxmJ1T/FZdYF0wRwIhEoGZefCd0JAGLOuVq+RmojdUqigl82CoeQjj6tyND45PHb5Nb1fiQrEhFH9SXi8kidxqJjvj+j8RnhdbZOz5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A44f/Go6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A44f/Go6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70533C4CEC7;
	Tue,  8 Oct 2024 12:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390798;
	bh=R4ehnuvZNoDtCDP7PEtVDXF9mPANOXBu3J8orJJgJ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A44f/Go63M2lUNs/5zqT7yKU86j0ZRHGymTUj5oBTXAAsg95zROZ94uy2YsBevxPw
	 gbghp1rqXuXihd/8t7nMzBNtuZkmHMgrMMpuvbp+s5ETG6+swQKl8Xc+OctBVXDCY9
	 p451pB4XFBaceOL7fZbe9dTtRg185+2qENeMJ7qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 6.10 365/482] sched/core: Add clearing of ->dl_server in put_prev_task_balance()
Date: Tue,  8 Oct 2024 14:07:08 +0200
Message-ID: <20241008115702.786460051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6005,6 +6005,14 @@ static void put_prev_task_balance(struct
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
@@ -6048,14 +6056,6 @@ __pick_next_task(struct rq *rq, struct t
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


