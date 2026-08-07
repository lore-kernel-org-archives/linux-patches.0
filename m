Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06192DC765;
	Fri,  7 Aug 2026 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115216; cv=none; b=haKDQccJ3EHXNy+rAqN9Luwu7GbQ4Re9vE1Y4F4MzfqK/Weup0vEV7XqrtsBkMxcy9fhCxCbID5vF+hxiT1Tw7iWCRwYq33Fll9JdLy3bs6qoRkvn0Byjg+uA+qOHP2Lm87Ri9vPjKEQtLapmZgdASOz2cTa/JTiamUXo8srNJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115216; c=relaxed/simple;
	bh=OsP3rJPKIIM6z3zHzG8gGxbSUYEXpwyJJcwnFV5W8vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrY2aJpuRSijWoidR23+cOLWRBLFkAtBq++ozXxoagIPjmy1CPd9Kq/eKlRsIJPfwQif7bBRCc+4c+iN5pAndGvBSZo3YzqIt0i+q1BEGwqurKeqFcFnunn0L2VSgtj01ETtP3ok6sMBtS+7XG0oufRsDmq/dF9l2RAxbcBPz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blBnseHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blBnseHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F551F000E9;
	Fri,  7 Aug 2026 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115214;
	bh=CMnKPQ8skVAfPa/qq9j0VgwYKGQmV8ruixEcy401E98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blBnseHUU1bjckuG9LCNsb9hnAFU/NzCXw2xIc1JKxQxolKbJX4+odvzmgYvr3aOc
	 OZWjZ5Yb3VH3R93erJ2Ibrb6CmFzeY5dOEvDgDPRAZzmPaoYS8orGl4r4NF1/HCL5L
	 fLsM1xk36w5W/AeJY+YCWYfzx3jDCxDtP1sP5k6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 199/396] afs: Fix afs_fs_fetch_data() to subtract transferred from len
Date: Fri,  7 Aug 2026 16:35:59 +0200
Message-ID: <20260807143428.575054891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

commit 222052c6be186f2074b3a4d741d5de200f654c43 upstream.

Fix afs_fs_fetch_data() to subtract subreq->transferred from subreq->len
rather than adding it.

Fixes: f28fc2010d62 ("afs: Eliminate afs_read")
Link: https://sashiko.dev/#/patchset/20260713081022.2186481-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260723113452.566619-3-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/fsclient.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 626e1d37b915..1a3f186a6a11 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -487,7 +487,7 @@ void afs_fs_fetch_data(struct afs_operation *op)
 	bp[2] = htonl(vp->fid.vnode);
 	bp[3] = htonl(vp->fid.unique);
 	bp[4] = htonl(lower_32_bits(subreq->start + subreq->transferred));
-	bp[5] = htonl(lower_32_bits(subreq->len   + subreq->transferred));
+	bp[5] = htonl(lower_32_bits(subreq->len   - subreq->transferred));
 
 	call->fid = vp->fid;
 	trace_afs_make_fs_call(call, &vp->fid);
-- 
2.55.0



