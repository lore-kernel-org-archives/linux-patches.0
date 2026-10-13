Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7D44EF149;
	Tue, 13 Oct 2026 12:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892852; cv=none; b=h5zAh6n+CjdwkhIf/0kKDtNSHjCnGL4ffMxpiajodM4JPAgRh3pxGUXqAYhxwADygDf5iYs5nG4vCdSTpZR1tGlrpRg/PjIahk5ffBq/zkKI2JH7MguhReunymql9dbDQfRtfzU2gRzNeH/p/jya+Rk2EZcpUILAOd5iRMg5mV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892852; c=relaxed/simple;
	bh=lKZgG4RXhvHY7PfG7oK7dmmaEEgRp/Q9xZ2L/U44z+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7sf08TMkdYk4KZ0rEILGN28YyxHZpOT9f8mA4ZlMuxmT9Bn0BWFWjHue3e9fZzOkdzX9LByVaYqYWlT6vn8Ppue6m8d6rlyG429yRKpYqPa4bVjLSk9E/UfETszSA7wQ8h8u7yOfSoEoYYZQdSNpoHA64kPMINt49SuSe5cv5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdPs0ncf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdPs0ncf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F47E1F000FF;
	Tue, 13 Oct 2026 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892851;
	bh=UDSuUQS6rLzDQxvhEu3cN3EemlQwjrQX8JpQiZl+gVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdPs0ncf9tnFSNiCQ6z1/j1kekXuj5pOiNaQOylCPzKwiRI1RTdFCMaql2gyBbpaM
	 8j6zUuv4BWrOUQMYhwO8Fzd2w/bi/zUYPItIdXl7mwZeUnzQNo+Ja7Vf+CGBhs7ar9
	 GYri1xLMKPjawwrB1FiPOpXNvsU0lfHdX+HDerRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 030/621] btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()
Date: Tue, 13 Oct 2026 13:30:25 +0200
Message-ID: <20261013112921.581065209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -551,8 +551,10 @@ static int scrub_print_warning_inode(u64
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to


