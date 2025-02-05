Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267361519AF;
	Wed,  5 Feb 2025 14:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765865; cv=none; b=qMlAC5MxTMDdJMyW5eURmeEz/Lscch5lZs3pZQOsJCjE558PMzLoxUPpCSFEBjFNnFBJQ9+tXm80MigWO8mt0eRPVQW784evBL2RGjpkLuTsOoZVkH7cY5gtOrjdo5A/KjXW/ID5BFSG/CW2afKLWS19hd4qC9MQcuMhc3mHI+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765865; c=relaxed/simple;
	bh=iNYRitCvQ8fMzjkWjEYUQRAUonrjDSls6koYYF9IKYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC9n1kP3NTzHtsT2mRxECEaeZ4PlOqAuhK82ejyjkMGdBAcKfp1s7k/kT7OoVqKMSMbAFUUJv7mSfNWn9djiGiH5QT9hYN99sox3+La9r606fpo8uPbDt8dgO2aICHYuQsRUhyLEzm23XrUCmgGN/mQhg8K5/IgsJY7l8LhVuVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IS5rehtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IS5rehtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219DEC4CED1;
	Wed,  5 Feb 2025 14:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765864;
	bh=iNYRitCvQ8fMzjkWjEYUQRAUonrjDSls6koYYF9IKYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IS5rehtfv75rJvuI/NybcfuOSo7w6Mz+nzu/jU3n4tfIb0/UzrTTpLCOqVS4strrl
	 bUPAcqhl+GAvIKyB7u29X5WT27E8012YTYti6UN03JPA3ZfY/otiHP2vJjy4gsKHbb
	 uGbVEQvM6PMt+FolBBt3rczZxqHuGGlMC3mku15Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/393] nilfs2: convert nilfs_lookup_dirty_data_buffers to use folio_create_empty_buffers
Date: Wed,  5 Feb 2025 14:43:46 +0100
Message-ID: <20250205134432.055134500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 922b12eff0b293fc13ae4045c7d7264e18938878 ]

This function was already using a folio, so this update to the new API
removes a single folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20231016201114.1928083-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 367a9bffabe0 ("nilfs2: protect access to buffers with no active references")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0610cb12c11ca..57b535921a73b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -731,10 +731,9 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 			continue;
 		}
 		head = folio_buffers(folio);
-		if (!head) {
-			create_empty_buffers(&folio->page, i_blocksize(inode), 0);
-			head = folio_buffers(folio);
-		}
+		if (!head)
+			head = folio_create_empty_buffers(folio,
+					i_blocksize(inode), 0);
 		folio_unlock(folio);
 
 		bh = head;
-- 
2.39.5



