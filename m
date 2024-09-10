Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A93C143880;
	Tue, 10 Sep 2024 10:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963500; cv=none; b=SQ89Xmwg/2APRg/W8YynhPOZvay6oV80va+mEsg+pi9g5t7RhjYNjsJzHmwundxGiYv2p76hruikHobPkSztvixviH2Yr+1duhRCpM41hMzSB/YxsAKBZZsi0upLbE4cPHHOHrr+U23okSrY/9zv6lWGeU4tSYLN6zECGndwYeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963500; c=relaxed/simple;
	bh=Os0B4r8ygdMx7TqYVpb1MQTwOxD4pxjY1U96opkPRcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y234RK2BKnxLcdUpFYkBpBeYrGj/LLngV4fW/J7ICzdXssh0t6rXxA0Y+PJqakGi+JwhdOxvmxI52xyqomLFWIvJasu6l+ysSKUs8fYtT52Aq0k/OiU5Mc4pruZYyn9+qd6pZhmBGFapMZk6HDZEHd6RCaZxln1zfqDtYRkrChI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ii2P65BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ii2P65BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4199C4CEC3;
	Tue, 10 Sep 2024 10:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963500;
	bh=Os0B4r8ygdMx7TqYVpb1MQTwOxD4pxjY1U96opkPRcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ii2P65BY5MswxSu+FJG/EVgM8GP/ScRY1CvvS5Wkk4dnv6jXYjmDMiljq85oyiYly
	 JfKh4Evdoz1oBTnBph1aKRtG3XhnLZThFuFmYDkiTttBz0wrTe516AVv9YCgyOyGs5
	 HbaHxcJJIlOSErFLhpsW34w4QiEdOR0/0frLA3Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 078/214] fuse: update stats for pages in dropped aux writeback list
Date: Tue, 10 Sep 2024 11:31:40 +0200
Message-ID: <20240910092601.928602047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit f7790d67785302b3116bbbfda62a5a44524601a3 upstream.

In the case where the aux writeback list is dropped (e.g. the pages
have been truncated or the connection is broken), the stats for
its pages and backing device info need to be updated as well.

Fixes: e2653bd53a98 ("fuse: fix leaked aux requests")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org> # v5.1
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1694,10 +1694,16 @@ __acquires(fi->lock)
 	fuse_writepage_finish(fm, wpa);
 	spin_unlock(&fi->lock);
 
-	/* After fuse_writepage_finish() aux request list is private */
+	/* After rb_erase() aux request list is private */
 	for (aux = wpa->next; aux; aux = next) {
+		struct backing_dev_info *bdi = inode_to_bdi(aux->inode);
+
 		next = aux->next;
 		aux->next = NULL;
+
+		dec_wb_stat(&bdi->wb, WB_WRITEBACK);
+		dec_node_page_state(aux->ia.ap.pages[0], NR_WRITEBACK_TEMP);
+		wb_writeout_inc(&bdi->wb);
 		fuse_writepage_free(aux);
 	}
 


