Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE21D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39BCC433C8;
	Wed,  4 Oct 2023 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442736;
	bh=skqfc3VETUbPS8f8EGvZRFuEDpouwRimtcyOX+dBsRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbsdzuzR6Y1I+HsjAO8y9gR17nJgi1vnx+4qS8NXZTnOlCTCPVGwGRz80lyipTn6a
	 7zweiflW9YsNxZHfuCUoI1dv/O0vJU2T3dKcnGzfMxKCf4pu40gYMSg9bB6N1Z0zy7
	 jD0jAoBXVdFN83UYAIbacauBBEkp1hixePRqDIEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/183] locking/seqlock: Do the lockdep annotation before locking in do_write_seqcount_begin_nested()
Date: Wed,  4 Oct 2023 19:54:54 +0200
Message-ID: <20231004175206.520620226@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 41b43b6c6e30a832c790b010a06772e793bca193 ]

It was brought up by Tetsuo that the following sequence:

   write_seqlock_irqsave()
   printk_deferred_enter()

could lead to a deadlock if the lockdep annotation within
write_seqlock_irqsave() triggers.

The problem is that the sequence counter is incremented before the lockdep
annotation is performed. The lockdep splat would then attempt to invoke
printk() but the reader side, of the same seqcount, could have a
tty_port::lock acquired waiting for the sequence number to become even again.

The other lockdep annotations come before the actual locking because "we
want to see the locking error before it happens". There is no reason why
seqcount should be different here.

Do the lockdep annotation first then perform the locking operation (the
sequence increment).

Fixes: 1ca7d67cf5d5a ("seqcount: Add lockdep functionality to seqcount/seqlock structures")
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230920104627._DTHgPyA@linutronix.de

Closes: https://lore.kernel.org/20230621130641.-5iueY1I@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seqlock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 37ded6b8fee61..2c5d0102315d2 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -516,8 +516,8 @@ do {									\
 
 static inline void do_write_seqcount_begin_nested(seqcount_t *s, int subclass)
 {
-	do_raw_write_seqcount_begin(s);
 	seqcount_acquire(&s->dep_map, subclass, 0, _RET_IP_);
+	do_raw_write_seqcount_begin(s);
 }
 
 /**
-- 
2.40.1



