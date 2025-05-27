Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B917C280A56;
	Tue, 27 May 2025 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364885; cv=none; b=Xi9V1zOxYR3dwxd+xw6mb9SqVt50ilGlxvUpyEgGrRcP79Itupjys7MyDIZ4SIDd5p8sG7rQbt+0zFTlBPZaHurV7oW0GYzhXeAhtgKgNRAvCbYbWEW7fYLHPiixrUyJev/YBYeW2kFtrGIV4CRM1JN9zzJBsvwdOcieulJqMkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364885; c=relaxed/simple;
	bh=PmjZcMbiKq//k0FJHikJZRAcHfA9lyX0LlQHTU9BV88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bft4DPiQqoPYcN5JThZF/6UOtu5sPnUwGImE9eCERtZOLvroGx/eqjRhSnYzOv7s+cftBS5vzlUFsgcPGX1NUcoQUYAkvEYzvkzWjT6oJGCtF6cIHHIIyS5fq3sFnBNaDEXL5WnxURsmFFjkTeX/xkh9GGX+6MfKbtjMS4074Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrZgg1Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrZgg1Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C055C4CEEF;
	Tue, 27 May 2025 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364885;
	bh=PmjZcMbiKq//k0FJHikJZRAcHfA9lyX0LlQHTU9BV88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrZgg1WznFgU+hHFn3nTUA1DM94UmC9MNyFOjXdgGfz4s9dWJBDeBSssg8dBdt8W+
	 MAj0z+UUWSbbjKmH53KYkyKnZni/ERr/13D4NTgg5IrWUXnZ1Li/A/ktiBcjclJ79j
	 5i85ltHaVqb/oemAQB2YcopIcJWa4Xna5za/8k/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/626] gfs2: Check for empty queue in run_queue
Date: Tue, 27 May 2025 18:21:30 +0200
Message-ID: <20250527162453.027971714@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit d838605fea6eabae3746a276fd448f6719eb3926 ]

In run_queue(), check if the queue of pending requests is empty instead
of blindly assuming that it won't be.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a51fe42732c4c..4f1eca99786b6 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -843,12 +843,13 @@ static void run_queue(struct gfs2_glock *gl, const int nonblock)
 __releases(&gl->gl_lockref.lock)
 __acquires(&gl->gl_lockref.lock)
 {
-	struct gfs2_holder *gh = NULL;
+	struct gfs2_holder *gh;
 
 	if (test_bit(GLF_LOCK, &gl->gl_flags))
 		return;
 	set_bit(GLF_LOCK, &gl->gl_flags);
 
+	/* While a demote is in progress, the GLF_LOCK flag must be set. */
 	GLOCK_BUG_ON(gl, test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags));
 
 	if (test_bit(GLF_DEMOTE, &gl->gl_flags) &&
@@ -860,18 +861,22 @@ __acquires(&gl->gl_lockref.lock)
 		set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 		GLOCK_BUG_ON(gl, gl->gl_demote_state == LM_ST_EXCLUSIVE);
 		gl->gl_target = gl->gl_demote_state;
+		do_xmote(gl, NULL, gl->gl_target);
+		return;
 	} else {
 		if (test_bit(GLF_DEMOTE, &gl->gl_flags))
 			gfs2_demote_wake(gl);
 		if (do_promote(gl))
 			goto out_unlock;
 		gh = find_first_waiter(gl);
+		if (!gh)
+			goto out_unlock;
 		gl->gl_target = gh->gh_state;
 		if (!(gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
 			do_error(gl, 0); /* Fail queued try locks */
+		do_xmote(gl, gh, gl->gl_target);
+		return;
 	}
-	do_xmote(gl, gh, gl->gl_target);
-	return;
 
 out_sched:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-- 
2.39.5



