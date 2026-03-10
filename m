Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AF82BF3E2;
	Tue, 10 Mar 2026 11:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141152; cv=none; b=AYUxgzRos1/Pt/LLXFXdruAin7LmdN45t/oGuJ6enF+liX7tLEssgBphrDqjFnygWOf93z37/FPJYO6p974+DGJJvhS5zfSfnT2JyVmQSBwEg0hq6DWpHB2CxszSIj+PryfmaRGfzp+gI9jNbnpe3M+0iTMQ1q0pVgWScaP8yvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141152; c=relaxed/simple;
	bh=8BSsYPD4bcZiXHoW+0BHCdCwVqKMq+iS1gaXh6R8JmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJcGT77b2nSSlj28NWOScDPpqzZfh5VuXKLD9FxpnfwA3i/BzC0K5W2O2CJob+B64LQPMRif/IMGyzNzUjkOkr0cmWU52jRMOT3u0tCv8joplqv7rxbh+d6ijPfuRhIXoiSlroN3uAsPCocrmUbrNjCJlq2NqxQo5o8J87Jz5NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhjwBJC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhjwBJC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD2FC19423;
	Tue, 10 Mar 2026 11:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141151;
	bh=8BSsYPD4bcZiXHoW+0BHCdCwVqKMq+iS1gaXh6R8JmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhjwBJC7XAwOBiqPhbq0WxYGwYhD2vW/HGWDef4ZI6nmjy2JENRJklQfyWZ7zWZnZ
	 LMy38iPMPCBON6YwsNshc8KY/kZVzZCppu789XDAzSqxkFS5Va3S78VvhqxFy0PxGL
	 cWEVQcL8Wt4+7P+73vQYqdAwhie0GuVTbj+2oRhtW5Jd3mNWjo2xJo6OjanBLFILb4
	 2WPZ/l3DPqdci/HNRuA6Ns/JBXIkAElkVpeptYDF41/VmqAbm0RoGmdnguOpoTd2JY
	 /yHr2K17DHTQE6rc2SnKn+sTZ/K5pBqEi9i58SJ/4nbLkDu4N9ayKL7iFk5evlugFy
	 yVEqaWnABJx3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 154/311] xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
Date: Tue, 10 Mar 2026 07:03:21 -0400
Message-ID: <cf96c103c0b9d9bde8860e47722577bc39ab2d5d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

commit eb8550fb75a875657dc29e3925a40244ec6b6bd6 upstream.

Chris Mason reports that his AI tools noticed that we were using
xfs_perag_put and xfs_group_put to release the group reference returned
by xfs_group_next_range.  However, the iterator function returns an
object with an active refcount, which means that we must use the correct
function to release the active refcount, which is _rele.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_notify_failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index b176728899420..0700a723f38e7 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -293,7 +293,7 @@ xfs_dax_notify_dev_failure(
 
 			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
 			if (error) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 
@@ -329,7 +329,7 @@ xfs_dax_notify_dev_failure(
 		if (rtg)
 			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 		if (error) {
-			xfs_group_put(xg);
+			xfs_group_rele(xg);
 			break;
 		}
 	}
-- 
2.51.0

