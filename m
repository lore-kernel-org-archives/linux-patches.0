Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29D831619A;
	Mon, 13 Apr 2026 16:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099001; cv=none; b=Uy6PzP1zxtPJw7ALC5A/0ENboY5RmqQ5vs1o17qwfTHDeS5J5O0qnIXN7xOTEeATsrlFTtNxy3xZDUZtbL7MbGR/F8pW2SMUNGGScZQuFmjFP1pE6ZL1kxSStIDun9HKbGLYOC1NcH/g+gNY34P9/v9izo4/uxlhr5eIJ5puigQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099001; c=relaxed/simple;
	bh=Xpj5zrrDyhJNf4llC5lLDhOWo3tG2mEyafibG6GTWV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJXtnWrh8Z194OolQWalnt+A4J7R+ejMRe5Npq8hFRxGhJLnrSR9Q2nU3WdK4Jqr8tR8GSxkPGjbh4tTUdpZee27/KsaSlhajFho8gr7lmo+CQc4VwHads77WRy6MQITeA7csd5DRZ+loF2Fk3oXKxgQhj4IGFnTI/LE0EJGcA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/p/dNJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/p/dNJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8877CC2BCAF;
	Mon, 13 Apr 2026 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099000;
	bh=Xpj5zrrDyhJNf4llC5lLDhOWo3tG2mEyafibG6GTWV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/p/dNJIf2KLQeoLxBJgdH4GkA4W5Ubu5LycLNkjJzc1ppvbD2DQLFN2wokZG13aU
	 ylpH/UmpEp3pMFIPy4SsXhzosKLLDcbutBEjuUSGP9GLBzUF3tAXaR/ECoyGiEdP+9
	 oX+eMp7bmGZUZB+LRP7C6m23mdaNypPg1dV8C4Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/491] iomap: reject delalloc mappings during writeback
Date: Mon, 13 Apr 2026 17:56:55 +0200
Message-ID: <20260413155825.409099796@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Different error handling structure ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1364,10 +1364,13 @@ iomap_writepage_map(struct iomap_writepa
 		error = wpc->ops->map_blocks(wpc, inode, file_offset);
 		if (error)
 			break;
-		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE))
-			continue;
 		if (wpc->iomap.type == IOMAP_HOLE)
 			continue;
+		if (WARN_ON_ONCE(wpc->iomap.type != IOMAP_UNWRITTEN &&
+				 wpc->iomap.type != IOMAP_MAPPED)) {
+			error = -EIO;
+			break;
+		}
 		iomap_add_to_ioend(inode, file_offset, page, iop, wpc, wbc,
 				 &submit_list);
 		count++;


