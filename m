Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF244346E51;
	Fri, 21 Nov 2025 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731462; cv=none; b=NxVwkhjJkdxQdFOUmo6P2psXYkbtOBuuMLSPjgyE2OImIB60v7JjI2qBCZljqAGfrB3URbaE90hE+CDpN3Nf3GqkNozYkJMXkecJzn4q41HV7sLxepZsNDtxWRvr9A6STftw7BdnfUj63Yy/RzDDVoCoIjxd+0JV0eR7v39rXKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731462; c=relaxed/simple;
	bh=xsNsYAHAxE8HPXcabsW+h1TKHgMLrgIctKwW0d2czd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGhv8R5xzkTkT4She3wamxSdcg5II9YOxZIHq4BEYGrL55DvZuz4Pdf3jCJt3p8RM3bCOo1VMHHHeQ5mpCBwVDjzTxtIXgYzw47zoOLg6PafwYfyUQ3rW+0qZtQL+qa83/Pf1gBe6SC8+XB+sRxaqXxk1Gc/WcWtL5+gWQVs/9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J17QLr6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J17QLr6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF10C4CEFB;
	Fri, 21 Nov 2025 13:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731462;
	bh=xsNsYAHAxE8HPXcabsW+h1TKHgMLrgIctKwW0d2czd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J17QLr6H7lzrNQOAI1BGw09p6reVzm4aKh1J+5ntf7xou0kDCb68FVhua3dHgS6Po
	 Vx7NaRayzWwhXA3SqQfQwWAn89925JtWoMXNLYU/rAvhZfS6ogzOcejgotfjWLJnKz
	 T/f7eKA1vSFzPn9MiLLmlykWKIzL7d3v56hgljaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 216/247] btrfs: scrub: put bio after errors in scrub_raid56_parity_stripe()
Date: Fri, 21 Nov 2025 14:12:43 +0100
Message-ID: <20251121130202.484252792@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2185,6 +2185,7 @@ static int scrub_raid56_parity_stripe(st
 	ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, full_stripe_start,
 			      &length, &bioc, NULL, NULL);
 	if (ret < 0) {
+		bio_put(bio);
 		btrfs_put_bioc(bioc);
 		btrfs_bio_counter_dec(fs_info);
 		goto out;
@@ -2194,6 +2195,7 @@ static int scrub_raid56_parity_stripe(st
 	btrfs_put_bioc(bioc);
 	if (!rbio) {
 		ret = -ENOMEM;
+		bio_put(bio);
 		btrfs_bio_counter_dec(fs_info);
 		goto out;
 	}


