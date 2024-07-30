Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B743C1A76A4;
	Tue, 30 Jul 2024 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359906; cv=none; b=g0WUjHMsPRprHsHlbIqAHtfiGriunMmGvn4OvyPLY5xdMLpQhiMGojEjeZCt/IKwkXWG2kLBVxR+YTs2zuJvDofEO4AGOgNvE2YOQhhyIqDn1OUbpuolAf1VLWXv8xcqQGzFfmKqThxaryBMXQcwLPRrS02Pdk0hacUGWDCzXw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359906; c=relaxed/simple;
	bh=sGj2YVFjmvK54wXb425TaR8UU37j4RgbebOvZi2g7uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuupRcCZgZ2VJLVQpHRVJeTV9PNugq4LuaErk6d1oon48oRW0QabWu5w7K9MkNWhUM+Fln2/xBa5AjWczjpUAc6/OuCL9ddgEuFrwgWyQ29nBtA5t3etUuMBQs1C/DJ2oDtvvUx8YcSwsWcuDpvrPUW2IHsxSbtcyUVRfYWSuxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xC5o2v1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xC5o2v1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251BBC32782;
	Tue, 30 Jul 2024 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359906;
	bh=sGj2YVFjmvK54wXb425TaR8UU37j4RgbebOvZi2g7uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xC5o2v1QQExNQC8R/Qfal7HTw+4BzXGy1lXWvgsduUyKKTIqCy7jUpuUVTrM4sE9o
	 VCZgKTU+hmCicTk4t/92PNP2jHrwoKxY5A2EmYMkdaXA4PVPty2hIsKFWQXV8MujmA
	 KTRR9zaCSIGu7qdKHFI+dCHNw5JRKmFMLk0ToGOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+853d80cba98ce1157ae6@syzkaller.appspotmail.com,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 552/809] btrfs: fix extent map use-after-free when adding pages to compressed bio
Date: Tue, 30 Jul 2024 17:47:08 +0200
Message-ID: <20240730151746.558908502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 8e7860543a94784d744c7ce34b78a2e11beefa5c upstream.

At add_ra_bio_pages() we are accessing the extent map to calculate
'add_size' after we dropped our reference on the extent map, resulting
in a use-after-free. Fix this by computing 'add_size' before dropping our
extent map reference.

Reported-by: syzbot+853d80cba98ce1157ae6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/000000000000038144061c6d18f2@google.com/
Fixes: 6a4049102055 ("btrfs: subpage: make add_ra_bio_pages() compatible")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -514,6 +514,7 @@ static noinline int add_ra_bio_pages(str
 			put_page(page);
 			break;
 		}
+		add_size = min(em->start + em->len, page_end + 1) - cur;
 		free_extent_map(em);
 
 		if (page->index == end_index) {
@@ -526,7 +527,6 @@ static noinline int add_ra_bio_pages(str
 			}
 		}
 
-		add_size = min(em->start + em->len, page_end + 1) - cur;
 		ret = bio_add_page(orig_bio, page, add_size, offset_in_page(cur));
 		if (ret != add_size) {
 			unlock_extent(tree, cur, page_end, NULL);


