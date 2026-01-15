Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301042D7D47;
	Thu, 15 Jan 2026 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496541; cv=none; b=rbt2Hn2phyM0kOsv5AKaGgo8MC/AuKyJ3WyQHSodX6HNN1dvYffs24UUL7xj6k8Vu7oaN5lIcY9Fg2jcgye4e12y9vy0KOfCDU1e7LpgoL6jktJEQkhIXB/5xye9NCTkjl1FxJOER24XWfG1Lc8QHaJXcUAdn2xjLpQofYKtqY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496541; c=relaxed/simple;
	bh=ImaQ6xAfpwrBHM1khCRW1B2gAkaM+IwgyEn0L9SnWT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYUBaktM+pwmkRN9Q9HgBapUarpJI0f+Wz9rg1eVHbGVSccO9SG3TcX1f84cKVcFPQZ2Dh3At0o5cy3HitUPt2DUAWJQwi1/DGXLKJo7qXOFMHeGfpi1czUIrn1DmpGIZIjDHPy6cwqIi2Mn6NV/GQYkvMVBYDo4WuCpy60d12Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+ZHrBuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+ZHrBuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A31C116D0;
	Thu, 15 Jan 2026 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496541;
	bh=ImaQ6xAfpwrBHM1khCRW1B2gAkaM+IwgyEn0L9SnWT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+ZHrBuym2jGPUo1X9QTMsXnEoGhpRZ2XYg4f3qb8Sl1zvFoSIo/DCKPLxmiF/A2B
	 lVzOXPPXWTyfiroC7uIsJzca23ThJgydoAYI9n3zjWW8j3nIdE5PM1EvbABibqe1Db
	 c0U6yXpsVWOZjLQSm/3NXMnJNIJ6m1tJ4ga7sKPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d991fea1b4b23b1f6bf8@syzkaller.appspotmail.com,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/119] btrfs: fix NULL dereference on root when tracing inode eviction
Date: Thu, 15 Jan 2026 17:47:43 +0100
Message-ID: <20260115164153.693910039@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cc88074914283..0ca86909ce5bd 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -223,7 +223,8 @@ DECLARE_EVENT_CLASS(btrfs__inode,
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



