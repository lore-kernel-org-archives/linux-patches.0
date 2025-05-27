Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B291CEAC2;
	Tue, 27 May 2025 17:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366960; cv=none; b=XLmPZ3XXlOyL7DrDXhosOU9oLN6aVUTwSjs6XoRdaeL/wgy3hmy4Vdd6PLd7v/BXcnEOau4RFDZmZrj0wrX8Bv70m7H9lcyGHu/vVVY1g9O9477qc40jXhk2SqoAVqfHFZNrZGPfjSiY900CTe07v1Ap5NSocVuZXLoxEBlezkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366960; c=relaxed/simple;
	bh=X39bx7qFXvIBvfgY36Y7e/z7BAL9rfuVi5HF3zn08VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9o3HvxPNzZgJ7DfzCM5mWAd0LeDFlhK0RF2/5bIzQTtLperxyoROjKs/WRdpW38MfMfy8+6oI3hM3Y+j0kC5zFbDNfe6PVZnc/89uVNPz38zsettVlouwsqeEq+sozfIti7HQ+pS99f4Zt3+F6d63BmGnGvd7j83+5ZN14SKzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIVp/Ggz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIVp/Ggz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14A1C4CEE9;
	Tue, 27 May 2025 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366960;
	bh=X39bx7qFXvIBvfgY36Y7e/z7BAL9rfuVi5HF3zn08VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIVp/Ggzf74t4YWlaZh+FBz8wZ9ia8nheHQ/LDLFJf3MT4YVW0tFUQ5xm3gPShE8D
	 +bGbB5/q2AGC/cVVsQnHMDCEC0ME+pmyIaAY2h6xnu9WKQeorg2WZAF+SaAv3e+Gpa
	 BYXF/feFx3Kl5AwXpG2QPgxBZhH1eYdrCtXoNLsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 233/783] gfs2: Check for empty queue in run_queue
Date: Tue, 27 May 2025 18:20:30 +0200
Message-ID: <20250527162522.614559406@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 65c07aa957184..7f9cc7872214e 100644
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



