Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB48FFBEF;
	Tue, 25 Jun 2024 09:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308170; cv=none; b=HRYI153xAqRCX0aNgp8hpmSMXn9dmjMcwCl3ZA+Za2NtCpQt+8AqlXVwrXlXq/9hr8GBNuBQDsDhy/yVugarijl0NHULvulm/05zIganCouWmLLrUoOv5Bcrfny/1HJ/K3h8LTreX/90T7/BfC1Hro8UyM4pSsLMZRlzvAtKwdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308170; c=relaxed/simple;
	bh=dKLwkf2DI5b1aKUVnygWplLRCkRG21pn6FAVWmBK8d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElL5ptc3Q7ZKcNd+IXCh+1KKMk2g09bSjtviuzlQQ4j6zPA8lxMjiDPXavgHLNf8V6+fG42oOEYaKptu2prC5UEwgdKSE4LL9R1XSh0e4RdB0/+fTgtEOXT1XoCdzg5toc/7/vylHe0ZEHnM2+ChG/YEIw9+O+DF+ry0cM7y8N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGtApcy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGtApcy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C9BC32781;
	Tue, 25 Jun 2024 09:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308170;
	bh=dKLwkf2DI5b1aKUVnygWplLRCkRG21pn6FAVWmBK8d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGtApcy0d8Zi4XA0+ke0uTNlVULbdpLXNFaZ0MBSjTEkw7UBFPOBdCKfYPuBAk7ox
	 eHDgMPJpgTZ05mFArrC+EsJDFbRg1CF+cv+nXlhgCWoIPDllBhXm+ujGtcrSnybIat
	 K3aGDQuiR7OE1ZK7/GFJTjhkbC/PnfBtCPM6a7oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 006/250] rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment
Date: Tue, 25 Jun 2024 11:29:24 +0200
Message-ID: <20240625085548.286290469@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 45d6b4c3d199c..5dfea5c6de577 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1997,7 +1997,8 @@ static bool rcu_torture_one_read(struct torture_random_state *trsp, long myid)
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



