Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842B3225785;
	Mon,  2 Jun 2025 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876833; cv=none; b=sx6ZGZscFsfgL+gQGz5h+fGy1EN8A3CtOHnXFOdIPMMlCD1NVMGhzt00e3iCj8PIlLqn4OpvPPF1bj/yc8PrVOxJuFshYqyRGvvL+eTKzO7QFmeO4aFe7D13NfpIG/oqu7BxSW9yeYcv++u5x27Pfgws1g5sXQ3VWJ8kXk6WkLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876833; c=relaxed/simple;
	bh=jeT9MJ7qDA83qy0PArQQ8IpMOB4r9fFqQJiRQYr/u3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBCL5sC1xQUKD/DsGkwY7ETrsSMSqbvP9F2WzYq+CdBxlLJB7482o9u9Pd5IkPg5DEfMnkV4Um0q7myE6fAC9QLWiGpHlQs/p0IFX38rD1+TrlzQyGbI4/l95l/XTzWUyyHNWPersRElYJYB5rAckRBL/d7U609T7yft9W3YQQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awGizd1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awGizd1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4D1C4CEEB;
	Mon,  2 Jun 2025 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876833;
	bh=jeT9MJ7qDA83qy0PArQQ8IpMOB4r9fFqQJiRQYr/u3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awGizd1KR1To1OkMvT2velogoOrzUWtdQRJuu1eGRO4UccGG16m80M3uB12F+lNud
	 /I8Dt+po/+/2EnX01x6Z3hUkNCvNiGbwbGmgv8xoi28uMpkR30EkgR7okh6gy5Nev1
	 SERwr5xz0coWLkM4GJpvHKZWqkKAWdf6YyFCj7ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/325] gfs2: Check for empty queue in run_queue
Date: Mon,  2 Jun 2025 15:46:05 +0200
Message-ID: <20250602134323.401315524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6ba8460f53318..428c1db295fa1 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -885,11 +885,12 @@ static void run_queue(struct gfs2_glock *gl, const int nonblock)
 __releases(&gl->gl_lockref.lock)
 __acquires(&gl->gl_lockref.lock)
 {
-	struct gfs2_holder *gh = NULL;
+	struct gfs2_holder *gh;
 
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags))
 		return;
 
+	/* While a demote is in progress, the GLF_LOCK flag must be set. */
 	GLOCK_BUG_ON(gl, test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags));
 
 	if (test_bit(GLF_DEMOTE, &gl->gl_flags) &&
@@ -901,18 +902,22 @@ __acquires(&gl->gl_lockref.lock)
 		set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 		GLOCK_BUG_ON(gl, gl->gl_demote_state == LM_ST_EXCLUSIVE);
 		gl->gl_target = gl->gl_demote_state;
+		do_xmote(gl, NULL, gl->gl_target);
+		return;
 	} else {
 		if (test_bit(GLF_DEMOTE, &gl->gl_flags))
 			gfs2_demote_wake(gl);
 		if (do_promote(gl) == 0)
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



