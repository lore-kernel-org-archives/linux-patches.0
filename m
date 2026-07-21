Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C030140099C;
	Tue, 21 Jul 2026 18:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658080; cv=none; b=I0FU5/38Qw92i1yByxz/gnTIvnR9ZscdNSK4S5n5Kbsg7M6SHG8WZ3snVYmbvmTV3S6PQWEiu7GjpfK/BMHxCn+gVV4GMucpqQqdzGC6vnuLejSeiWJDGIK1oHP4qTUWYmeYx01szQNzc3V3/4q4SJhVqOQAWNVDdohIlY6v0eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658080; c=relaxed/simple;
	bh=Z1btdlbUp9Y8vvbXj2TjXRcCEfwqO7nb1GeWea4B4qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oi34wb3gUDp7H8XD1XCQaNdRXEM5gx9mcKbmxc3o8hVyE2oik6QliATIKJ+2m0xS/7sswrqG3HtqJRDxUyYIQbRSQFtXyivbV86EMbpPxKkSGvR9PY84J66m+94Xj7rZY1VQ3IYivwVqvjPqqE4MJ58HwYIo+woK85+ItQcOX10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTPc2kAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTPc2kAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283191F00A3A;
	Tue, 21 Jul 2026 18:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658079;
	bh=AFenUwh40S29is/fbb7bL65QXHstSLfFtdbxCWPx+NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTPc2kADXa31RccvKDKIsxo3WFfqK8wiDz1GvDSZV4rVFxopLdv5cUeM6hemeKF1N
	 QH/rG/FvHDTNI83Ul3ciaqugO4zyfwWKkndoI2dxOlfNfU+vkpWwHZSiBdNnT+DurR
	 pAzl51D83bwMTJcyenLuhX9Kh/+jhcvTXW2tyQN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1007/1611] afs: Fix missing NULL pointer check in afs_break_some_callbacks()
Date: Tue, 21 Jul 2026 17:18:43 +0200
Message-ID: <20260721152538.044757535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



