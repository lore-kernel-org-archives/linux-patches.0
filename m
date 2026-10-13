Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEEC3B19C2;
	Tue, 13 Oct 2026 12:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895706; cv=none; b=gT4F6JvE9QCe4hmqPSyRXl1dIOvBNMvfwUwN5iQyweXWjRSes9VyXb6rsjNzZlr/Vinhg2k/2VeEHILTrJYdc/l5jVaYv0/V/jUNwTonteMDm0h8EDsCQtQnmTcrshksN7zdLyZ9YqNrAnOTjJyemPFvo6uJ6xnVW7N3LX5EDSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895706; c=relaxed/simple;
	bh=X8Tj+KxvctdGi3hDGaV/U1mwrPpfX6mWkK74/rHxQBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUC3nLUaCRvaOfb+RmKQM6qqsavacdl5oFgLln5PB8xDPjlQHmzYigMzUTtEF0rMHAacNR+QWVUdxIwXzPnkGer4eU6/lHcBZnXpTOVmiVNoTqDykH3oMIAQ9UPm1Evvms2HmtYBvdwCWShcabxLm0tOxZThwTh4xrHY1Yn6YZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQ6nKCn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQ6nKCn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC2C1F000FF;
	Tue, 13 Oct 2026 12:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895705;
	bh=kxYPK+1yMkhFQBQR+k4zAvu+/njDZHqmrEyuoWMQ+oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQ6nKCn5JX9nAaudgvFNPYZP2cYk3cY974gnneEIU5sCVv2OUIPJdsL2/jmgXBD/M
	 So1Ck0lCsKCAddIktpUV9Afs/QJTrQS5pboZ80fZBp2x9HpKA9h6fg1ZDTlxTA9q/6
	 x/miXATfELOySzzkwNxMnTyOf+b3k6ueOuteEdG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 363/497] btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()
Date: Tue, 13 Oct 2026 13:38:50 +0200
Message-ID: <20261013112916.519941818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1fd742c7479961da6d0bb794ef8ac6b7b9442847 upstream.

When paths_from_inode() fails, scrub_print_warning_inode() jumps to err
without dropping the reference taken by btrfs_get_fs_root(), leaking a
reference to the root every time path resolution fails while printing
scrub warnings.  Every other error and success path of the function
drops the reference.

Drop the reference on the paths_from_inode() failure path too.

Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -445,8 +445,10 @@ static int scrub_print_warning_inode(u64
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to


