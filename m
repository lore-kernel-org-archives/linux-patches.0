Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921BE1F708C;
	Tue, 21 Jan 2025 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482653; cv=none; b=M83DMqwMyj5ysjlfRoEJxTe/q3Bq6xrirbeFgkHORuQclbHYivr89erAaa0ZkDI0ZwTWMtW7PDK5WNF0HhFQXqsCQJxDaXwVmk+vDIngA2836ABFyTXZop4FNsrhrA8Kw4hcVvbOqsolPGvxdWI6U80hf6XwV1tCdc5GOv4N+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482653; c=relaxed/simple;
	bh=R7rIrg2Uad/PB8V0YTB7TdFLhjlUMVJR47j71DeRu6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf2MQDDkcA9EyP5KF47X6SgMjzEeH/OEi+lGHMDqCBJZzymdbZigOfacxx5At2zQ/NRmuqrF0XXWi3CP6zh+MLCSODl6wArSAt272CCpwnGw6+5BZvdRl2gUuaoNSHHkVQMCvSO2oXc1IOqTL5p+5O7pXSXsyT/h82ohvi0JGaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1VLGdvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1VLGdvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102DBC4CEE1;
	Tue, 21 Jan 2025 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482653;
	bh=R7rIrg2Uad/PB8V0YTB7TdFLhjlUMVJR47j71DeRu6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1VLGdvpBiBb84/+prdYcRMC6qyM/eL270dTv9QgPEj+rT6k3B0UcZn/KaibT/h0K
	 gPqqp0AJ/Y9/KUyhqaOuXdlEnJ24q0w8ialWMqwYFmI/BL25I6PBqAKV0Rxu3mvXli
	 3JeRf9vP6AaOEWKEc1MSwyzHe9ni0k+xMPjuDsEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nelissen <marco.nelissen@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/64] iomap: avoid avoid truncating 64-bit offset to 32 bits
Date: Tue, 21 Jan 2025 18:52:26 +0100
Message-ID: <20250121174522.591576761@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 47f44b02c17de..70e246f7e8fe8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -907,7 +907,7 @@ static int iomap_write_delalloc_scan(struct inode *inode,
 		}
 
 		/* move offset to start of next folio in range */
-		start_byte = folio_next_index(folio) << PAGE_SHIFT;
+		start_byte = folio_pos(folio) + folio_size(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
-- 
2.39.5



