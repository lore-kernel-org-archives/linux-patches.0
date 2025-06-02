Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB222331C;
	Mon,  2 Jun 2025 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875948; cv=none; b=JtqtYfbpo5auyEMqurT93OuryzfwdSKt0mqx3MejT+afg6PCznOd+2cqX1ApEnGqbIsPlYQcc/+3RYwGePqZCM3CNJObwLu44pe82LKpQE4dPGnHcEqXf9Aojz6DWEeoDFZONhqbZext4ATuiYcUrIsV2mB556kXCWdY/IdoAvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875948; c=relaxed/simple;
	bh=+yh3Na9Duzq2Vt1L5oSEZ9ZBGJr4QqGJz7ixB3niwO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8TAjAXBrc0ADenq+FpIycPsL3FUXa3XopHW0J6UQRXQkOQ3c5+tAKvK2G66W8tFLQyIQus1dPQYFHRdtB5JRUhV8T27DvMqPPnVatkCt0fdyv3S+i8tVU6VdTsWNd8enUNYI6J/zSzdxSAB9WjaM3sl9/fMaY3HGvirj7qoIG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7m0CrAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7m0CrAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84723C4CEEB;
	Mon,  2 Jun 2025 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875948;
	bh=+yh3Na9Duzq2Vt1L5oSEZ9ZBGJr4QqGJz7ixB3niwO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7m0CrAze63a1/f8O4B53QsneOFhmbD9W/QUcxiAsNoWZLvRg00VIT/fKpL5KtFt3
	 mVOSU2ryYEivTMxGweNFpZ4O+RnXzMDrmxCu50ixiRXREZ+Qi7EXiMWY/ZV7SbTnkq
	 9tMMnBQgUkd3VW3GPwzpM3xbpOTWAgzEV2Op8XEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/207] NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()
Date: Mon,  2 Jun 2025 15:46:21 +0200
Message-ID: <20250602134259.135701942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0c14ff09cfbe3..45ef1b6f868bf 100644
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



