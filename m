Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1851C30EF6B;
	Mon, 13 Apr 2026 16:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098645; cv=none; b=E3mRAbkr7WIGDR0Q2mpBx6kwl7aKM6Q6n9GIpOjyEPz8XzdqbvuhQEI3akyaz8PqTbMrs8pWFUrXVq3ICIRoBuAJilB4GQ1cHSXWpmTP3c187iqLJYjWQGn0mSvGakoK6ltBqk9WN5jMbWsJ1vzlWblmhTOS+n905vpo8c7/iMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098645; c=relaxed/simple;
	bh=f6uEraDNzdZMnxA25w8R2HjOrtY/n2O5iBINyg+wwPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WckTqwRmT34loxBB+hNpJjsAqXexsny8m244eiE8CFx09BuGIigF9u4putYIo4KqBGeLva4oz6MRbkQmUXKiDPKkxPnWgEhBi97BaOGbuxwJBze8L7zNMI0Vr+JDazjzzQb7lW/BURa6nYaYyIR5ipSaMxyozoB7GxculuIue7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzeZIEYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzeZIEYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4339C4AF09;
	Mon, 13 Apr 2026 16:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098645;
	bh=f6uEraDNzdZMnxA25w8R2HjOrtY/n2O5iBINyg+wwPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzeZIEYrdhw5fVhHVYIgYaAZFwlRgHhn0fAsSgkCnKJ96cqhcXu4ez59xzcgOKQgq
	 7ab2l7I/HsKviiB+htpCPepxkbppPtArUeUdK7LRorTHCradMGF2fcgDBCbyztXw2r
	 tL9RRgYoUpw2rHLCVDwQ09drWa/xfICcgVHtbNCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 032/491] Squashfs: check metadata block offset is within range
Date: Mon, 13 Apr 2026 17:54:37 +0200
Message-ID: <20260413155820.254666263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

commit fdb24a820a5832ec4532273282cbd4f22c291a0d upstream.

Syzkaller reports a "general protection fault in squashfs_copy_data"

This is ultimately caused by a corrupted index look-up table, which
produces a negative metadata block offset.

This is subsequently passed to squashfs_copy_data (via
squashfs_read_metadata) where the negative offset causes an out of bounds
access.

The fix is to check that the offset is within range in
squashfs_read_metadata.  This will trap this and other cases.

Link: https://lkml.kernel.org/r/20260217050955.138351-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Reported-by: syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/699234e2.a70a0220.2c38d7.00e2.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/cache.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -340,6 +340,9 @@ int squashfs_read_metadata(struct super_
 	if (unlikely(length < 0))
 		return -EIO;
 
+	if (unlikely(*offset < 0 || *offset >= SQUASHFS_METADATA_SIZE))
+		return -EIO;
+
 	while (length) {
 		entry = squashfs_cache_get(sb, msblk->block_cache, *block, 0);
 		if (entry->error) {


