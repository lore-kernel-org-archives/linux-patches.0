Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532CD1D0E24;
	Wed,  2 Oct 2024 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878829; cv=none; b=iXXXuzajdCCYN0gN1gA5o7o0XrZXi0h7hQryqsG6cM+IACWcKe4Fi3iZqQmUJEfbX8XfEYI1amlPj7y9O5D20p/0EVgSn8eAfrS7QrHYF3TX+NNV2s5+9mm6X5W38DdK6BhfZ8H6nkK0D0iHj5zmEv4a6YvOkFVinSI9DflXe7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878829; c=relaxed/simple;
	bh=h51YllwGyk9Ng0PKhUjh5R8WJQeZTONkDtEeza75yoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYTdksv/Yga8HMAOSjNJ0ktgiusv1/NPLej7V+VfnJKqr3iHYH8LUWi0x/RZqTyoqtMLsxfndmjidcB+idCnakmIhzPmh3tsfJh7NEn7hVr6Er3BT/JuCnuEdAtA2kB4z9iytoEG9covuN+UlO1KEjyyG9WUnjFzflMVb/VmEIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACtltaBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACtltaBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2147C4CEC2;
	Wed,  2 Oct 2024 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878829;
	bh=h51YllwGyk9Ng0PKhUjh5R8WJQeZTONkDtEeza75yoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACtltaBZhyhMr825QwyZ2oR1Tcm5MmBMOQ/zDWXM6VP5CQlCM+5VtWw7ciE1JCCNK
	 w0BlT29RHE/xbI+IRxvVCSdXLlQefu+q3+xBdjyExqjMbozd1V5k6M3h0VO3cHMWzl
	 LkwgY76EggvQbOoqpIgx1ZhzB2rA/Jc4GCDPdODI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 547/634] btrfs: subpage: fix the bitmap dump which can cause bitmap corruption
Date: Wed,  2 Oct 2024 15:00:47 +0200
Message-ID: <20241002125832.700839535@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -766,8 +766,14 @@ void btrfs_folio_unlock_writer(struct bt
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


