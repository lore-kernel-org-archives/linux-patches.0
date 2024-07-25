Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22213DDB8;
	Thu, 25 Jul 2024 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918699; cv=none; b=kyISU0BftxY9wWINkrLV69nO3apXPavCDtArlF9EpjqWLpmsgNfnFxgM/+Y/5eoi44hTH9nWhJ39ACKZZq+fdk6NK9gPEkLF7oQJ5w4fnRqM4cfKZnRaR46l6b+d1GYh4jChoRzSB1fOGBbpYlWwsN3uN64O+GQllIvWj91FUhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918699; c=relaxed/simple;
	bh=kWPxw1BG01MP3mBm+gtGc+hnX/P6pntzLbsiPFTnn/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fD8I0NHhiKqTQOD1It7vyW/st33yFc7NPNfHKkLYznZokvQsONdk7DYIP+Lzds54X2zzzm03jBaeT/LS7fm9qmuCNiyFU4AelmcBpDEzuBtBOkNYa8fjgHSmSVsARbczYk2PSiSOrcfViO0U5OsYliFSR4uZjPwIbFUF9jvSI40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtEaU74G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtEaU74G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E35C116B1;
	Thu, 25 Jul 2024 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918699;
	bh=kWPxw1BG01MP3mBm+gtGc+hnX/P6pntzLbsiPFTnn/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtEaU74Gt7ziwnCjnkfjNcoJPPTlFLN0ZYHswHAk1ylf5UUnzhOnjuZoPv5auqnbO
	 I6nXSnfKBooDrHnDo9n0LcBAVB3IRb5kEHc2sTPurMqofZqTqI/E12Q80/2dc6yF4p
	 qmB4i4UmOk6iwcL86GV83vAm7gAUZGUGvmRcdRak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	=?UTF-8?q?Sergio=20Gonz=C3=A1lez=20Collado?= <sergio.collado@gmail.com>,
	syzbot+c56033c8c15c08286062@syzkaller.appspotmail.com
Subject: [PATCH 6.1 13/13] btrfs: do not BUG_ON on failure to get dir index for new snapshot
Date: Thu, 25 Jul 2024 16:37:22 +0200
Message-ID: <20240725142728.540571187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit df9f278239046719c91aeb59ec0afb1a99ee8b2b upstream.

During the transaction commit path, at create_pending_snapshot(), there
is no need to BUG_ON() in case we fail to get a dir index for the snapshot
in the parent directory. This should fail very rarely because the parent
inode should be loaded in memory already, with the respective delayed
inode created and the parent inode's index_cnt field already initialized.

However if it fails, it may be -ENOMEM like the comment at
create_pending_snapshot() says or any error returned by
btrfs_search_slot() through btrfs_set_inode_index_count(), which can be
pretty much anything such as -EIO or -EUCLEAN for example. So the comment
is not correct when it says it can only be -ENOMEM.

However doing a BUG_ON() here is overkill, since we can instead abort
the transaction and return the error. Note that any error returned by
create_pending_snapshot() will eventually result in a transaction
abort at cleanup_transaction(), called from btrfs_commit_transaction(),
but we can explicitly abort the transaction at this point instead so that
we get a stack trace to tell us that the call to btrfs_set_inode_index()
failed.

So just abort the transaction and return in case btrfs_set_inode_index()
returned an error at create_pending_snapshot().

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sergio González Collado <sergio.collado@gmail.com>
Reported-by: syzbot+c56033c8c15c08286062@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1701,7 +1701,10 @@ static noinline int create_pending_snaps
 	 * insert the directory item
 	 */
 	ret = btrfs_set_inode_index(BTRFS_I(parent_inode), &index);
-	BUG_ON(ret); /* -ENOMEM */
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
 
 	/* check if there is a file/dir which has the same name. */
 	dir_item = btrfs_lookup_dir_item(NULL, parent_root, path,


