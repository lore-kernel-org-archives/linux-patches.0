Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B0134DB41;
	Fri, 21 Nov 2025 13:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733495; cv=none; b=YtrfcHllTgj7FLRwW1dzvzJnM/D3+zAndeIN4SAVoN+M2j0lOokt3CDrWqXNQ+XKf+i71e6btW4iTF+EqRiex0YzneCXfmbFU9LiDSUo1unlJgAjPjVHOlF0HCL98naE5+8dVNpP6Wl+sMWhP7uqayKQHm/UGt9R4EGTG2TOBmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733495; c=relaxed/simple;
	bh=ZnuY/hlAdJhvLtdW43LJkMWE9PL4eDPpztPS8lk6NQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImrbKyMa+rS+dfUuigYO/9EEHhrns35IHAUK2GGe7lbQeG2xu5ZUQEDe6vVll/aLU5jpw5JSVnZ6bfMZ2cQ7d0LCI3LGsMKja/0EZc8XzvWOnTi/DXGhxg6w764qzwX97CN+byGwvEppcdIBl7JZ3vOwqmQX1U430MyXmZ7R9bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znk3jNln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znk3jNln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789CBC4CEF1;
	Fri, 21 Nov 2025 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733494;
	bh=ZnuY/hlAdJhvLtdW43LJkMWE9PL4eDPpztPS8lk6NQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Znk3jNlnVNmj28DhI19OuEesjMGGb7DU98sfmUbsAeNeZfSiJ0QI8bj+3bmC2nRTi
	 2k9xgkZrGG1NdxuYgR7N0a0kKdMRE8aUqoTlPtgsK/hoEJ19AercADICwcN6LTD3AN
	 WPoEE55+nLU123uqXy6VIWeUJwhStg/Pz4OygKyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 486/529] btrfs: scrub: put bio after errors in scrub_raid56_parity_stripe()
Date: Fri, 21 Nov 2025 14:13:05 +0100
Message-ID: <20251121130248.299131091@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

commit 5fea61aa1ca70c4b3738eebad9ce2d7e7938ebbd upstream.

scrub_raid56_parity_stripe() allocates a bio with bio_alloc(), but
fails to release it on some error paths, leading to a potential
memory leak.

Add the missing bio_put() calls to properly drop the bio reference
in those error cases.

Fixes: 1009254bf22a3 ("btrfs: scrub: use scrub_stripe to implement RAID56 P/Q scrub")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2000,6 +2000,7 @@ static int scrub_raid56_parity_stripe(st
 	ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, full_stripe_start,
 			      &length, &bioc, NULL, NULL, 1);
 	if (ret < 0) {
+		bio_put(bio);
 		btrfs_put_bioc(bioc);
 		btrfs_bio_counter_dec(fs_info);
 		goto out;
@@ -2009,6 +2010,7 @@ static int scrub_raid56_parity_stripe(st
 	btrfs_put_bioc(bioc);
 	if (!rbio) {
 		ret = -ENOMEM;
+		bio_put(bio);
 		btrfs_bio_counter_dec(fs_info);
 		goto out;
 	}


