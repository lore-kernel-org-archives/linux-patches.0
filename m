Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7451A08CB;
	Thu, 15 Aug 2024 13:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729463; cv=none; b=dcS8qURvvFrvopOp1aO+hK5x6i9zNFxPWMCy8eOgpsQOeyg+Nsh5DlSIFaryJUqAL9XNITOn+uJzZpGcGG696/0HIZUBzbvsIdAULOrohK8ipm9mLkakzyILqm5T9K9oAn3+eZFGLRZ9zdhuIwsoC8sDqXQDBVnRdfBCXuwPA0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729463; c=relaxed/simple;
	bh=VgqY8kpTedwaTBVacaNOHRrGqXtwX9MaYKuTuikaOR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns+wHHo/XUZjidIoAQleTA4V1MX2kWBPairtpKdATC8VFpIfdMYv4lARtiyPntAzq0dWvSMItdAqxEOvDWAmQW5C5wNAp0uXu/aqBRtjwQzEwFlrNw9kZ7cdJ+ENpEpVzamGnqCDucSIIFS6l1fWTcvpUNiROpJm7a4vd54o4iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=za5T1zlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="za5T1zlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDF1C4AF0A;
	Thu, 15 Aug 2024 13:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729462;
	bh=VgqY8kpTedwaTBVacaNOHRrGqXtwX9MaYKuTuikaOR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=za5T1zlSLrQ/b86P/6VFvBniLMcsJuIXvq6YvYRtkTWjMOnhSwpcMiGJen2jqiEMq
	 b3Sc6Eru5FUplNkaTXFQMl5Yw/+PLcObiOncNEThSbBCRxzVHcmlyoqiyV8+S+gCFe
	 mw8iUaXFLkbqmpHqU/ZpK5k2ioOvdoVoa5MvJr+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/484] ext4: fix infinite loop when replaying fast_commit
Date: Thu, 15 Aug 2024 15:19:24 +0200
Message-ID: <20240815131945.390089588@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

[ Upstream commit 907c3fe532253a6ef4eb9c4d67efb71fab58c706 ]

When doing fast_commit replay an infinite loop may occur due to an
uninitialized extent_status struct.  ext4_ext_determine_insert_hole() does
not detect the replay and calls ext4_es_find_extent_range(), which will
return immediately without initializing the 'es' variable.

Because 'es' contains garbage, an integer overflow may happen causing an
infinite loop in this function, easily reproducible using fstest generic/039.

This commit fixes this issue by unconditionally initializing the structure
in function ext4_es_find_extent_range().

Thanks to Zhang Yi, for figuring out the real problem!

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20240515082857.32730-1-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index cccbdfd49a86b..ee52dd6afe543 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -312,6 +312,8 @@ void ext4_es_find_extent_range(struct inode *inode,
 			       ext4_lblk_t lblk, ext4_lblk_t end,
 			       struct extent_status *es)
 {
+	es->es_lblk = es->es_len = es->es_pblk = 0;
+
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return;
 
-- 
2.43.0



