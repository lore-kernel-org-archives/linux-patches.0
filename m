Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F58226888;
	Mon,  2 Jun 2025 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873385; cv=none; b=BvL5blZwKNgrRZ+nRuaaukneNbYVqa6XTYJo+Us/3zr8zxrCJfewRv+qG5IVExCd3t2KSUpthmvUPyCnS0dbzwVwN2R5Kfps3iNdy3fvnglCTrwRwj6XI5Wqx/7TgtSYuZFxka44d19AoEhbl26qCp5aH+QHW3JIEWIWReh/D9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873385; c=relaxed/simple;
	bh=WV5BOK/WnqMAsq+3x9c4T4pbNbID/IFqmHdxakhTIRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWdXn/9HpQSy5dxso2RvljOwRCwrlNqYTqVf35uMdOlw7Cu1iW85Uv09iXll/sJZI+HnGd7fMkBZF4gt0Lj6E9udrPVEt4e7vBnAUvuVku2RUp0c0YeqS8RVZiuzfCckiyaSqJjk2htccoRXKUokp6ucvzLLwp9cmsXMlvCHYjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUaoqXnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUaoqXnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06380C4CEEB;
	Mon,  2 Jun 2025 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873384;
	bh=WV5BOK/WnqMAsq+3x9c4T4pbNbID/IFqmHdxakhTIRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUaoqXnxkvkPySZfaKZBlnBOsGuUo8jacLvbSBaw+xy/HWi56HfCD8UX2uEPpFyC/
	 bpd4HBTK9zjGtjjH4GgEpGJ9Wp4qo5X2cAYMn4EF3KK15bE3FgmV3DywPPbbXwME4Z
	 r4LfeT/ZamBvOd8VHjqOqQMhq9186wSxB58woIFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/444] gfs2: Check for empty queue in run_queue
Date: Mon,  2 Jun 2025 15:43:09 +0200
Message-ID: <20250602134345.966297297@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c0908a302102..687670075d225 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -853,11 +853,12 @@ static void run_queue(struct gfs2_glock *gl, const int nonblock)
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
@@ -869,18 +870,22 @@ __acquires(&gl->gl_lockref.lock)
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



