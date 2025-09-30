Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847D4306B0C;
	Tue, 30 Sep 2025 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244938; cv=none; b=BBNUgDSDmwAxJAQVHAszxzKVdFT7eNoRImB3HrEVZU8WhoWOx3iBAO/6d896JdgQbiPjPM8j6STH/nzeLASu8etQsFTwGkI6oy8urS1MthHL5JPhEZZUapzfgiWLMSG3xsPApEYFqTpD0N2/0K2wD0OnDziHfstlze+2ttPfUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244938; c=relaxed/simple;
	bh=+XlfjZasQm0WlpYCGFEKgyCEcrS3tdv4jiC8RD3BOQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP7E8CJ6Wn/VOc+Kl5OYEXGE1yZ4tsqbskYsgfzmZkxxvOZMmqj6Aa9PnSXaMmtfCN41q+Y5xbJkDgqkUuMnkfa+iViOSDVbTs3GF0vihoDqvdBZg+1ECzJdquZkJ7HQs05GpqHAVBcSRJvs2wHE6tuePusGj7K5J1MywSf+XdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU2axLJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU2axLJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB17C116B1;
	Tue, 30 Sep 2025 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244938;
	bh=+XlfjZasQm0WlpYCGFEKgyCEcrS3tdv4jiC8RD3BOQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vU2axLJqGG1aKPeY6kKKmPYFGot9vi3v65gvhWprMYAqVeX7iMN25jJbFoVhco1co
	 dX8y1R88S4QdROXxuB245//6jl2EWzd8lXEam54Ui8UaBfQUUnEJzUU4LZxWpP44aT
	 n+WsK/eI26J10XYkyrp4DDPJx+qQrOhLbZ9yFM0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/151] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Tue, 30 Sep 2025 16:45:32 +0200
Message-ID: <20250930143827.685312546@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5b5b68affe66d..2d7467be2a48c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -126,6 +126,10 @@ xfs_growfs_data_private(
 	if (delta < 0 && nagcount < 2)
 		return -EINVAL;
 
+	/* No work to do */
+	if (delta == 0)
+		return 0;
+
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
-- 
2.51.0



