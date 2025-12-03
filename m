Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C38A313546;
	Wed,  3 Dec 2025 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778078; cv=none; b=UAzeZISHSnRh194RW7AnnMLEboYV3zOpzwErENr1g8+S/1UtS9h0CF6H5v9FtUogvzu2tWpe7yUk7khCdyo793nflGQ8hhXR5n8Ox7F2TOJKCCfv78W/28Pm/LGuKxN0O9KpEfFivTk1RfKTkip87YQJcouVF2/kjCIgr9LijSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778078; c=relaxed/simple;
	bh=/9V2S2TPmGDtJHr/i+HxKUQZQbFrB1qwf63gQJk5r5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0GKCZGD7IumLmHnBwkBDXi2SOLI4cbO081LCfAQMk7x0zRvk0yi+182jQJEUgRYCFuw5auKgfxY6yN7BzPhJUERoUuaQNlI/e7FqLylEpyXCL9vx1pLfNrTogS5GbjCnlmNR63deiRRpSjP0QjHeUIjpzCQKQ/J/XaWiqlPoGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvVihqoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvVihqoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C11C4CEF5;
	Wed,  3 Dec 2025 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778077;
	bh=/9V2S2TPmGDtJHr/i+HxKUQZQbFrB1qwf63gQJk5r5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvVihqoV0NbEc/Qk0+BnCaP09l/6hKlJv6Utev79HDf5tkiM50wxVnGIILBIay/Cb
	 xeP5YT+JrnIXpPCVmlbJPYrKB09192QH9/Q/oOkYVwRLgsByxkNQBkfiFnm3vnXQ7R
	 H3WA6UPoP0f/MgcoR1y91GqB8qlQLkNSeoTvyzHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/392] NFS: check if suid/sgid was cleared after a write as needed
Date: Wed,  3 Dec 2025 16:26:25 +0100
Message-ID: <20251203152422.826787784@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 9ff022f3820a31507cb93be6661bf5f3ca0609a4 ]

I noticed xfstests generic/193 and generic/355 started failing against
knfsd after commit e7a8ebc305f2 ("NFSD: Offer write delegation for OPEN
with OPEN4_SHARE_ACCESS_WRITE").

I ran those same tests against ONTAP (which has had write delegation
support for a lot longer than knfsd) and they fail there too... so
while it's a new failure against knfsd, it isn't an entirely new
failure.

Add the NFS_INO_REVAL_FORCED flag so that the presence of a delegation
doesn't keep the inode from being revalidated to fetch the updated mode.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 9323631f4889c..914a2d7a09742 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1619,7 +1619,8 @@ static int nfs_writeback_done(struct rpc_task *task,
 	/* Deal with the suid/sgid bit corner case */
 	if (nfs_should_remove_suid(inode)) {
 		spin_lock(&inode->i_lock);
-		nfs_set_cache_invalid(inode, NFS_INO_INVALID_MODE);
+		nfs_set_cache_invalid(inode, NFS_INO_INVALID_MODE
+				| NFS_INO_REVAL_FORCED);
 		spin_unlock(&inode->i_lock);
 	}
 	return 0;
-- 
2.51.0



