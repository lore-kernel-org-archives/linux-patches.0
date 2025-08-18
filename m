Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4637335BA2;
	Mon, 18 Aug 2025 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524458; cv=none; b=cfqmwlkNtM27/fVoWa8GtjgJFCTLI5j0RbX82dcbz54P99gcbSSnAk1EAYdlb31SSQpuVLGSmG4IZkMgz0OcldlhVFWFc5YY3z6I6ALUg4WeTNuDi5iEfNzMyOECZzmm/xuYhlsMthLIJNJh8K1KLRoLm5BQtc+Z2Tn2mk1avCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524458; c=relaxed/simple;
	bh=mqgIqU8Uqk7uVSRDHthPp34yM0KjQmf6BkH6Zu/3B+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IV/p6BHLCIRFDegmoDuhEJVAeOtXx72DOIKYoEGVEuFH480Yjn21hp1WvptP/XakhksUYUXwBb/ziYqRuPbMo5z30myq7BU9wrXIFCD8XkafAGy9zaimcdjY9xdm6DOGf4s1rf9DJdry48JBj8liqAXU+lWKkvd7S/LVsmGOgeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tC39Nbut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC39Nbut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEB9C4CEEB;
	Mon, 18 Aug 2025 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524458;
	bh=mqgIqU8Uqk7uVSRDHthPp34yM0KjQmf6BkH6Zu/3B+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC39NbutYYwPWM8V4aOXEJ4dhNUkXEn5g7wIqXwG0jL3MlQvI0Fi6ak6XN25klZve
	 2PVlJ3KgzzUQnaJmPxjeMFS+SXSQGhtBsIXKK/t+ax4CCRFQc0jYdvSvY8se0SxLv8
	 UoCne1jcziqBsplyClGtTfFmJmkoiEu5Xeq5rIEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 479/515] btrfs: fix wrong length parameter for btrfs_cleanup_ordered_extents()
Date: Mon, 18 Aug 2025 14:47:45 +0200
Message-ID: <20250818124516.862076077@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit deaf895212da74635a7f0a420e1ecf8f5eca1fe5 upstream.

Inside nocow_one_range(), if the checksum cloning for data reloc inode
failed, we call btrfs_cleanup_ordered_extents() to cleanup the just
allocated ordered extents.

But unlike extent_clear_unlock_delalloc(),
btrfs_cleanup_ordered_extents() requires a length, not an inclusive end
bytenr.

This can be problematic, as the @end is normally way larger than @len.

This means btrfs_cleanup_ordered_extents() can be called on folios
out of the correct range, and if the out-of-range folio is under
writeback, we can incorrectly clear the ordered flag of the folio, and
trigger the DEBUG_WARN() inside btrfs_writepage_cow_fixup().

Fix the wrong parameter with correct length instead.

Fixes: 94f6c5c17e52 ("btrfs: move ordered extent cleanup to where they are allocated")
CC: stable@vger.kernel.org # 6.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2028,7 +2028,7 @@ static int nocow_one_range(struct btrfs_
 	 * cleaered by the caller.
 	 */
 	if (ret < 0)
-		btrfs_cleanup_ordered_extents(inode, file_pos, end);
+		btrfs_cleanup_ordered_extents(inode, file_pos, len);
 	return ret;
 }
 


