Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619484;
	b=wAqM5xlZBkzfKT2KsdkOVGrqa8gD3SdY1nETxX4mwKVe4K8HoiY26vh6NLA2rspJeG95
	 pHUXeQmMFIvZCF1CN3sWXL3S1pHWGYAHstZqglU3T8yapaOo0nifveNsXRON5arHzo+mw
	 z4Ky9ifNh5y2rcPWf1zlYU3st597S+006F7a43dEZV5Sc6t7WLm69KHarqz8DbMo0n/K5
	 L/Lam6ZgTja5BvzxONOG4yw0FtEPab3gy8TSP6ZQ3ZbT6nm0hhDomE33NO8BYd9Qn0EH4
	 mJO63TZRX9XyLUVLa8kir+yZcEq0HwRGwGt6Fy5B8KB6Eb5CER6fmT32LBQki0ZbMPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35mUGGiW9ob4H3hlrzDt/sBNJyh8rhhYLPJ7n2+RHC0=;
	b=dMh9O4DZWDV8zGJYo9X9fe5yRQD+VSthIDIAnO4F7Mn1cgzgvMRHfMNSi6aq/IuHCmJn
	 zctlgjZz5QUmMfQD0clepHrgutjNyazXrJesJ3yfaqH5wEfdCosdHefwkNs15uZF4ET4Y
	 Ih28fFpWnuIhpqfAI4kQMX2mF1O3JTyr07tsxGy0gk03ug2WXooqnJmT/1O3jnJ3jtuv5
	 Qs7MNuhbnzR5kvIacwQj6Eeir9fsudKURBB9MuhJR2aEtUrUVrs7qGekKuzho663jHApV
	 XBQmvK49poZh4FhbKzdbiyyW8wr0Rno+xvnN1IATYdzaSCwtT3btfvlfoqrQp39OiaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3ijYT8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A57606A32A;
	Wed, 25 Nov 2026 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3ijYT8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162841F000EF;
	Wed, 25 Nov 2026 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619484;
	bh=35mUGGiW9ob4H3hlrzDt/sBNJyh8rhhYLPJ7n2+RHC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3ijYT8zkkMdPJV3b1EG0CVPQqxX5miXg12mJ73tp4ksgenldT+hfBBSH7pnv08dO
	 6kJ4+xQXztDgUxGKVqXatCIzXgPTu46+QPf4DBKtfbw3lebX/UPEMi3woke3qctGzP
	 N7ZsXaDOe2K7cKhp7n24j1id0z4GAJ4GH3+P4DYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mani Tofigh <mt4022@columbia.edu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.3 0612/1005] btrfs: fix bio counter and bioc leak when async checksumming fails
Date: Wed, 25 Nov 2026 15:32:30 +0100
Message-ID: <20261125143836.079885429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mani Tofigh <mt4022@columbia.edu>

commit d27d0039bc1334be8a72c769e14c0b0c3efc317d upstream.

A single failed checksum allocation can make a later device replace
hang forever.  btrfs_submit_chunk() takes a dev-replace bio counter
reference and a bioc before it hands a write to the checksum worker.
If the checksum fails there (e.g., its allocation fails),
run_one_async_done() ends the bio but drops neither.  The counter then
never gets back to zero and the next replace waits for it:

  [ 8.369] BTRFS info (device ram0): dev_replace from /dev/ram0 (devid 1) to /dev/ram1 finished
  [41.534] INFO: task btrfscsum:80 blocked for more than 20 seconds.
  [41.534]  btrfs_rm_dev_replace_blocked+0x135/0x180
  [41.534]  btrfs_dev_replace_finishing+0xefe/0x13b0

The worker is only used when CONFIG_BTRFS_EXPERIMENTAL is off and the
checksum isn't a fast one, e.g., sha256.  We hit it on a sha256
filesystem.

We put the bioc and drop the counter in that error branch.  We also
put the bioc on the synchronous error path and on the btrfs_split_bio()
error path, which both only drop the counter.  With the fix, the
replace doesn't hang anymore.

This bug was identified and confirmed with the help of fault-injection
testing on a deterministic hypervisor currently under development.  Our
C reproducer however hits it within about 35s.

Fixes: f8a53bb58ec7 ("btrfs: handle checksum generation in the storage layer")
Fixes: c7c97ceff98c ("btrfs: handle bio_split() errors")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/bio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -634,6 +634,8 @@ static void run_one_async_done(struct bt
 
 	/* If an error occurred we just want to clean up the bio and move on. */
 	if (bio->bi_status) {
+		btrfs_put_bioc(async->bioc);
+		btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
 		btrfs_bio_end_io(async->bbio, bio->bi_status);
 		return;
 	}
@@ -772,6 +774,7 @@ static bool btrfs_submit_chunk(struct bt
 		split = btrfs_split_bio(fs_info, bbio, map_length);
 		if (IS_ERR(split)) {
 			status = errno_to_blk_status(PTR_ERR(split));
+			btrfs_put_bioc(bioc);
 			btrfs_bio_counter_dec(fs_info);
 			goto end_bbio;
 		}
@@ -832,6 +835,7 @@ done:
 	return map_length == length;
 
 fail:
+	btrfs_put_bioc(bioc);
 	btrfs_bio_counter_dec(fs_info);
 	/*
 	 * We have split the original bbio, now we have to end both the current


