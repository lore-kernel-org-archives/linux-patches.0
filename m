Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774989;
	b=LZJOAu5H3uLuox0Wrfw8rN0xWKwnB27SdlNkaz6wP0HWTqGZFMqVtndBkdje3CoDoyyb
	 OXPyTmbYTopJtyjLwG3tSgK0hrzYnE1ewfELKlV/o3PTj4ftkxi8H3b+UoXG2C44gOUp8
	 DPIOkKeHqGZof4ygAWJczurphR/yQyKOhzzNRYoWc3QEpfweQ9OPOiGta1zFBwDcpJlUH
	 nuBMCZD4fMqStJgo+s0OxxhgLvx1wcwuG0T5PSjBRsgcP2jAheVJEjNG+qFCKPhA2VhR5
	 d625P3Kl1CZlbbq2PHBIR05SkialDXbtXgA/HUdQGHPXXL3aR5YPvef2V4JKWhEsH+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ps8In7hRhA9V8zMYlWZHpp08ROnBDdLfOptfqkJh2yY=;
	b=1+HCV0iZJLZDFyeS0N1WQnX/K2wxmGCK1pLGP4vr9SOXoM3bNxLeYYjGlL/ZnERJm/Q/
	 qu3KF5Prd2+crLRc6VEIVU0oEWebbU+p4DuAe3GILU8jOR7/z5cWsMCCWbtPyekTx3Jfq
	 LNL/UEfUo8AySHPyxbN1BpR8MX+EBZchG26Rg1iaGY/fwD1VYpk7jA7Nj+88/px0V5agE
	 1SGNVAsydPcuWthzlwqv/SzKXbOmrTTL8KLKiXvIL3N+RFhbVsyuUybUdTm7WWuRG1vkq
	 bhAzm1+pTn/P6IMYBvJF89jul3dt2Dhw/M7UPo/TrSzaMFpZVuCjbF0G89f+0b/F3xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3LEjT0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECA2606A31A;
	Fri, 23 Oct 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3LEjT0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B081F01825;
	Fri, 23 Oct 2026 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774988;
	bh=ps8In7hRhA9V8zMYlWZHpp08ROnBDdLfOptfqkJh2yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3LEjT0bcsmKWk/uViYffyYNWSnHAfOSoIR1HRbayA3KM6Du3Sb0P2OPdsdQqTwPv
	 elgvNJryF931w/g7falapaIqrIOim4lRSfa9FDnhM37DFGrRwJhpNitqcgNe9T1v4L
	 oD2zv8DgLeQexu0ES1jwSaZwfJfYOCVEZ3xO2d7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Labardi <jacopolabardi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 225/242] ntfs: fix FITRIM range alignment
Date: Fri, 23 Oct 2026 18:41:07 +0200
Message-ID: <20261023163719.159193934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Labardi <jacopolabardi@gmail.com>

commit 03c6ecc4b4b13a3901f207152451fdd2d82e40c4 upstream.

ntfs_trim_fs() aligns the start of a free extent up to the device discard
granularity, but derives the discard length by aligning the original extent
length down. When the free extent start is not discard-aligned, adding that
length to the aligned start can extend the discard past the free extent and
into allocated clusters.

For example, with 4 KiB clusters and 32 KiB discard granularity, the free
extent [4 KiB, 36 KiB) becomes the discard range [32 KiB, 64 KiB), so
28 KiB beyond the free extent may be discarded.

Align the absolute end of the free extent down and derive the length from
the two aligned endpoints. Skip extents that contain no full discard unit.

Reproduced with a 4 KiB-cluster NTFS filesystem on scsi_debug configured
for 32 KiB discard granularity and read-zero-after-trim. Before this
change, FITRIM zeroed seven allocated 4 KiB clusters following an unaligned
32 KiB hole. With this change, the same data remains intact across FITRIM
and remount.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI Codex:GPT-5.6 Sol Max
Signed-off-by: Jacopo Labardi <jacopolabardi@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/bitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ntfs/bitmap.c
+++ b/fs/ntfs/bitmap.c
@@ -64,7 +64,7 @@ int ntfs_trim_fs(struct ntfs_volume *vol
 
 		end = start_buf;
 		while (end < end_buf) {
-			u64 aligned_start, aligned_count;
+			u64 aligned_start, aligned_end, aligned_count;
 			u64 start = find_next_zero_bit(bitmap, end_buf - start_buf,
 					end - start_buf) + start_buf;
 			if (start >= end_buf)
@@ -74,8 +74,10 @@ int ntfs_trim_fs(struct ntfs_volume *vol
 					start - start_buf) + start_buf;
 
 			aligned_start = ALIGN(ntfs_cluster_to_bytes(vol, start), dq);
-			aligned_count =
-				ALIGN_DOWN(ntfs_cluster_to_bytes(vol, end - start), dq);
+			aligned_end = ALIGN_DOWN(ntfs_cluster_to_bytes(vol, end), dq);
+			if (aligned_start >= aligned_end)
+				continue;
+			aligned_count = aligned_end - aligned_start;
 			if (aligned_count >= range->minlen) {
 				ret = blkdev_issue_discard(vol->sb->s_bdev, aligned_start >> 9,
 						aligned_count >> 9, GFP_NOFS);


