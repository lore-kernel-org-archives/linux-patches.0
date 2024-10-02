Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E640E29CE7;
	Wed,  2 Oct 2024 13:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876946; cv=none; b=pLsu3WDeGQsJsTjJ3aNtjr5ghlBPQDyO2i35EoPI6tFQTubef/Jl1Mui9ryf1fWSo2M3FQETL7NPhYZYE0pT5f+nJlgPnN3bOY59w2YkxTiDyHdB/IUlYPObvezRo3epRnKEgw8XMX7gnaHdfR2wIEJopAvZd1se8EAGF19Mad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876946; c=relaxed/simple;
	bh=656H5++SlQSBganDHfwxVVBg6vVvbKoHSPcG35nB4Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbtKKXqrhpG7JDXDTr8LIXuuIm0bMR8RaAMWvWRYsAy31pdWG2w+T0HQs9XtqtjH7uOS9DNYRWx+4+kCYE9D13H8SB5B2htPXjP0sFktO+7mqJsLW4DpeyDh9R/fR2K9oJRo61+EcBC5UgnGOqpAW3u/3Ua1An3IWqb7kKMGaSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVOpOK7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVOpOK7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F086C4CEC2;
	Wed,  2 Oct 2024 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876945;
	bh=656H5++SlQSBganDHfwxVVBg6vVvbKoHSPcG35nB4Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVOpOK7V6phLL5w/rAIHo8aVnUPp+yq9/F2YkConQ1OSZzpqXFcTOJsS3Zos1EFd+
	 If3gEaPw4AErv6pD8/EhqN0Ymvk7y3uxgBNCMV7gghjBPqiRhuMITtMSHWm5PGkfkE
	 sHKozGQMIpyNKthuZtpD8nTYTRI9qldOK5jYQ8ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 613/695] btrfs: subpage: fix the bitmap dump which can cause bitmap corruption
Date: Wed,  2 Oct 2024 15:00:11 +0200
Message-ID: <20241002125846.981827639@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 77b0b98bb743f5d04d8f995ba1936e1143689d4a upstream.

In commit 75258f20fb70 ("btrfs: subpage: dump extra subpage bitmaps for
debug") an internal macro GET_SUBPAGE_BITMAP() is introduced to grab the
bitmap of each attribute.

But that commit is using bitmap_cut() which will do the left shift of
the larger bitmap, causing incorrect values.

Thankfully this bitmap_cut() is only called for debug usage, and so far
it's not yet causing problem.

Fix it to use bitmap_read() to only grab the desired sub-bitmap.

Fixes: 75258f20fb70 ("btrfs: subpage: dump extra subpage bitmaps for debug")
CC: stable@vger.kernel.org # 6.6+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/subpage.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -900,8 +900,14 @@ void btrfs_folio_end_all_writers(const s
 }
 
 #define GET_SUBPAGE_BITMAP(subpage, subpage_info, name, dst)		\
-	bitmap_cut(dst, subpage->bitmaps, 0,				\
-		   subpage_info->name##_offset, subpage_info->bitmap_nr_bits)
+{									\
+	const int bitmap_nr_bits = subpage_info->bitmap_nr_bits;	\
+									\
+	ASSERT(bitmap_nr_bits < BITS_PER_LONG);				\
+	*dst = bitmap_read(subpage->bitmaps,				\
+			   subpage_info->name##_offset,			\
+			   bitmap_nr_bits);				\
+}
 
 void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 				      struct folio *folio, u64 start, u32 len)


