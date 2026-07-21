Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECADD3E008A;
	Tue, 21 Jul 2026 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653585; cv=none; b=U1yyQbqVcI9BAz89TKgjc3N6Of3xBXGUnm4TtSlDw7hczV/L0/JrYJd0JyCXRbwmqFDg9/nR0/cBwUqm8BZMl+TlmI2McHGGPJs+IAuTivM/GvnLRyNQzoGLbnxsDxORvl7eRi2jnjDotd0tavTkBV18kXUc+7dYSrbxX75X66g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653585; c=relaxed/simple;
	bh=/6vs07zRmWHhjI42RxDGfEzC2l7n7OMaEdUgXBBNOlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfloZJoc0rKId00Db6bKfVJWyPSXt8nvqSDzDov5tiy4L2kogC5Cz3PJZqyjO2uTXossCq2Aa34wd4vIQP6qlumnVcQC+ApPfS5/PFhiAbw30ZBWbJybehDDYL4GBlUTy/v9TPvNSAO/S3hnowauhUVUVYbaBHufG+6khz8cI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCHlJc/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCHlJc/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF191F000E9;
	Tue, 21 Jul 2026 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653583;
	bh=9EEjjTnrRW6zLS7FqmbM+qSw4u84ZhRnJYVrgzFssf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCHlJc/c7WjKMyKPLz7igS89dJrlNleJkBit6+sTM6B5IFU8bmMdk3a1MjG3Bt0Vg
	 6PprKRejc8YfCws+qMtAGKXX7muBT4iYLnZbKGDsb//emXsJEsHixVqo1qEX46F/lj
	 Icm+wGjDnYFrjoyyeRdziGzbun6sBspgAVHfxjgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1380/2077] afs: Fix missing NULL pointer check in afs_break_some_callbacks()
Date: Tue, 21 Jul 2026 17:17:33 +0200
Message-ID: <20260721152625.366394322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 794a01110390c1b76f59ece773fb0fbfd89c6f5c ]

Fix afs_break_some_callbacks() to check to see if afs_lookup_volume_rcu()
returned NULL (e.g. the specified volume is unknown).

Fixes: 8230fd8217b7 ("afs: Make callback processing more efficient.")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-16-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 833ac3178ddc75..0a09a9ca3c6b37 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -220,7 +220,11 @@ static void afs_break_some_callbacks(struct afs_server *server,
 
 	rcu_read_lock();
 	volume = afs_lookup_volume_rcu(server->cell, vid);
-	if (cbb->fid.vnode == 0 && cbb->fid.unique == 0) {
+	if (!volume) {
+		/* Ignore breaks on unknown volumes. */
+		rcu_read_unlock();
+		*_count = 0;
+	} else if (cbb->fid.vnode == 0 && cbb->fid.unique == 0) {
 		afs_break_volume_callback(server, volume);
 		*_count -= 1;
 		if (*_count)
-- 
2.53.0



