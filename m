Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8313AF669;
	Mon, 23 Mar 2026 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276924; cv=none; b=XznElEIKNE58Q1EE8ZVfEdrvjxveWTHHASACkIl+nG2MV7xrVo1gX4M6cKaPXuB53tbZqWkgCuhmbyE73DG8ZZjIsosveLRew9oSTgg7ydVA95piL2nSffm1TQ5ztdJHxDv9dcU36Q/1xgoOhthmOByOwCH4So2BinufTRvG5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276924; c=relaxed/simple;
	bh=DgSd8fykyxybU8xfOPo94ZLbCkg6cYOEUX74jmMu7Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlfXGvGxiqgbriejohuOTpkwQOrMj4MXd4wzBFNrGNml6a9Hj9IhLjFwHX3yhVHjLKM+Fh8H1QJVfvsbLFn+Cxxf4hXXANAwmQsHdQnzjEJO4bEppNGX8n3/IEw2ZvdTZ36pwGdpxqmrmUKVop/xnYtgYA07GuTX0Hu2d5L51c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1h+hFi16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1h+hFi16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303F0C4CEF7;
	Mon, 23 Mar 2026 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276924;
	bh=DgSd8fykyxybU8xfOPo94ZLbCkg6cYOEUX74jmMu7Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1h+hFi16Iyu8JuUtJkyRaRUuzIzd/Bq5/sjo6Vn+ZuE0XDrZ717rvCVosB9T4rnz/
	 JFpbC1rdQYjLhXVv36Tg+j5cUBOqPzaZ6J57qlq8K2oPS5qLoTUR+Di4atXq6Wz1KK
	 5KXXe9/H9XqRMWkMKRrsy8Al56g39z70AMITqL1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/460] iomap: reject delalloc mappings during writeback
Date: Mon, 23 Mar 2026 14:44:13 +0100
Message-ID: <20260323134532.802687651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit d320f160aa5ff36cdf83c645cca52b615e866e32 ]

Filesystems should never provide a delayed allocation mapping to
writeback; they're supposed to allocate the space before replying.
This can lead to weird IO errors and crashes in the block layer if the
filesystem is being malicious, or if it hadn't set iomap->dev because
it's a delalloc mapping.

Fix this by failing writeback on delalloc mappings.  Currently no
filesystems actually misbehave in this manner, but we ought to be
stricter about things like that.

Cc: stable@vger.kernel.org # v5.5
Fixes: 598ecfbaa742ac ("iomap: lift the xfs writeback code to iomap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://patch.msgid.link/20260302173002.GL13829@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ iomap_add_to_ioend() => iomap_writepage_map_blocks() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1879,18 +1879,19 @@ static int iomap_writepage_map_blocks(st
 		WARN_ON_ONCE(!folio->private && map_len < dirty_len);
 
 		switch (wpc->iomap.type) {
-		case IOMAP_INLINE:
-			WARN_ON_ONCE(1);
-			error = -EIO;
-			break;
-		case IOMAP_HOLE:
-			break;
-		default:
+		case IOMAP_UNWRITTEN:
+		case IOMAP_MAPPED:
 			error = iomap_add_to_ioend(wpc, wbc, folio, inode, pos,
 					end_pos, map_len);
 			if (!error)
 				(*count)++;
 			break;
+		case IOMAP_HOLE:
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			error = -EIO;
+			break;
 		}
 		dirty_len -= map_len;
 		pos += map_len;


