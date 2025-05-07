Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662771482F5;
	Wed,  7 May 2025 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644340; cv=none; b=RjHmvELSFbDVQeZ+a4DiW5NgscUArX/L7P17+9iZ59TZ5luvTrev1F32H0l2jhD5fvkNAnxg7B7IcyYefafeCPNKBtFbZRCMuCldC3/WieKeO9j+PyhvYHI2LaWEASBR+u5L9gHyPpJqdJfSgVF7TQw8hcYSZb632cPytInU52w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644340; c=relaxed/simple;
	bh=MVM/cf301tx3eHUhFLKG7cFgwZ3to+FnjlqtjSkAqhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYJ6wfoVHvHz8dsTATVczmnHIVnXMYEovwNIdKX35rCVGQa2TWzW/pBFO9YsyvUmyZAGpgt43DfLuLCJqXYOQt0q8mWTm9FwfSvcrD7omF1IhGJQ00IiBjomO5tEnmvIQR3uVU28Qr7zyJQvVT7Jo9fVKSoGsJSTrm6dRng/e3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AN/WJfTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AN/WJfTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2745C4CEE2;
	Wed,  7 May 2025 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644340;
	bh=MVM/cf301tx3eHUhFLKG7cFgwZ3to+FnjlqtjSkAqhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AN/WJfTq1Rt9hD/KAzdhc/4e6H2TrBK+Vv1BZeriETA7pNDgX/SEw/vIb2rhc6Wv/
	 gUUqEbzu8mjRCR3FgVQsW7LCLhXTgtbo+yp/8hqbYCa91fctZh3KjZQdoydq5STrwg
	 acbOk6pZv9De6o1SE6OrfFdwseuCaMeQMC307oI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dave Chen <davechen@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 012/164] btrfs: fix COW handling in run_delalloc_nocow()
Date: Wed,  7 May 2025 20:38:17 +0200
Message-ID: <20250507183821.335963033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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
@@ -2155,12 +2155,13 @@ next_slot:
 
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


