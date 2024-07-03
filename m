Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D71F1836EF;
	Wed,  3 Jul 2024 10:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003571; cv=none; b=XGiWvk6bVG5Az8nc/Gm/AD2A5xIFkDsihFxcmLkmGSNOspiLby7ulJ2sTDlRADOrrLVcimL7VE+WL3c2LMP119SHQ1GahJl5flkOw189/3zQGysOeJxx94GlxkF11VvAOHCB+T6PH77jE+j6CMZSmpxNnP6yDACt6fBb0Z4jrYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003571; c=relaxed/simple;
	bh=WlBRH1OiZ0wALColTZy0oVFwGaGjAD71rXO3wb5KW4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsxJODul/JVJILKJTzLVhksXjK0VQpF03rACdfEDh6JRND7DeRmA7JFj5J2QpyRPAh1TGGS0reV3ojZ93Y04EIilheb6XyjEkzxzE7cWD4pgr/6016SBRh9jywnIUWnGGvNUvKTSvj6yBNif07LLqEVrGmPv3XjOv+sIYo28thI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bawANc96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bawANc96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9678C2BD10;
	Wed,  3 Jul 2024 10:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003571;
	bh=WlBRH1OiZ0wALColTZy0oVFwGaGjAD71rXO3wb5KW4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bawANc963Jn/yFWMM6cN+G4KJa6X6sNzF71hWG4nGlF+7+bnStfPHhjXEb9ySFsW5
	 nzcF5e8lBmlg9sHjQfHriMaRKj9RO79TOP+tTipc6bBvzEE4CxRgG972QQfRJ3688g
	 bg0CPZWFxA2566PU0Cp2gNtPR0mOObrLaiRcfQ2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/139] rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment
Date: Wed,  3 Jul 2024 12:39:18 +0200
Message-ID: <20240703102832.744026390@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0b7af7e2bcbb1..8986ef3a95888 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1334,7 +1334,8 @@ static bool rcu_torture_one_read(struct torture_random_state *trsp)
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



