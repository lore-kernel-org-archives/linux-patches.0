Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2631237FF60;
	Sat, 12 Sep 2026 09:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204105; cv=none; b=DJ2WxAHMnvF+TD7kjjVfzA/4RdAedWpoQ0yKg4e9w2L/3dB4r6/17wLN2h17NAq6vEaQqQmXi0vauNGL3zwxvUI2gedtIH7mNeM3u8CsbjS3+2pIna8DWdfS3iUXiM+JYqjwnCMHyQ2ZxJowyTj6KxJeo3t+/4fWpp67Iy7KTCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204105; c=relaxed/simple;
	bh=P5R5jHUGxPe3jilXDGKfnsGsFOraHTH9N/rjNwv5uB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFCHDPSINGvZItlcP9HuwNipx0hZbpuDypSz83kPQKsYQoMD67e4dU+nXv2tmhL+iy+y8G8QgSSzKLKfqVwWIu7P4M36Q/fO3BMdZ+Ra6jrZY3/fwNU3kglR1KUWr3CYTRN3NxKWRenzzfBJPLqXKwajTQmeg3CzRJgAmYBrUqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fapWNWas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fapWNWas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57961F000FF;
	Sat, 12 Sep 2026 09:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204104;
	bh=fJa4eGKgZHQm0sVN2Je3Pj18lDhBCVRzE+32//4iqfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fapWNWas+kkbJhkhV0R7CvWm37sM49EcycClZgeGobH4JVG3cOa//bk30BeyzTppz
	 EMcMS0WFQb1899hlv0fBgKIjwaGQwZ/o4WNih5+eFUNh2xk84S+uXLilBkeuo39gEA
	 g1UXdvwbplehdbE6Jkc51uEMs3oirbqgbus1QpvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1543/1815] smb/server: update session counter under sessions table lock
Date: Sat, 12 Sep 2026 08:54:53 +0200
Message-ID: <20260912065725.229121437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ze Tan <tanze@kylinos.cn>

[ Upstream commit 492b24b5b651a72ee83a8d481f70246b36192832 ]

KSMBD_COUNTER_SESSIONS tracks sessions published in sessions_table.
Increment it while holding sessions_table_lock so publishing a session and
updating the counter happen together.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 215f4e66deda0..5b734acc00736 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -724,11 +724,11 @@ static struct ksmbd_session *__session_create(int protocol)
 
 	down_write(&sessions_table_lock);
 	hash_add(sessions_table, &sess->hlist, sess->id);
+	ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS);
 	up_write(&sessions_table_lock);
 
 	if (create_proc_session(sess))
 		pr_warn_ratelimited("Unable to create session %llu procfs entry\n", sess->id);
-	ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS);
 	return sess;
 
 error:
-- 
2.53.0



