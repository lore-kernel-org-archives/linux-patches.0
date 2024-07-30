Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290C41A6195;
	Tue, 30 Jul 2024 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358534; cv=none; b=mYSV6nL/T11a1t65KQVIcyzMGRS3mPHX8luVq4Lh0qFOXVz6Xu9k/zWeQJmUx8UBYWleWG5MHaEuVHmPXUT6fGkPoPAv6d4C8hGmMjNlNsAWDcU8nukm4rgswSkEnlY/vAygYJsn84ZFAl3s/uhtJrQ0zztEhnYZbTpEeQwr/jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358534; c=relaxed/simple;
	bh=Aar2KzFkWpJVIGrUPZEp8VRW5trd3Bz4o5O9sbW0LHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDWTkselIzIqn+ZaAnLoqPSURBEOxDMZE8NZTlOjTTGQmJO0Wxjt2VxIkH/s0hm92CngK9vgwEdT9TdFohOFHXpM/101eNbAq3eHpzLHQ7072WlwLmx8aYyD4I1+1Eo7hHh6q4MKiZbLfdnGT8wFtb92S20+tH6wLimN2x6uKUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDRxOmdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDRxOmdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B701AC32782;
	Tue, 30 Jul 2024 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358533;
	bh=Aar2KzFkWpJVIGrUPZEp8VRW5trd3Bz4o5O9sbW0LHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDRxOmdXP0NGmwNa6KWwL7/r/BSNAqP258HZVYsjl96PkPS+axp7O0erPH+FFi5g2
	 G/ELuUvT8ELiTfmO2F5SXNbBnmWh/DSHaWWF9w/npsldSUL06o4iW0HGZT+rqqy3RL
	 TXXCZcfOQ98Nw7PsQMDkLfRFNNZ72LYFoq5cIVa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+853d80cba98ce1157ae6@syzkaller.appspotmail.com,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 370/568] btrfs: fix extent map use-after-free when adding pages to compressed bio
Date: Tue, 30 Jul 2024 17:47:57 +0200
Message-ID: <20240730151654.324289413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -420,6 +420,7 @@ static noinline int add_ra_bio_pages(str
 			put_page(page);
 			break;
 		}
+		add_size = min(em->start + em->len, page_end + 1) - cur;
 		free_extent_map(em);
 
 		if (page->index == end_index) {
@@ -432,7 +433,6 @@ static noinline int add_ra_bio_pages(str
 			}
 		}
 
-		add_size = min(em->start + em->len, page_end + 1) - cur;
 		ret = bio_add_page(orig_bio, page, add_size, offset_in_page(cur));
 		if (ret != add_size) {
 			unlock_extent(tree, cur, page_end, NULL);


