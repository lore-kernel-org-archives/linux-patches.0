Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620C82DC34C;
	Tue,  8 Jul 2025 16:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992877; cv=none; b=LeVyL78duwU6dYqL/3Eg1WvDR4gJypvIHDGERXXgBlQvzp3Xx0RN2wtKrUNw3jfWO9ohs3pOalt75ArFi9OYe10F+Vc74LrDLv/D4HK2WH/82MaN8BtyeKMq1IXirq46XuiB2b1zYtGhmVtSeK5yIO1NHNBlZz95uNMDuSy66Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992877; c=relaxed/simple;
	bh=QE6S2vLUvPYo4UQbfLU7hxLrKSQyTw0qbR2flrULuxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaCLMOVVeKnei3YU6z4fGtLXYxtUFThwOdeCdANVys4niFSGi9nJ24V4qLWeNW7p5kMvidmMFtVymzvb3UqepwrkpghnRl156DpD8pxh60ESS7iLiAaZAp4MzqNmvmiSkePYVE/bmWHPbj8Ce8NQ2mglQLJqTLnQ8tAblWSNyNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHV6EyMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHV6EyMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0531C4CEED;
	Tue,  8 Jul 2025 16:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992877;
	bh=QE6S2vLUvPYo4UQbfLU7hxLrKSQyTw0qbR2flrULuxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHV6EyMyhktncgQkpgr2hrXH6DH0gnB1r49hBsTRsawFjmcnlT1H1Nc/29RboP35p
	 Cur3ScM52fxT6ULZFy9WcMbhtdU2qYIaeVkQhbwvQ3souqKQXou2wTdUzBpbc7R/ux
	 5rZhPl1+Ksw0nX2PcF6tFVy7076NqrSCazCnQt4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/232] btrfs: fix wrong start offset for delalloc space release during mmap write
Date: Tue,  8 Jul 2025 18:21:48 +0200
Message-ID: <20250708162244.367539013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 17a85f520469a1838379de8ad24f63e778f7c277 ]

If we're doing a mmap write against a folio that has i_size somewhere in
the middle and we have multiple sectors in the folio, we may have to
release excess space previously reserved, for the range going from the
rounded up (to sector size) i_size to the folio's end offset. We are
calculating the right amount to release and passing it to
btrfs_delalloc_release_space(), but we are passing the wrong start offset
of that range - we're passing the folio's start offset instead of the
end offset, plus 1, of the range for which we keep the reservation. This
may result in releasing more space then we should and eventually trigger
an underflow of the data space_info's bytes_may_use counter.

So fix this by passing the start offset as 'end + 1' instead of
'page_start' to btrfs_delalloc_release_space().

Fixes: d0b7da88f640 ("Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 86e7150babd5c..0e63603ac5c78 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1992,7 +1992,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 		if (reserved_space < fsize) {
 			end = page_start + reserved_space - 1;
 			btrfs_delalloc_release_space(BTRFS_I(inode),
-					data_reserved, page_start,
+					data_reserved, end + 1,
 					fsize - reserved_space, true);
 		}
 	}
-- 
2.39.5



