Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC0018DF88;
	Tue, 10 Sep 2024 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961341; cv=none; b=cRWeiwR5dISFmNHoxr+egwRuXMkv5MwtSmergYVjPcYVWKxupIlqeQBVpGqGXFBDdZvEcgZ1hbbS+QwQh7KSS1+TIwHj+mT8L6avE6S2zr2O2etmHNrT67fSTWP+SIpVdCk6xWt5BsP5S41DrjsHrLij6pQCnrFrf6491js2dVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961341; c=relaxed/simple;
	bh=+wV5zyV+ZpHdjSJZy2Y3krXqWETvs0oXNP7OTGOY0Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzdzWXR8JPuqZtwozLbULaOmrXMNnHAJSOlxC+X3DiHxSshIg8z/2tXAHBFoN0xj4en/9Ki3U6SQYRhYJ1CJJ0HfsG/ql9AzTCGZOlES8Iaxyi9BYd0GXjAjoWZb38JNt+0ei5Bn7ndlyDp0u3nzB88Ih+BVbLLCXRkuMZHpCgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mC1RUdMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mC1RUdMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C69C4CEC3;
	Tue, 10 Sep 2024 09:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961341;
	bh=+wV5zyV+ZpHdjSJZy2Y3krXqWETvs0oXNP7OTGOY0Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mC1RUdMwVxGXbJOaXvERsCxtwkHYHpEP6d04j0fLiivAYn1cC7OUNsxneln8SfK43
	 KIXVElv0V7o4GqjHYjUEEWEWDVn/opvPitDlkqsLCF5iYjOeaffx6oePKPTdMRXq+r
	 W6ly2FJWAUXI6BMFDqxzQiqeG6CD013T2cW9CQ5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.10 037/375] fuse: update stats for pages in dropped aux writeback list
Date: Tue, 10 Sep 2024 11:27:14 +0200
Message-ID: <20240910092623.473935250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
@@ -1832,10 +1832,16 @@ __acquires(fi->lock)
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
 


