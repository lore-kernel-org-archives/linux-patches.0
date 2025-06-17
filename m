Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244332ED86F;
	Tue, 17 Jun 2025 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175036; cv=none; b=Z5mT7KuBlgOqmAeFau9iDvIuzcos/tcivy/XjdxGuDHYfZUsb3kb08N0EZw5I4ltbXFMoYgC01rFJ2l0vmbKPJLIB6mknZ7dgJ+P/gF2Mqj2pehnfA7RL8rKXMEflLiWrC2TSB5I3BC0d8wrUryHnBnTq1D9nGC056MtPeBF4fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175036; c=relaxed/simple;
	bh=6eiU5zB60D2Sq6XZqCIwbUN3pSy/aNuG63+MQcNF56o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzyWtwwSFsfseMz8OSOwPKkVWfQA31Ijgyzy3ucQY0NXXFEBD5ak6KC2KQMzBKXx8lk7gQ4IBknKiHm7Fd7bOUZLSLQzqj2LHocUac3rrcIYoeF8gTz4XDxiviKDs3QLJmx2Foz2puUonUjp+KNiEd4PfLX0zpV3YY859uEC9hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK95iimu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK95iimu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819DCC4CEF0;
	Tue, 17 Jun 2025 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175036;
	bh=6eiU5zB60D2Sq6XZqCIwbUN3pSy/aNuG63+MQcNF56o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK95iimuuPGFoxjxblSaICYHAreMfTcpaQMdn4jqbw6wLcqg4TuyN9o6wrTNPYAtO
	 IlI9aelCTxWFkUVyeR46fYuGX7fEOaLXk7KXMpfvHJHj/YAIYMJRSQDWO6W9H8X7oz
	 8RomzbtRp3PbUrsAKEDZu2+XktcBq2TZWUyc76rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 043/780] btrfs: fix wrong start offset for delalloc space release during mmap write
Date: Tue, 17 Jun 2025 17:15:51 +0200
Message-ID: <20250617152453.250268273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 71b8a825c4479..22455fbcb29eb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1862,7 +1862,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
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



