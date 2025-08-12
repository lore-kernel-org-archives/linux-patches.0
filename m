Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83EA2FF167;
	Tue, 12 Aug 2025 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023211; cv=none; b=Mvk2p7jkPPHAsrsQAqC4Qt6mak/Gk4sgtpqfSPLSngRF1SQpO8enohrRQFZQcIiwuUNehIep3b+LW/O8eXG7QTjWwo6waJc2E1OdoQUiLNzObxkB/H3iph7Z5ZfNOIzyn7vNHMe/4WItvubwkEIlUB9iQxZ9//Y5BDLv3j4tAUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023211; c=relaxed/simple;
	bh=EtSiShqkbYiteKX2uyCF4fV77+I9VT2wiZk092IxbEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPwYiNccr4iXK4TYC1oGnyoJU1csOwnTHqc+NwD8ya6YiA3ymwLMi3gJ7X3T7kjKWpkN3KsbQuFlbvhpbq+1NDr1vBaolYJ0nf/mRs1+QDGfQVp7CrnmixR8YawG1/MW7bPraPB3vtp6b2m+ecaRnIqm5UhzjxunlbmNgUoXOpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oqb5HVoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oqb5HVoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F846C4CEF0;
	Tue, 12 Aug 2025 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023211;
	bh=EtSiShqkbYiteKX2uyCF4fV77+I9VT2wiZk092IxbEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oqb5HVoEZ17PJx80vQKE1ZwLc3ybEwMShrao9+B50vIMOC0lGqNu0tHNraKI0wybM
	 01QctfEVBrEdIvVU1lLuq1zcJC3XW3LVAMXaa/bRlX3vi/j7QeKTFiYFYKcfYHhg8N
	 hfv9CnHwsmIa84PrdKHsLX5jjAPql/+yLQmK1BCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 014/627] gfs2: Minor do_xmote cancelation fix
Date: Tue, 12 Aug 2025 19:25:09 +0200
Message-ID: <20250812173419.863585799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 75bb2ddea9640b663e4b2eaa06e15196f6f11a95 ]

Commit 6cb3b1c2df87 changed how finish_xmote() clears the GLF_LOCK flag,
but it failed to adjust the equivalent code in do_xmote().  Fix that.

Fixes: 6cb3b1c2df87 ("gfs2: Fix additional unlikely request cancelation race")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ba25b884169e..ea96113edbe3 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -802,7 +802,8 @@ __acquires(&gl->gl_lockref.lock)
 			 * We skip telling dlm to do the locking, so we won't get a
 			 * reply that would otherwise clear GLF_LOCK. So we clear it here.
 			 */
-			clear_bit(GLF_LOCK, &gl->gl_flags);
+			if (!test_bit(GLF_CANCELING, &gl->gl_flags))
+				clear_bit(GLF_LOCK, &gl->gl_flags);
 			clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 			gfs2_glock_queue_work(gl, GL_GLOCK_DFT_HOLD);
 			return;
-- 
2.39.5



