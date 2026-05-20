Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B5129B8D0;
	Wed, 20 May 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301719; cv=none; b=qOSbYPmQSItky3x19MaVNNyxN+nnK9UfYgtZvgHz/DLndt12xxbCJJOojV67oQ/PPEvz+2QA2uHFHsOS4RASH7pdePrOR2Ej0X/UHC8DHqIiMmP41ZS54rt0TsyKrIcvxtdxdY2azarbJzvMrY+KgK7k5uLQsiKNzKIFqTFcIdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301719; c=relaxed/simple;
	bh=FxLNsJxlAJOITeK2znjCRnocbJSzSK9UlUY1EHTDMps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZrMia9sLanu8Awu66/TgbUsh2GIZViF1OOzo2h3oljA7+LWLqHfKcFi06G2RFUFTCYike/57/GR+YMsvu6hDMqJEHLsQgnCHB8YUtPs95udXJywvKI7YIpjW8Go5sRDWQDC8dlNAjYILL7IjtXzaVf6aEMxlQx4Gc1a/QESxz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaTTrqun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaTTrqun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D011F000E9;
	Wed, 20 May 2026 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301718;
	bh=N/LdKMJVxaHCpkTShwxmh6IQocTaWXb+w8r1mYxdJlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaTTrqunvMcqLe9kiSHFyn2jodKsw40K+sSGyYct+fhO7b34BvQlaeSZ8Z96lEwWs
	 LOJ1lYVCnuMYA410DoPDHbxWaeqOHeWfm8JLQkTjgEhtcFNdsGhuXMS405WK4TqxXt
	 TEXJUcZRdzhiZFa9d+Qx6D76zNaN+xUBYr0UW9Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 654/666] btrfs: do not mark inode incompressible after inline attempt fails
Date: Wed, 20 May 2026 18:24:25 +0200
Message-ID: <20260520162125.459528520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 2e0e3716c7b6f8d71df2fbe709b922e54700f71b ]

[BUG]
The following sequence will set the file with nocompress flag:

  # mkfs.btrfs -f $dev
  # mount $dev $mnt -o max_inline=4,compress
  # xfs_io -f -c "pwrite 0 2k" -c sync $mnt/foobar

The inode will have NOCOMPRESS flag, even if the content itself (all 0xcd)
can still be compressed very well:

	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 10 size 2097152 nbytes 1052672
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 257 flags 0x8(NOCOMPRESS)

Please note that, this behavior is there even before commit 59615e2c1f63
("btrfs: reject single block sized compression early").

[CAUSE]
At compress_file_range(), after btrfs_compress_folios() call, we try
making an inlined extent by calling cow_file_range_inline().

But cow_file_range_inline() calls can_cow_file_range_inline() which has
more accurate checks on if the range can be inlined.

One of the user configurable conditions is the "max_inline=" mount
option. If that value is set low (like the example, 4 bytes, which
cannot store any header), or the compressed content is just slightly
larger than 2K (the default value, meaning a 50% compression ratio),
cow_file_range_inline() will return 1 immediately.

And since we're here only to try inline the compressed data, the range
is no larger than a single fs block.

Thus compression is never going to make it a win, we fall back to
marking the inode incompressible unavoidably.

[FIX]
Just add an extra check after inline attempt, so that if the inline
attempt failed, do not set the nocompress flag.

As there is no way to remove that flag, and the default 50% compression
ratio is way too strict for the whole inode.

CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1085,6 +1085,12 @@ again:
 			mapping_set_error(mapping, -EIO);
 		goto free_pages;
 	}
+	/*
+	 * If a single block at file offset 0 cannot be inlined, fall back to
+	 * regular writes without marking the file incompressible.
+	 */
+	if (start == 0 && end <= blocksize)
+		goto cleanup_and_bail_uncompressed;
 
 	/*
 	 * We aren't doing an inline extent. Round the compressed size up to a


