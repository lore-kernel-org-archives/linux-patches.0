Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C81211283;
	Wed,  7 May 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643785; cv=none; b=eCGp9X5+K4xgFhDlezZbV7eEYvzzAgNPwJNZAqKLcbGKt0rs/C11aS/Z04xZW8QOF8UGNmrKVWpWtMKK3dli2WAV3P5PQiZ+Olpgxcwt2BwFbREdQsRzts3qGqnZ7HLll+J6SNHLRy5Qa79vjX1mKp1K+F7BQ33iX4vDRQl71NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643785; c=relaxed/simple;
	bh=BVBpZRnGcGi9A6Kv/Kj5Wm467zQdfPEZOdI9yEnzryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAUhWbCjudDGX6G824lO0Ltqul8P9t3xmkKZs3ef6qUFyRDQ4dmiN24pLxoKXOl75HY06g4HFDNcRFXz5rc6tDYlTxflNBPPuw+uWl8F88ED9tMAUAU4d1+Ciy/RzL1ipGH90SL1+AV1eq6yAnby7lhf0Bg0viyMIBUrGWhAS+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GD9xfEba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GD9xfEba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6005C4CEE2;
	Wed,  7 May 2025 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643785;
	bh=BVBpZRnGcGi9A6Kv/Kj5Wm467zQdfPEZOdI9yEnzryg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GD9xfEbaNclCu2RsTrA2g6Ty1eFHBQoV/xgwDytXpLxtds9eQAeKugYf6mTK6Fn/a
	 +11PyrHM1iuP23jwMTZhpZGRHQYieMRL1jr1yfR753Y5B/PihDtEHK8AI6t4nmPGbZ
	 61b46GUt7TGpFxLmv+A9r8fGF0pZjZF3+/fq8A2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 006/183] btrfs: adjust subpage bit start based on sectorsize
Date: Wed,  7 May 2025 20:37:31 +0200
Message-ID: <20250507183824.945483289@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit e08e49d986f82c30f42ad0ed43ebbede1e1e3739 upstream.

When running machines with 64k page size and a 16k nodesize we started
seeing tree log corruption in production.  This turned out to be because
we were not writing out dirty blocks sometimes, so this in fact affects
all metadata writes.

When writing out a subpage EB we scan the subpage bitmap for a dirty
range.  If the range isn't dirty we do

	bit_start++;

to move onto the next bit.  The problem is the bitmap is based on the
number of sectors that an EB has.  So in this case, we have a 64k
pagesize, 16k nodesize, but a 4k sectorsize.  This means our bitmap is 4
bits for every node.  With a 64k page size we end up with 4 nodes per
page.

To make this easier this is how everything looks

[0         16k       32k       48k     ] logical address
[0         4         8         12      ] radix tree offset
[               64k page               ] folio
[ 16k eb ][ 16k eb ][ 16k eb ][ 16k eb ] extent buffers
[ | | | |  | | | |   | | | |   | | | | ] bitmap

Now we use all of our addressing based on fs_info->sectorsize_bits, so
as you can see the above our 16k eb->start turns into radix entry 4.

When we find a dirty range for our eb, we correctly do bit_start +=
sectors_per_node, because if we start at bit 0, the next bit for the
next eb is 4, to correspond to eb->start 16k.

However if our range is clean, we will do bit_start++, which will now
put us offset from our radix tree entries.

In our case, assume that the first time we check the bitmap the block is
not dirty, we increment bit_start so now it == 1, and then we loop
around and check again.  This time it is dirty, and we go to find that
start using the following equation

	start = folio_start + bit_start * fs_info->sectorsize;

so in the case above, eb->start 0 is now dirty, and we calculate start
as

	0 + 1 * fs_info->sectorsize = 4096
	4096 >> 12 = 1

Now we're looking up the radix tree for 1, and we won't find an eb.
What's worse is now we're using bit_start == 1, so we do bit_start +=
sectors_per_node, which is now 5.  If that eb is dirty we will run into
the same thing, we will look at an offset that is not populated in the
radix tree, and now we're skipping the writeout of dirty extent buffers.

The best fix for this is to not use sectorsize_bits to address nodes,
but that's a larger change.  Since this is a fs corruption problem fix
it simply by always using sectors_per_node to increment the start bit.

Fixes: c4aec299fa8f ("btrfs: introduce submit_eb_subpage() to submit a subpage metadata page")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1871,7 +1871,7 @@ static int submit_eb_subpage(struct foli
 			      subpage->bitmaps)) {
 			spin_unlock_irqrestore(&subpage->lock, flags);
 			spin_unlock(&folio->mapping->i_private_lock);
-			bit_start++;
+			bit_start += sectors_per_node;
 			continue;
 		}
 


