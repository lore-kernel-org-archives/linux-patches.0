Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F86F41DDF3;
	Fri,  7 Aug 2026 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117249; cv=none; b=aiecFMZPiHXdN1QBBK2WKFfsQmhFIx8ktwP1FAKfxQSShUVZXFWUkAcJ6RTI7VOxkDLzUSyATmH6XHXOLpnLQ8c8DC0kCCh2FzGIA7d5Q4DLNX/OEerCVfb/nsKCkFMoYEge0a+RDxiEUtrwm++eSJ82GGXGuXFsPlIsDipVSH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117249; c=relaxed/simple;
	bh=if9k9dOoF7kB87yKyHh4U6OQ0B1yiLvZNa0vbHWCTpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6887pIBnEXtNVsyyKGwmTpXAUhnL4YRnUFtY8vXnd/aeweckHUnHuz5s5qfypx7CajR7ohN22Cj0sHTadnGCFMy3k/hHwep03AQGFTPXZNJUXp/j/Tl4nMn8Xw/krkBcpvpNOjCmZxHNor/jtyhIylLJPaNL7pww3gWU0CcCIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1IyF+tF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1IyF+tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D3B1F000E9;
	Fri,  7 Aug 2026 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117248;
	bh=WFe7+ChdMBzCCVAWk2RtsjGtDXTNG2GW6VqcVFq0DBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1IyF+tFIYyjvrk0z1/dzdKRSYjrC6GJGuG0NFp4xhgIMdUD20p2NIX1uStuXI1oK
	 czW+VZrKcXJwVZXlVxBJFE/QTyQQMS2rvvKFVU4pqnFPD7JCelOh/8eAB4xsKVzyH1
	 xkIPFG1NTgzxx9dWJ37obyuXxn0BRVyWC5f8CCyU=
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
Subject: [PATCH 7.1 250/438] afs: Fix afs_fs_fetch_data() to subtract transferred from len
Date: Fri,  7 Aug 2026 16:37:26 +0200
Message-ID: <20260807143433.327791084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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
 fs/afs/fsclient.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -487,7 +487,7 @@ void afs_fs_fetch_data(struct afs_operat
 	bp[2] = htonl(vp->fid.vnode);
 	bp[3] = htonl(vp->fid.unique);
 	bp[4] = htonl(lower_32_bits(subreq->start + subreq->transferred));
-	bp[5] = htonl(lower_32_bits(subreq->len   + subreq->transferred));
+	bp[5] = htonl(lower_32_bits(subreq->len   - subreq->transferred));
 
 	call->fid = vp->fid;
 	trace_afs_make_fs_call(call, &vp->fid);


