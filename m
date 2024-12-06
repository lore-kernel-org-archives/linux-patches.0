Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E83207658;
	Fri,  6 Dec 2024 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497955; cv=none; b=Cn3ADn/f19UUYsIfk8gCL5Z+CBnkJGS9m5xcyUBS/W7bPRsPVwLIGlkDa8gllawKw0DBIZ873YqLq03pja/2C+XTNnMcF0G3V2wAs7adZsR8h/hsBCERv2gzj6s06DehzguaBk+kIT7nPvZ9xCocX3bXLxj4sxgYNkh/4flpNHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497955; c=relaxed/simple;
	bh=RMQ/mdKd6J3CaDzV6Ij+G4NvxPjOiavp8M4h5+mSH9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jamceQCawO26+OXd2QizgwUToWeQ4d5xuqlKvcA6JS18GhkRCPkzxzdv0/1ARA8A61tu61xI6LQy8jw4ODTDg3nOe9yfsKQC1/qH+/abb9C5sMlJKLXObsvoOBAwGtHXeTqk4wkd08mtOlmAvIb/t8cl3R7aoIOUJhHJf3MCvWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Op8TlNDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Op8TlNDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C81BC4CED1;
	Fri,  6 Dec 2024 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497955;
	bh=RMQ/mdKd6J3CaDzV6Ij+G4NvxPjOiavp8M4h5+mSH9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Op8TlNDWwqlrtwB7Yj/dzAjYBgK7oHg9CLu3BB12rtgofpuq4lNHyyJOX1Lv1IMo5
	 P7mb14AMA7Trb6WnlQ0YgLJ+81KqY8g4eePIydDCBltg10LkRF5RaSZa6GnjicZ+f8
	 Ne1YDB7ixKI6hrcSPAOCJrJ0HMK9mfhz8rNkIzOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 442/676] gfs2: Dont set GLF_LOCK in gfs2_dispose_glock_lru
Date: Fri,  6 Dec 2024 15:34:21 +0100
Message-ID: <20241206143710.622713301@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 927cfc90d27cb7732a62464f95fd9aa7edfa9b70 ]

In gfs2_dispose_glock_lru(), we want to skip glocks which are in the
process of transitioning state (as indicated by the set GLF_LOCK flag),
but we we don't need to set that flag for requesting a state transition.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 1e86044402c4 ("gfs2: Remove and replace gfs2_glock_queue_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 20fb2296fe3e0..f38d8558f4c18 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2018,14 +2018,13 @@ __acquires(&lru_lock)
 			atomic_inc(&lru_count);
 			continue;
 		}
-		if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
+		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
 			spin_unlock(&gl->gl_lockref.lock);
 			goto add_back_to_lru;
 		}
 		gl->gl_lockref.count++;
 		if (demote_ok(gl))
 			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
-		WARN_ON(!test_and_clear_bit(GLF_LOCK, &gl->gl_flags));
 		__gfs2_glock_queue_work(gl, 0);
 		spin_unlock(&gl->gl_lockref.lock);
 		cond_resched_lock(&lru_lock);
-- 
2.43.0



