Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F13E16F84E;
	Wed,  3 Jul 2024 11:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004632; cv=none; b=OhdG6Ncb/YX0CgwWK4ZyfyL2l1OT65E0SxobD4/VvrvqwGgzAQeiG/8WnaWRibF9UGQebq7BdqaYLJiNa7HlfmUks+J/soeQtidkzP4fm7At6My9wpq4NUYG3trX61FdBTkq+rPKxooaWlix4oONMdOOS6MNqOKUujlDv4PL4h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004632; c=relaxed/simple;
	bh=rH9gVUj8+1oBU9kqShoXHJJXKhzHaHmKtUZG3yBVQRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiD3p6orZmnmSLYyKWTewTfZKmIkPNPg0cwwgV+Pg6ySc1CXpuoGxJfjt08kSdG5PXLVwSrn3czxHuOHsnX2QNeM34KJTiti7Xn4gwmW+tdhGA06KmEGioFrldBLXqnvpqjDnO0IXJceg9PmXPoroOa96B9O3YU+lxgFphMqDK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+8rgBBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+8rgBBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97213C4AF0C;
	Wed,  3 Jul 2024 11:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004632;
	bh=rH9gVUj8+1oBU9kqShoXHJJXKhzHaHmKtUZG3yBVQRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+8rgBBiq0KT5BM4/y75q9MRtzKSdwmoSgA2qKurK/Elq4jB22vFyrgQajW3exkNc
	 buHO07Q/vQJjrdGQcHtpX05v+2XLzwN35NA44wQQsw79OWkdjyfZ/41knivqT5zUBq
	 xXwob8erH/CUMlKs4wPYDwUeLZxjde4ZCLo6oynE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/290] rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment
Date: Wed,  3 Jul 2024 12:38:07 +0200
Message-ID: <20240703102908.199928190@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6c1aea48a79a1..c413eb4a95667 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1407,7 +1407,8 @@ static bool rcu_torture_one_read(struct torture_random_state *trsp)
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



