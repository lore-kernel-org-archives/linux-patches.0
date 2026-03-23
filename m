Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC81A242D70;
	Mon, 23 Mar 2026 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278746; cv=none; b=ISBdcZQJ9YT0A1+hcEVkHCfsx+eKjUwve3HCfVXIjC0yNzgMO+b3npZMkHPvIWK/VWKLK0a9Ve/P1Kur1PmOOaW1+N7dJ2g3aXtOhRpabUekS6KoA6MhVVGmbdgHVDFXfrvllj5t5GJVMMEw6U78Di+8PqyJGTCZr01h3xHmL6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278746; c=relaxed/simple;
	bh=lz+IhvxSRairiKgW5rYs1e7SfPxEcWpekR5S90ynUkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXX0SyX2CmNpoPTS02gqgX1FBQmd+ZCy8DjrvsCURhLIqRghP6irny5VCQjTmLQTploELIaS7GVM5SuH37WA6uZ2NOStFXNUtVPeb3KyH2Qpj1OEKcczDKjAsFpoOwI8p/uf8jDN5YjsPh0n3stB1FGADkxnfBe1bS8/31h59EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pH2FFaG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pH2FFaG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484DBC4CEF7;
	Mon, 23 Mar 2026 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278746;
	bh=lz+IhvxSRairiKgW5rYs1e7SfPxEcWpekR5S90ynUkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pH2FFaG/S5rj6GnzzYJ8rww5JdMrn0tIsyccyRBJgQ9OTJLU/wZREEBHy6dBjdjXy
	 VCulVbgABDxwFgrGxTnnjU0C0Q9FPobDhZ6ovZDHxHaXXXw38dL4feWTrj6vvoMicY
	 HI1EyHdoD+OM/FLUPceQxpEsAHKkek4e1tqWeSjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d991fea1b4b23b1f6bf8@syzkaller.appspotmail.com,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.6 405/567] btrfs: fix NULL dereference on root when tracing inode eviction
Date: Mon, 23 Mar 2026 14:45:25 +0100
Message-ID: <20260323134543.895486237@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Adjust context ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/btrfs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -225,8 +225,8 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 		__entry->generation = BTRFS_I(inode)->generation;
 		__entry->last_trans = BTRFS_I(inode)->last_trans;
 		__entry->logged_trans = BTRFS_I(inode)->logged_trans;
-		__entry->root_objectid =
-				BTRFS_I(inode)->root->root_key.objectid;
+		__entry->root_objectid = BTRFS_I(inode)->root ?
+					 btrfs_root_id(BTRFS_I(inode)->root) : 0;
 	),
 
 	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%llu blocks=%llu "


