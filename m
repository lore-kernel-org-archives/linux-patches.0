Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3695219DF52;
	Tue, 16 Jul 2024 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144086; cv=none; b=uht2aKeNGZoY5gd218aAXej4vOoQLWn3pWBd9k3r1kkqPDPvuyvAkGhDuv8FoIVujHfWdr3usRK6JxdAQII08nzc30s+VHBlE3z3PWn3BsDp7vdVvT+vx3OkjsFXd3K0DU+uNXiWf2D+2HJ0aXqjPlgnpU+kBpoQ2Rl1sT2oyjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144086; c=relaxed/simple;
	bh=4fwJPRJDzbISnpvc+EbnjhBhtqSVZTG5lfoHhrWGM1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Juh/nlD3iRc9uRMIW1yfqpvBOjP9DzHJMqBKqtZM9CaovwxyWcv6veHioSpilhpxh9uuub+sopWhuQhncG7oOva8VDUrl/al2CH07UarExbprTz34vilNusF4Id6ldZJaBCWA1hnSH8ErxCOzfccBFeVRPBQM1fw3eZiu73OBy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urWrO4ii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urWrO4ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D45C116B1;
	Tue, 16 Jul 2024 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144086;
	bh=4fwJPRJDzbISnpvc+EbnjhBhtqSVZTG5lfoHhrWGM1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urWrO4iiXlYQ+f+A/U8lTDWf9bsfXlDVFPib8H4rnmrug3GFtqnPjElo4Yy1o62eH
	 iRcowSrdADyIKGs+chEwaeYn1lksH8DADYrTcWerzq7pjjEGakXGOiBSasegf+s+cd
	 wt8awpa6bKAsxT6wkr/NBptEQlb/uRtiyKGV2yn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/66] orangefs: fix out-of-bounds fsid access
Date: Tue, 16 Jul 2024 17:30:50 +0200
Message-ID: <20240716152738.743946227@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 53e4efa470d5fc6a96662d2d3322cfc925818517 ]

Arnd Bergmann sent a patch to fsdevel, he says:

"orangefs_statfs() copies two consecutive fields of the superblock into
the statfs structure, which triggers a warning from the string fortification
helpers"

Jan Kara suggested an alternate way to do the patch to make it more readable.

I ran both ideas through xfstests and both seem fine. This patch
is based on Jan Kara's suggestion.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 524fd95173b3a..571eebf1a263b 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -186,7 +186,8 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		     (long)new_op->downcall.resp.statfs.files_avail);
 
 	buf->f_type = sb->s_magic;
-	memcpy(&buf->f_fsid, &ORANGEFS_SB(sb)->fs_id, sizeof(buf->f_fsid));
+	buf->f_fsid.val[0] = ORANGEFS_SB(sb)->fs_id;
+	buf->f_fsid.val[1] = ORANGEFS_SB(sb)->id;
 	buf->f_bsize = new_op->downcall.resp.statfs.block_size;
 	buf->f_namelen = ORANGEFS_NAME_MAX;
 
-- 
2.43.0



