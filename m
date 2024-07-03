Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488871487CE;
	Wed,  3 Jul 2024 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005653; cv=none; b=E0x582w+fo3ddfJ4PdJybwlpkvMgAS1zvlasx3Jjn1orIgZAm8/YDV9sT9svh3c+Y1MdZrXwDv/u2k43iPi76yUBsR0b/IiDnnAZWIExEWUuwL4bQl2gmrZc+9IuJBafe/cxqOhIY1ygKkaEPwOWNrcDn2UkATPDCUnkvyB9zi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005653; c=relaxed/simple;
	bh=+y9akmc4mvyWCYdpQm7izcr/dTrRJ7C8/gVPoI9sVpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mkz4upxRZxSfNOfiL7N8m64iHfnUlRJrstNjvNixuX8AipFnzywZ/4XljHrRjLwWcZeGclTz3NBHYGnXJQEjCh6Dj3kuZZK49z5/Sz8xPAnMDCcJpAJutnU5UhYwoHV4BWDgClYrmtbDFuVRfFkUfz8kSCJbeKFnTkqSFj22/VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVPhz/HI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVPhz/HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E7CC32781;
	Wed,  3 Jul 2024 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005653;
	bh=+y9akmc4mvyWCYdpQm7izcr/dTrRJ7C8/gVPoI9sVpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVPhz/HIL6aS3sfg72DpC0qd2xEEKhakCPX8/SXf3+AEW9Pr64/bkEMPnbvzOoupf
	 ifFi9LnMreMEAd8+jkcLJIQXrju5Y26IRjs/VeoONkmdOdHXXY86OBwCQK2NK/7n7Q
	 IiTlsojh2HFN8V0a+qdW6sCnOEoxY4dqlg4R3l0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/356] rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment
Date: Wed,  3 Jul 2024 12:38:08 +0200
Message-ID: <20240703102918.853718897@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index d820ef615475b..82c6046db8a42 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1604,7 +1604,8 @@ static bool rcu_torture_one_read(struct torture_random_state *trsp, long myid)
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



