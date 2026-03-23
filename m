Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280ED3A9D9D;
	Mon, 23 Mar 2026 15:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278681; cv=none; b=PYde7yxmvPMn54sZotI8Cokcz6H+2slUMK0gCNRr8Fzu4pjCtw6FvU2cZjTnOrI4PIiaNC3z/R2QBAPrWkVh0GWlV/P/9E1dZErdZXyotiha3vVfGKsHqQXfjhnp3Y5kS1kOiNk+eO7XqFyBao/2tySRpN3pWfc3+GItc3NCRuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278681; c=relaxed/simple;
	bh=WQY49k4KVmUQq483SEw/Wbea265DRJqfklYnYCyhoXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFbZzafP9+7rfvJ5pIyMolqPdYoShXMBBaZGsAoLtamIweQCn4GUsQFiO7abmkcQNsTWZEJ2Anu+Z9ZdbG8xH4BpdwQH2Mdv8IPnejlz/BWB16eQ8t5dr6rfhtruaoVJuTSA15sIN4PdwGsIfdhu87+TMjn+lKWYxVDh9gcRsuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSZ7/6on; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSZ7/6on"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B5CC4CEF7;
	Mon, 23 Mar 2026 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278681;
	bh=WQY49k4KVmUQq483SEw/Wbea265DRJqfklYnYCyhoXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSZ7/6onOpUvPfNzQA6HnpbftwRvzt0OX5P5Ssd0swZGcQFACcEyEjHGoso7xGSzX
	 NqceXytUtWrNEQf/gJfWkITku9S2ZSy049N5Mg04YRC4CyKibOhAqSpLOfcr8mEBtG
	 dAAFW6rnZMmMFyOB0LmbJ9eyaRD9AlG0J8L47hbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 386/567] iomap: reject delalloc mappings during writeback
Date: Mon, 23 Mar 2026 14:45:06 +0100
Message-ID: <20260323134543.398145674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
[ no ioend.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1838,10 +1838,19 @@ iomap_writepage_map(struct iomap_writepa
 		if (error)
 			break;
 		trace_iomap_writepage_map(inode, &wpc->iomap);
-		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE))
-			continue;
-		if (wpc->iomap.type == IOMAP_HOLE)
+		switch (wpc->iomap.type) {
+		case IOMAP_UNWRITTEN:
+		case IOMAP_MAPPED:
+			break;
+		case IOMAP_HOLE:
 			continue;
+		default:
+			WARN_ON_ONCE(1);
+			error = -EIO;
+			break;
+		}
+		if (error)
+			break;
 		iomap_add_to_ioend(inode, pos, folio, ifs, wpc, wbc,
 				 &submit_list);
 		count++;


