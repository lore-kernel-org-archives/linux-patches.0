Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868A7352934;
	Fri, 21 Nov 2025 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733306; cv=none; b=rY85tqi+RWa9mmyEbvhOCY6EkMVlK4k3zeuWgdaNRtjrX6w+GUwUa4LbjNrody8Ew4v6QlF4TCHH/DZMMFlIs+XBvo/Ldf9Wtu6PajOpKxBfoYJ6R7rmeMEpF0mBgIfTlSJHIPybdFbeBjkPLFONbuMs8EWeN2b6h99taenpm7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733306; c=relaxed/simple;
	bh=2NabsI/t5UkbYMqq648BXzwcfxw4KNG/SBkIF7HmvOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3WTMnGgVitKoAbJ/Kp7OmJGSjaiWbhwghpCNSDBE7DTc/OdADKTd+Al6ZYJn+pwePJ0R8pj/n0y4JF8LELi50ttXU2r63s5Bz9H32qOLtAmdppVt6+1inBw6VUH+n3gm8K2ngRTuiOYkpeI7BehGuAJKdXRhrxgqWIY3rcDIao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzX9RyDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzX9RyDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61E8C4CEF1;
	Fri, 21 Nov 2025 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733304;
	bh=2NabsI/t5UkbYMqq648BXzwcfxw4KNG/SBkIF7HmvOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzX9RyDRODfConPPW8CDaDl4qVZ7CDBMHyy59MNti5tM3G99auLsPA/PWjQFPBSzD
	 bS2sf45f2MupvEfPTaY603QGCr1yUOwu4kjfUdaDp5P2NUzY5o/o/h0WfLYTZb6xuJ
	 EvAo37cQq8qEMcFaaHBCORTetq4L2O3NXcwsmE2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 389/529] NFS: check if suid/sgid was cleared after a write as needed
Date: Fri, 21 Nov 2025 14:11:28 +0100
Message-ID: <20251121130244.863306166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cb1e9996fcc8e..ef69b15aa72e5 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1638,7 +1638,8 @@ static int nfs_writeback_done(struct rpc_task *task,
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



