Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24714A60C;
	Thu, 23 May 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470432; cv=none; b=jyW2UKNzajXhBmyMgS3bHzYdCKB5efD2XV9axtzbI5TiGQJWvn48CpY754xBD7ThmXc8r+gOrAWJ4jRQ5sZgzRB/rTYDfWyU0jp8XVI5POpxP2tqlNfTgCYRTJdQettdRoZTC5GqVFUk4a+2zaCYXO4Cb01lhFj+8d4heTEAIe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470432; c=relaxed/simple;
	bh=n0aloHzOOR5gL3AKTiHG2W4ZUZvf9vs5OkUhYemGlN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmkIgNnPGBwjqAjwD/srdy2TsDTddoahLNV7fNpzlscNAx5Xu5uvyWxDNHFUj1qBNeqtw2Q9rKiXUdpFn8FhwPZ05I7j1h1gA6SznCshrgJfar4DOHv5e4S/MZ2tVe75GW5SFy2iNAKGtaqJ934xCLUpVQ2xf07HPmatSjSRm4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dRMUevF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dRMUevF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65BCC2BD10;
	Thu, 23 May 2024 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470432;
	bh=n0aloHzOOR5gL3AKTiHG2W4ZUZvf9vs5OkUhYemGlN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dRMUevFngZlAmzXl7k3avpCQJBKi9yeVI+LeeIA0SfL8sb8KkMdASpFoMRJ3CC1F
	 Jsw/nOcMhiQuSGL9y4WD0a6sI8US3CTVJK88cZzQ6PbHTzWwO5nmYcA9xU2wzTDPbT
	 DE3ZiWVe3BUcy8YSWlUdPaeph9h2mjzXY6DBGC9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 33/45] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Thu, 23 May 2024 15:13:24 +0200
Message-ID: <20240523130333.747276534@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 84712492e6dab803bf595fb8494d11098b74a652 ]

Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
further massages the new block count so that we don't i.e. try
to create a too-small new AG.

This may lead to a delta of "0" in xfs_growfs_data_private(), so
we end up in the shrink case and emit the EXPERIMENTAL warning
even if we're not changing anything at all.

Fix this by returning straightaway if the block delta is zero.

(nb: in older kernels, the result of entering the shrink case
with delta == 0 may actually let an -ENOSPC escape to userspace,
which is confusing for users.)

Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsops.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -129,6 +129,10 @@ xfs_growfs_data_private(
 	if (delta < 0 && nagcount < 2)
 		return -EINVAL;
 
+	/* No work to do */
+	if (delta == 0)
+		return 0;
+
 	oagcount = mp->m_sb.sb_agcount;
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {


