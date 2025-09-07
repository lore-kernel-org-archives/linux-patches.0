Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DE820E00B;
	Sun,  7 Sep 2025 20:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277822; cv=none; b=KMNZlkGXkJsurGuP/YXUn1OjnMZS7+EtR7FRrpYgzgFQbfvHtCCg0WbqHSvBsqs2giIZMgnal+YldGo7Cjg2wYG3hsCroy9dq4i1ZqkbzxM6Gws3T5a+SP1XGARDMPzO4yfk7mT46wB/9TPYAojZmesgvsra2Rt74ixGrogMmOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277822; c=relaxed/simple;
	bh=szYtjo6hHl4ASM9vEdjmBdnDGdGjZFQ+yVzjHPdiqRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTxElAFdS7tLmwQFGYEsGiMl7ZjFjj11zgJvt1AI2PjW/RgGoZKeQzndcy5XpguFF+UAS8PwuHdpEnboUEssWrc55dnvHn6gByzlA18FjNnAriVmvF1PDrMVhM7uiww0Tx6uf96h5MTz7ZdCoGmbnqV5tqABBEFjRLbeB++3SME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUSGdt4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUSGdt4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31758C4CEF0;
	Sun,  7 Sep 2025 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277822;
	bh=szYtjo6hHl4ASM9vEdjmBdnDGdGjZFQ+yVzjHPdiqRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUSGdt4Eh5GQqpPjXAyxe7LOvLzfAx4v2c9wXiCCLJlX3JuCMPG3n1LVFb0n1PtNQ
	 SgNx3EFD3c/p/0uOzsSKoIrvyLgrQ93SI2W73BXJpzwpXuWZ6xzipCrM+sBZtWPgPB
	 VsoeyjVcE5HwcaP+v0EF6kXcuoL6njpC7w2DVrzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fort <disclosure@aisle.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Stanislav Fort <stanislav.fort@aisle.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.16 134/183] audit: fix out-of-bounds read in audit_compare_dname_path()
Date: Sun,  7 Sep 2025 21:59:21 +0200
Message-ID: <20250907195618.978297613@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Stanislav Fort <stanislav.fort@aisle.com>

commit 4540f1d23e7f387880ce46d11b5cd3f27248bf8d upstream.

When a watch on dir=/ is combined with an fsnotify event for a
single-character name directly under / (e.g., creating /a), an
out-of-bounds read can occur in audit_compare_dname_path().

The helper parent_len() returns 1 for "/". In audit_compare_dname_path(),
when parentlen equals the full path length (1), the code sets p = path + 1
and pathlen = 1 - 1 = 0. The subsequent loop then dereferences
p[pathlen - 1] (i.e., p[-1]), causing an out-of-bounds read.

Fix this by adding a pathlen > 0 check to the while loop condition
to prevent the out-of-bounds access.

Cc: stable@vger.kernel.org
Fixes: e92eebb0d611 ("audit: fix suffixed '/' filename matching")
Reported-by: Stanislav Fort <disclosure@aisle.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Stanislav Fort <stanislav.fort@aisle.com>
[PM: subject tweak, sign-off email fixes]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1326,7 +1326,7 @@ int audit_compare_dname_path(const struc
 
 	/* handle trailing slashes */
 	pathlen -= parentlen;
-	while (p[pathlen - 1] == '/')
+	while (pathlen > 0 && p[pathlen - 1] == '/')
 		pathlen--;
 
 	if (pathlen != dlen)


