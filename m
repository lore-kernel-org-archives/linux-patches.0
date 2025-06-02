Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC5B225775;
	Mon,  2 Jun 2025 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876632; cv=none; b=fPXrqkt3N/exCkeZk+f8Gnjw0erPnNWCmNlVODAB2wm119u/8wE77YrnlmPIU/30x+5IcDBd1/qtcYNDLRP1olKS++aL1YROve8kBmGBpvxOGjvpMmnsF02TOV6Y2RWmKLHKhxNCPg1ehUh7XGndEhlYG5zVl7/b0iYL2zZhEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876632; c=relaxed/simple;
	bh=r7+AlgxMmISwism3R5edUxm5qAWQCo1HptXooQssucQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eco8maCvPhBx4bJIRCbn3+9908esFfMl++N1+cWDwV0nJIgn/Ik3+VILDuzs0DbQzQxl1V/R3dMZsZL/MXY4APt0Y283aXNSgJiXPdRscCncraIWeKijgDYFkhit07U9619KsZ4dHCCiicnJHwZlrZ+st9Iv/orf8jUX3O4/eCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp3bPxS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp3bPxS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3B5C4CEEB;
	Mon,  2 Jun 2025 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876631;
	bh=r7+AlgxMmISwism3R5edUxm5qAWQCo1HptXooQssucQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fp3bPxS9ssRCo1bdsOoblof6OC6WCwyep6pTm33DJtk1etFxySXyztqEslhnvAteR
	 2SoAKMnAv6ZPr/9E0QIvrbIViF99wAiYM6YgrWtW2BRqCx2nuoe7C6fWwJpbg5zZlh
	 dswXStpNunnZzklNZPiUD5df/7BJHqsXuO2NLjZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/325] NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()
Date: Mon,  2 Jun 2025 15:45:01 +0200
Message-ID: <20250602134320.760318618@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9e8f324bd44c1fe026b582b75213de4eccfa1163 ]

Check that the delegation is still attached after taking the spin lock
in nfs_start_delegation_return_locked().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 6363bbc37f425..17b38da17288b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -297,7 +297,8 @@ nfs_start_delegation_return_locked(struct nfs_inode *nfsi)
 	if (delegation == NULL)
 		goto out;
 	spin_lock(&delegation->lock);
-	if (!test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
+	if (delegation->inode &&
+	    !test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
 		clear_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags);
 		/* Refcount matched in nfs_end_delegation_return() */
 		ret = nfs_get_delegation(delegation);
-- 
2.39.5



