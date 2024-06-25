Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D34146A67;
	Tue, 25 Jun 2024 09:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309494; cv=none; b=NbchoAfWz4YZOrHTPraPLRdBDPIiqZauZ17Pxwn0ithlYO03kW9hFwod+hXMnTk9tBHLAXV9jFSWnLNhrMwkFnebmoLRvy5wm7z31Q9RCh1/LHUrfUs2oP/8dWzyDYd6xvHjGI1KA/ON9HxrsE02cX7YUap1ncnQa3JwoDZPqGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309494; c=relaxed/simple;
	bh=CYGTJEbAu67Dw8JC7TKtNNFv3/9UUQ2Gm1hJBCPu7eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0B84B092qqVjzJg9VoVZo3G3U8+Pp1AEnMsSscuBfsiRYKjy2oR5frO9oG9MK8VAWTmeoWys+vwU8qG1cgwxHiwdH6TFiHZMxtAu53jah32kiHb6zEPWbI5OZgu9NXkzZy+c1yOMjB8zFILNC7VOQecXMy21N9/2xBU1V/Fk2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg9miytY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg9miytY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A84C32786;
	Tue, 25 Jun 2024 09:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309494;
	bh=CYGTJEbAu67Dw8JC7TKtNNFv3/9UUQ2Gm1hJBCPu7eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg9miytYNnRYBKeIUSq+rvmGvKT+DHuzTZwiXECOp5NySUDC82wnJr89D5pHGyRxS
	 lRHR70SVSFBaijUvpzYihHWEL8aATKk+pMt5gda8ud7X7tkrV9fqz+ZvvAXnASD27S
	 X7TboYezHViSkOs3oBKkB+i0UQzm0YjjrGeRSlzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/131] rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment
Date: Tue, 25 Jun 2024 11:32:39 +0200
Message-ID: <20240625085526.104025472@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 8b9b443fa860276822b25057cb3ff3b28734dec0 ]

The "pipe_count > RCU_TORTURE_PIPE_LEN" check has a comment saying "Should
not happen, but...".  This is only true when testing an RCU whose grace
periods are always long enough.  This commit therefore fixes this comment.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Closes: https://lore.kernel.org/lkml/CAHk-=wi7rJ-eGq+xaxVfzFEgbL9tdf6Kc8Z89rCpfcQOKm74Tw@mail.gmail.com/
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 503c2aa845a4a..2f6c52a863f2e 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1946,7 +1946,8 @@ static bool rcu_torture_one_read(struct torture_random_state *trsp, long myid)
 	preempt_disable();
 	pipe_count = READ_ONCE(p->rtort_pipe_count);
 	if (pipe_count > RCU_TORTURE_PIPE_LEN) {
-		/* Should not happen, but... */
+		// Should not happen in a correct RCU implementation,
+		// happens quite often for torture_type=busted.
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
 	completed = cur_ops->get_gp_seq();
-- 
2.43.0



