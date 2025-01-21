Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B03F1F55ED;
	Tue, 21 Jan 2025 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482096; cv=none; b=sGUiHqf2YlXLBH6TU88shFJpWnUVm8swa1wXRHCAbxBanB6kOc2zdbOEqOZTf7PELX1s1cbDSOg3uXbH/FXOek9IkGG9CqdDWytICd7J3xYMIOSDrpMuxGzFgrQOnKTsEo75QsNm4YC31+/cb4JJZOcymDc21Lx/k9D6DwNFIf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482096; c=relaxed/simple;
	bh=+AVxtxvza3ljqLM9ZOXvWG5ppeMcCTaQu9TQLD5+l3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4o039UpG/GRISuSxsbQwlZcp812OGc0MoWfbPDkVgZ69OzrSizAT45ndcdya9wnsvMcvqpZJjS/drK5iEStG0trlxmuKJFYRwI13x3EfJxMu+42raKujSCysJBdPgllUrUspHJJUrH3FOs9xR5Us6POXOJAppPxuDXDGXYRI5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QK9ZL+wh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QK9ZL+wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6155C4CEE0;
	Tue, 21 Jan 2025 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482096;
	bh=+AVxtxvza3ljqLM9ZOXvWG5ppeMcCTaQu9TQLD5+l3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QK9ZL+whuCSZ178FI/O2IjZ5DdUvxub+MnxBf9BoijG7liCAktTcurHExekw53JtS
	 D2SmK4JIIg9/7hxi2djNrr7RwTzpsl6FJyb9OuItOXJOo3EAO5fUxeBNeewyqtk4S8
	 2LRuXdZiyrU2l0SFY+nZClsYSBBeu/JYRXatVFsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nelissen <marco.nelissen@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/72] iomap: avoid avoid truncating 64-bit offset to 32 bits
Date: Tue, 21 Jan 2025 18:51:59 +0100
Message-ID: <20250121174524.699510799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marco Nelissen <marco.nelissen@gmail.com>

[ Upstream commit c13094b894de289514d84b8db56d1f2931a0bade ]

on 32-bit kernels, iomap_write_delalloc_scan() was inadvertently using a
32-bit position due to folio_next_index() returning an unsigned long.
This could lead to an infinite loop when writing to an xfs filesystem.

Signed-off-by: Marco Nelissen <marco.nelissen@gmail.com>
Link: https://lore.kernel.org/r/20250109041253.2494374-1-marco.nelissen@gmail.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a05ee2cbb7793..e7e6701806ad2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1095,7 +1095,7 @@ static int iomap_write_delalloc_scan(struct inode *inode,
 		}
 
 		/* move offset to start of next folio in range */
-		start_byte = folio_next_index(folio) << PAGE_SHIFT;
+		start_byte = folio_pos(folio) + folio_size(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
-- 
2.39.5



