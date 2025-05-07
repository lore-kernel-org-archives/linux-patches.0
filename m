Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A34211283;
	Wed,  7 May 2025 18:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643788; cv=none; b=Or4UlPRddMYSWkm0sYJUzDqc1O/+TNcIFet+ZZC/idCKG6L1QXPc7IO2uAxRtg9u3VnGWZJLL7N9PP/Q8BMx2y2NtzLD1zosFGNpjZkwuUclwPo8RlkX37ve7+menVtOAzVMAFfAfqsHj+KOJyJG3q7a+iUXrpC+KTbQV82rPRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643788; c=relaxed/simple;
	bh=Dr9QEsxxaKzJ0T3IPVuFNl0RuJa4V6cG8FOVUozKoAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGxqXYqflEuwOCMeLU6gdtUYBj19vzJ9fMzWGjCPVxyYE0OkanErX/O0SZZPIS5dFSvgJBj42vM2S8cZONMWeGAo0yiewv2szEznonLx2Rb7kSx5/IhAI/ey6ZLmbVNBffYHGfiKXB+qiDi71tbdN2PWbfoddUt8Nvvl7yBy42o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz/TkrD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz/TkrD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA019C4CEE9;
	Wed,  7 May 2025 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643788;
	bh=Dr9QEsxxaKzJ0T3IPVuFNl0RuJa4V6cG8FOVUozKoAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sz/TkrD1IkAcUM0+COZz0VVrY0XBZiwZ8GecX7NaCPoLRFnaM0I9bMzEF7LZHL/L1
	 4MkgO2Qjw8lGnh9KI1CS+Ke7exPniQshVE5UvOAbQUoMDtM/gYW7UjA46jclg0r1uc
	 r6uV9xvdLH3t7Mb6QchQYl76IrKuCbixhqEW5Wqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dave Chen <davechen@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 007/183] btrfs: fix COW handling in run_delalloc_nocow()
Date: Wed,  7 May 2025 20:37:32 +0200
Message-ID: <20250507183824.989772256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chen <davechen@synology.com>

commit be3f1938d3e6ea8186f0de3dd95245dda4f22c1e upstream.

In run_delalloc_nocow(), when the found btrfs_key's offset > cur_offset,
it indicates a gap between the current processing region and
the next file extent. The original code would directly jump to
the "must_cow" label, which increments the slot and forces a fallback
to COW. This behavior might skip an extent item and result in an
overestimated COW fallback range.

This patch modifies the logic so that when a gap is detected:

- If no COW range is already being recorded (cow_start is unset),
  cow_start is set to cur_offset.

- cur_offset is then advanced to the beginning of the next extent.

- Instead of jumping to "must_cow", control flows directly to
  "next_slot" so that the same extent item can be reexamined properly.

The change ensures that we accurately account for the extent gap and
avoid accidentally extending the range that needs to fallback to COW.

CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2083,12 +2083,13 @@ next_slot:
 
 		/*
 		 * If the found extent starts after requested offset, then
-		 * adjust extent_end to be right before this extent begins
+		 * adjust cur_offset to be right before this extent begins.
 		 */
 		if (found_key.offset > cur_offset) {
-			extent_end = found_key.offset;
-			extent_type = 0;
-			goto must_cow;
+			if (cow_start == (u64)-1)
+				cow_start = cur_offset;
+			cur_offset = found_key.offset;
+			goto next_slot;
 		}
 
 		/*


