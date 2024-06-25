Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EC41465A8;
	Tue, 25 Jun 2024 09:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308865; cv=none; b=AbJBr6HcJRijZoWXG3qQFb3k8lizCH7uOVelbunE7rDU8qceAD3++qBhWrNLyFq0dCNiDlG0tI74kDTjpm3hWU6zsGG0dBxjly9wegVpVEf0sjbXGSHKhwqSmPYa2ebXuucNPPxY56o5Y4wrg9Jlv84bw6xS4xYFzXPbjy4JLvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308865; c=relaxed/simple;
	bh=YY/qmzcJodCxknzsjov0Nlpt7dIFa6Q9d8s0rLMeZ38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7SVltcnMj2fc1ow4/3GA2Drgg64KhX+RnIa93KJMh4rKvw1+iEdyEROLdxytxS4FSSJowudvT597+uoHkjllMLTAleTOQpFA8oHauzxRm2m5SsqiF/aMAlx0JWGwumBKSQYptkV271/SpeXJwCVK9CLgCjbqNl156TG9YcnTgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfOzcMMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfOzcMMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD11C32781;
	Tue, 25 Jun 2024 09:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308865;
	bh=YY/qmzcJodCxknzsjov0Nlpt7dIFa6Q9d8s0rLMeZ38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfOzcMMcbC5Teyiulc5Txq8qNlv1meotnWFibrqCXlArg6VikRar+IlyhqqfM16vo
	 lYeg0VElGwI3B6qkDopAgYDWirH/GArQ02MgPuOaSS/xOotQMCK+nl6AiZxpB4/Z1Y
	 +oVFsUKNmBXvVngPXWo+iQRUNYE9lk/PrMm2uprU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/192] rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment
Date: Tue, 25 Jun 2024 11:31:18 +0200
Message-ID: <20240625085537.400187091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ade42d6a9d9b6..eb40c1f63a8b1 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1992,7 +1992,8 @@ static bool rcu_torture_one_read(struct torture_random_state *trsp, long myid)
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



