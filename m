Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5E3FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F00C433D2;
	Mon, 15 May 2023 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170516;
	bh=Q0Q/HeCr8mcdtW5tfcSV5cPQZvWce90CbPisAugHgpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jb+bLUMYZadzzzm5QsVE2fUdPcC044UnlFw02HaKRdARVpHIfXh54NZHyV2WJKrA6
	 xY3Jb82x/aHEKG5qgRQzRK+X2YXpLgezaFo/IVFT1Xwe0QIxwayvYC6rTrVBRo0+f1
	 dfrFmfg7Pz+Fb2bOcbuGpXXIrvPUauLWvlRvbR4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 156/239] f2fs: fix null pointer panic in tracepoint in __replace_atomic_write_block
Date: Mon, 15 May 2023 18:26:59 +0200
Message-Id: <20230515161726.360003422@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit da6ea0b050fa720302b56fbb59307e7c7531a342 upstream.

We got a kernel panic if old_addr is NULL.

https://bugzilla.kernel.org/show_bug.cgi?id=217266

BUG: kernel NULL pointer dereference, address: 0000000000000000
 Call Trace:
  <TASK>
  f2fs_commit_atomic_write+0x619/0x990 [f2fs a1b985b80f5babd6f3ea778384908880812bfa43]
  __f2fs_ioctl+0xd8e/0x4080 [f2fs a1b985b80f5babd6f3ea778384908880812bfa43]
  ? vfs_write+0x2ae/0x3f0
  ? vfs_write+0x2ae/0x3f0
  __x64_sys_ioctl+0x91/0xd0
  do_syscall_64+0x5c/0x90
  entry_SYSCALL_64_after_hwframe+0x72/0xdc
 RIP: 0033:0x7f69095fe53f

Fixes: 2f3a9ae990a7 ("f2fs: introduce trace_f2fs_replace_atomic_write_block")
Cc: <stable@vger.kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -262,7 +262,7 @@ retry:
 	f2fs_put_dnode(&dn);
 
 	trace_f2fs_replace_atomic_write_block(inode, F2FS_I(inode)->cow_inode,
-					index, *old_addr, new_addr, recover);
+			index, old_addr ? *old_addr : 0, new_addr, recover);
 	return 0;
 }
 


