Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD531849EB;
	Wed,  3 Jul 2024 10:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004125; cv=none; b=MXeDEcFXqGDMc/GqkAyDA22tMs0EOqGl12ylzkkNMR4+idFXvPqUdXrUwp0Mj7WJOEzwd/77NFDOs8R1mpjbvPiCFdybHLhz2/LXnyTaAg7HR9jgtw/p1cdSLGnssmr2F9JJvjY0JbBnFuEgPtVqlO6kihVoUcP4U+RblJ9y0II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004125; c=relaxed/simple;
	bh=uEKcYxdyflaa4naqix7LKO9RQHYORdjoaATyZ1+ep1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwdWADuYfmGkXQpxbRutWME9MgNryA/nx/YZ/Fmyo9X95SWHL6A76kBaaOaS43TGpbJudcFnqQkZdZKDGlTkHCGguL/cmG0xru/ilmJiSkOJRrAh+159SAwNWynxvHv69yJyLfck0ghcV4+2bNLtuMg2hxhBHrdewruBY0HQ4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWBYHuf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWBYHuf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D9BC4AF0B;
	Wed,  3 Jul 2024 10:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004125;
	bh=uEKcYxdyflaa4naqix7LKO9RQHYORdjoaATyZ1+ep1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWBYHuf71NKMnHzHAgcgjfzJrI1q1EDsoVHW4kZDs5gklPCES70Qi9ScCDIUt/IMi
	 1BGaL0oC0jLoRQJiFaOC9kUMycCz1LSerpSEIudZYfDuP9zrbyM3ollx4M0NoamRtO
	 ysBGT7VJXgjydiuRGy0m2TiipJFiVE43ELtDwWtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/189] rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment
Date: Wed,  3 Jul 2024 12:39:10 +0200
Message-ID: <20240703102844.861121201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3c9feca1eab17..aef4d01c4f61e 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1291,7 +1291,8 @@ static bool rcu_torture_one_read(struct torture_random_state *trsp)
 	preempt_disable();
 	pipe_count = p->rtort_pipe_count;
 	if (pipe_count > RCU_TORTURE_PIPE_LEN) {
-		/* Should not happen, but... */
+		// Should not happen in a correct RCU implementation,
+		// happens quite often for torture_type=busted.
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
 	completed = cur_ops->get_gp_seq();
-- 
2.43.0



