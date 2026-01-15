Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24583B52ED;
	Thu, 15 Jan 2026 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496072; cv=none; b=fC4VFcni5+KHb8FOqefZzNHHejikA0If4U8qpconChADmm+LcD2TgRJDYBgQibu4d5+AesmsOOmzUelG6ymmZmQd0qa8eCute6cowBYUlCHSiBTXqBDTobXeiDEorR/ym6pxQeLRsK5eH7G815c7FElMcOeJrYbF+AEWcwQ2PXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496072; c=relaxed/simple;
	bh=dTPKo6UwJc1AMGbGGCqfQ1tmY2azi1AAMvlxPNo8LEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PeKDjO9NLqhlKzU2aXB+zN9IegAFdJIL4iYRv70ZlIKOjpMY82yqEGBFee9CM2mXYjgk/wzYWIwQ0Y+NvOptDt6opF4TTGk/m6CvQuRJrTs4vNS6XI/qgvymhHKoEgG20Vb0O/7pXfWdv5VHUlGKEfxwo8AOhle0HpqZIKOsDBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Doxa/ps2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Doxa/ps2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E15AC116D0;
	Thu, 15 Jan 2026 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496071;
	bh=dTPKo6UwJc1AMGbGGCqfQ1tmY2azi1AAMvlxPNo8LEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Doxa/ps29A5hSzuSylXN0YF8K7aCapTnRhJ0FZBG9re7/Y3eVd4S4UTC8RGJvMbxb
	 7rgua/9n70BvP3LlCH0hC4R2hrFZ/9mFwMdHdUjcyzpRg07e8emsweopN4C+4KNf1A
	 mEd5ZVPZBBgC01vpE9fF6sl3qPxnQcCK0F4Zm2MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d991fea1b4b23b1f6bf8@syzkaller.appspotmail.com,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/181] btrfs: fix NULL dereference on root when tracing inode eviction
Date: Thu, 15 Jan 2026 17:46:43 +0100
Message-ID: <20260115164204.708278536@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mssola@mssola.com>

[ Upstream commit f157dd661339fc6f5f2b574fe2429c43bd309534 ]

When evicting an inode the first thing we do is to setup tracing for it,
which implies fetching the root's id. But in btrfs_evict_inode() the
root might be NULL, as implied in the next check that we do in
btrfs_evict_inode().

Hence, we either should set the ->root_objectid to 0 in case the root is
NULL, or we move tracing setup after checking that the root is not
NULL. Setting the rootid to 0 at least gives us the possibility to trace
this call even in the case when the root is NULL, so that's the solution
taken here.

Fixes: 1abe9b8a138c ("Btrfs: add initial tracepoint support for btrfs")
Reported-by: syzbot+d991fea1b4b23b1f6bf8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d991fea1b4b23b1f6bf8
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/btrfs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 7e418f065b945..125bdc166bfed 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -224,7 +224,8 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 		__entry->generation = BTRFS_I(inode)->generation;
 		__entry->last_trans = BTRFS_I(inode)->last_trans;
 		__entry->logged_trans = BTRFS_I(inode)->logged_trans;
-		__entry->root_objectid = btrfs_root_id(BTRFS_I(inode)->root);
+		__entry->root_objectid = BTRFS_I(inode)->root ?
+					 btrfs_root_id(BTRFS_I(inode)->root) : 0;
 	),
 
 	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%llu blocks=%llu "
-- 
2.51.0



