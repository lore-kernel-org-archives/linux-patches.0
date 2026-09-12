Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA6544AB60;
	Sat, 12 Sep 2026 10:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210390; cv=none; b=G44ZmOj87wkbhCMNdMvd2ppggkPKd7djDT74ziLmyOgkqcR+4scvydGp0ifc0t46vKZoBqN+nXXpGUYYwhixk39mlQ7uAIWc3GhN5P4q7AW5Rzr/4VKt4Xta8FSqmIrqV7b2x6EGOeJrWOX+ktUzKln263yJSzTABScEjoo/GQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210390; c=relaxed/simple;
	bh=w0tJEYv55S87fTPKGfsqvbwtgTJvQkcNgxi1tNJefk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9RfYF4cNVVDfvZPA8gQ5vRhLZw1XZUQwxKT+4qeXxxQ5QW8AghOb1cNUvEx4WIHiK9Z1LoypQ8kpIyGb4jFfn7nEFqRtDiYfwIJBJkMiKp0Ty+bA92ImZLXawDt0ReBXk5OCXWKjhSDd/nKBENiOgiAXE8rgt1WVoSMN1gqlsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSf/tiOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSf/tiOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BB71F000FF;
	Sat, 12 Sep 2026 10:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210389;
	bh=e2rJjaVSavoglnv7EWzO7TloxjboPiIU5VpZhRm1Ggg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSf/tiOj1oFu71kBMzef0a/g7/5/PbH+JQ2RKbj+7zU6a7t58b99wDA/9irJTMTU8
	 MRS0XGvI5fiw2JDin7AvNRI7iBWNKTJj0nhtiu2JZkP1ydEO2YGmFqyWbYwZ4FN98B
	 C+ojrQSbGXbORW2kp8IwkQxuv86Qq5Gqr6Ye/BGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0963/1518] md: wait for behind writes before destroying bitmap
Date: Sat, 12 Sep 2026 08:52:12 +0200
Message-ID: <20260912065645.245872254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 2a79365b2278f16e163e4024086105693b421601 ]

__md_stop() destroyed the bitmap before calling mddev_detach(). That made
mddev_detach() skip bitmap_ops->wait_behind_writes(), because the bitmap
was already disconnected from mddev.

This was still safe for the legacy bitmap because bitmap_destroy() waits
for behind writes itself. llbitmap keeps that wait in its
->wait_behind_writes() operation instead, while ->destroy() tears down the
llbitmap storage. With the old ordering, RAID1 behind-write completions
could still run after llbitmap storage had been freed.

Call mddev_detach() before md_bitmap_destroy() so the common detach path
can wait for behind writes while the bitmap is still alive. Only destroy
the bitmap after those users are gone.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-7-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b7e085885183..2e8e32e15e735 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6957,8 +6957,8 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
+	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
-- 
2.53.0



