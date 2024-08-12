Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E790183CA6;
	Mon, 12 Aug 2024 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479156; cv=none; b=dVubYnQsrde/7o9o4Gdv6yJyqwqAjw32kSpP32Fw6wJItUWXon3bPosqoBamBpysvKUR/X+T3zfJ7mKQvnA6CttdLLskTeoux4ZXitgFr0PCswLEU37CRD4kDx5bD3RTA8ru3PDvF2Y60hezyVHtStJX45fCCVrnCIOwR5rCHgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479156; c=relaxed/simple;
	bh=GFmDbnhAZ8UJL3nSVhU/gdZQ8K3p+iLSDC6MGzihgnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVT5CpVpQimunzlMC1X5S1ZAZRMCPslH9ttmnKfTljtw9DNbdivCZ3tMvdfFnzdiTybOtRwiW0V9Yevb1kgA3eaSZ7i+oCOoxZ5Q9GyP+FtCn48B3WXNlxrntsdlVcMjZ3eqaksZieWLh/Ff2rcXqOHP+UX5cIu+8ygC6SAQ3Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6JO51FN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6JO51FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2133C32782;
	Mon, 12 Aug 2024 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479156;
	bh=GFmDbnhAZ8UJL3nSVhU/gdZQ8K3p+iLSDC6MGzihgnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6JO51FNpSqIU+RnpZHIL7QYyOlCArt9bmR4dwfFEzCcMWk75xqKqSSopgwmtkOkP
	 wzNmXjz9g/WtKVozkkliKJ8oD4HkwIyFaun2NolgKoL7SFwMfBCGzHpxJ4stcgqW2j
	 scT9jomyYc9v+KjoCMrP0NIWKAhw7EDA2Ur8VZsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7dbbb74af6291b5a5a8b@syzkaller.appspotmail.com,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 150/150] btrfs: fix double inode unlock for direct IO sync writes
Date: Mon, 12 Aug 2024 18:03:51 +0200
Message-ID: <20240812160130.956350577@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit e0391e92f9ab4fb3dbdeb139c967dcfa7ac4b115 upstream.

If we do a direct IO sync write, at btrfs_sync_file(), and we need to skip
inode logging or we get an error starting a transaction or an error when
flushing delalloc, we end up unlocking the inode when we shouldn't under
the 'out_release_extents' label, and then unlock it again at
btrfs_direct_write().

Fix that by checking if we have to skip inode unlocking under that label.

Reported-by: syzbot+7dbbb74af6291b5a5a8b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/000000000000dfd631061eaeb4bc@google.com/
Fixes: 939b656bc8ab ("btrfs: fix corruption after buffer fault in during direct IO append write")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2037,7 +2037,10 @@ out:
 
 out_release_extents:
 	btrfs_release_log_ctx_extents(&ctx);
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_MMAP);
+	if (skip_ilock)
+		up_write(&BTRFS_I(inode)->i_mmap_lock);
+	else
+		btrfs_inode_unlock(inode, BTRFS_ILOCK_MMAP);
 	goto out;
 }
 


