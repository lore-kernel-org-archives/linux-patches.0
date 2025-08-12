Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CD71C1AAA;
	Tue, 12 Aug 2025 19:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025372; cv=none; b=j/zHADNnIY37y9diKRcEgvwBXMUaiQeapKBv+cweifetAxPXm+nevlqBEix1996LpXjijmms8Z9nZJOVPeZZ8z4zPwf8ENQtDaDls9JMdM6hzlFDfoEDRAkZ2WESZsRzbIw4M0rchaqGOC1G8an4hcxy1te9iWZgOnf1k59Bsu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025372; c=relaxed/simple;
	bh=y+HOdaJrZlKBfcvTXknZxXYdSAs9JZTNLwGeS0x/QvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkxEx2uAqNjW+ezOWoWgOKU363Cm9HqVwkCuTr2VgrPQyHid/HGKwGymxexRxWYeYwiEJYKq8RuIXUWZTP+HweUShhXacDw1gc7v/P64DHFL/7eAzsr9IFHdmLSgKiB8qZSu/+aNE80XOB97ue0a68tfdMDMHseWu3VB0wBwzWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGnGt/Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGnGt/Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0C5C4CEF1;
	Tue, 12 Aug 2025 19:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025370;
	bh=y+HOdaJrZlKBfcvTXknZxXYdSAs9JZTNLwGeS0x/QvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGnGt/Ju8l5/yBogjExRLUyq7yrqPytcN9qLuleKOfJgH47Xt9LZ4LAG7EGfwZ79z
	 Vpe7h1Z6akyCUrqp4gFRzWS0JVYksamS/LK3Z/oZCB7RuSsyqxSOIKBTiqpG0h3d1y
	 RFZo31g2UorphTgBvIs/fH4SHn6ZmO1Vjp0Q0VXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 022/480] gfs2: Minor do_xmote cancelation fix
Date: Tue, 12 Aug 2025 19:43:50 +0200
Message-ID: <20250812174358.221259786@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



