Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171F186E3A;
	Sun,  1 Sep 2024 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209209; cv=none; b=q+qrMOjgtWhU17cq//se4n0ZAsevRtzlb49p47cj5WIkBnZZZzk7LF2Z+xCRTde1waFQmC9EC/GS8LJW7s10zcRCdo4sm6AC8Yq1gZTDlKYoG44dzIr0R6SmjO+/XeIJgAZ1Pt8GxFstymVYfjfzKn267PxxzJ7MYxLmZ39tnP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209209; c=relaxed/simple;
	bh=8OvfHofNySDWd/ztkLweigl2dZt5zDmrIHfUdJYHzs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFxHur9OPgK5UqPahAX4eb5XYkaWUhXM8TtGv4qDnG8oSv0Lzp3T7ZSyXCrGol853tlIdrceESIIYMNarnpSvGoY3dppt98dO9Fv9xi154ziYS0v3o1xioVQiEzKaY6P4HMxrNSoFH78oxzDtAVwSzURxQhaQhI7BcdWoUXasvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlmJJgDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlmJJgDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CEFC4CEC3;
	Sun,  1 Sep 2024 16:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209208;
	bh=8OvfHofNySDWd/ztkLweigl2dZt5zDmrIHfUdJYHzs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlmJJgDdamCIfl8tHydbGzVLprZV7ALypP/aW8RA2gW+iiLRPl3oglA6YUZ2tKshX
	 HjIdQCR1mGEqnertWegDQ3yKDVCeHXILG5piW0+t1f5yTTtWwREfbjqXlAoEkfterH
	 L3jy6r3hvUHYw4CvWWg4yeFV2H6Di1Dz3wD+dbf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+853d80cba98ce1157ae6@syzkaller.appspotmail.com,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Subject: [PATCH 6.1 35/71] btrfs: fix extent map use-after-free when adding pages to compressed bio
Date: Sun,  1 Sep 2024 18:17:40 +0200
Message-ID: <20240901160803.216809339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -613,6 +613,7 @@ static noinline int add_ra_bio_pages(str
 			put_page(page);
 			break;
 		}
+		add_size = min(em->start + em->len, page_end + 1) - cur;
 		free_extent_map(em);
 
 		if (page->index == end_index) {
@@ -625,7 +626,6 @@ static noinline int add_ra_bio_pages(str
 			}
 		}
 
-		add_size = min(em->start + em->len, page_end + 1) - cur;
 		ret = bio_add_page(cb->orig_bio, page, add_size, offset_in_page(cur));
 		if (ret != add_size) {
 			unlock_extent(tree, cur, page_end, NULL);


