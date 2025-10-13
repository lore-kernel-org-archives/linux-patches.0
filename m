Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7221D3081D4;
	Mon, 13 Oct 2025 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367491; cv=none; b=H6OqtzYtjA2DHves6edYMk8iuYGTzSmpC0A7U4ptwP+uYIchtmUuMc1a20BzVEwg7myPwejCDIp6zc8Bqd9QJHyqCQPDuiEGQJ60eWPGppgLXcesNx7Zma/ujkpCQXNbnI3u3my0NGTROZocuN39dU0RrbO4duDuFRsxQKRTkcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367491; c=relaxed/simple;
	bh=4j9BRhMW9uF4Xk5qLOopVfG7Sad98plYXTCUXLGmkxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw2FhK7P1x1reFSWkjLiX4zo3r0W5KEraaUq1tbvbzkfuE6LQQHKNP9O1ZMIOMn6m+XGuivyAa3FzOeNVu6rFWW0gMLY8GJ32MAIwzoL80qk6365iCwI6EgoMmp3SnApAYAQlHkS7fJHL9JG/YCDcnPqVAXKXvP07VOsXHGC0nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW/iLWhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW/iLWhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9AEC4CEE7;
	Mon, 13 Oct 2025 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367491;
	bh=4j9BRhMW9uF4Xk5qLOopVfG7Sad98plYXTCUXLGmkxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qW/iLWhu0KcMkj3Diasrrif0dnqdXi85yHsc+q+M5o7utHLbnhpnUYdudFVvkH9e8
	 WtMc8lH59Ks8l12vKahZ22g7jnksEzkvMCLYT3zWF83EtFkQvOIS5BqbN8R4vXHQJj
	 Z1Em81J4IyNwhOIJR1AWmLhi0T7ZRbW7zRrxPVn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/196] gfs2: Fix GLF_INVALIDATE_IN_PROGRESS flag clearing in do_xmote
Date: Mon, 13 Oct 2025 16:43:16 +0200
Message-ID: <20251013144315.384303484@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 061df28b82af6b22fb5fa529a8f2ef00474ee004 ]

Commit 865cc3e9cc0b ("gfs2: fix a deadlock on withdraw-during-mount")
added a statement to do_xmote() to clear the GLF_INVALIDATE_IN_PROGRESS
flag a second time after it has already been cleared.  Fix that.

Fixes: 865cc3e9cc0b ("gfs2: fix a deadlock on withdraw-during-mount")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 687670075d225..c4bc86c3535ba 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -811,8 +811,6 @@ __acquires(&gl->gl_lockref.lock)
 			clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 			gfs2_glock_queue_work(gl, GL_GLOCK_DFT_HOLD);
 			return;
-		} else {
-			clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
 		}
 	}
 
-- 
2.51.0



