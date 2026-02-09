Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D5937BE93;
	Mon,  9 Feb 2026 14:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647501; cv=none; b=BFiyxcfq7gmdv4NBmEFos8677yvvoEVxmpzetfx2GFokenp81MMBeUMV5KmmSWwqb17XteVxvA5b3RcwpDUs3u1VMLBo+YGzG7Y5iZrheHgZZLyHcpKhKcLUsg3vU5nwhcP/jUNhZuRMV4IRgCG++JeMGg7oCY8tTsdG7/BLiR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647501; c=relaxed/simple;
	bh=dlZHsWCkkQzsxRDJ8D7KK81RKwncEmy1abcSH52AFmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AxmIYGRkDb2abX61/wgrdgEDlSVKYayghkIGhiA/SfXkPINBTtW+K9fOhVUk9PCluEaCHSvdQmEZf8s5u2MedX2DW/jtdtKcoLzZD4o54lxyLOM7qW6TRsTpxoXhR3DQvAZPce4S+7uVGsmy7N0o4NqzhNTE90b93QPz1WVb/8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1U850HO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1U850HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12D2C16AAE;
	Mon,  9 Feb 2026 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647501;
	bh=dlZHsWCkkQzsxRDJ8D7KK81RKwncEmy1abcSH52AFmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1U850HOyXzHZ2vboDlzawpODnRRJxUXPAFsXSe8cVV1Rpwsw6JY008wpMH1OTCxL
	 z/Ve3YolmksgW0zsMWoTcfQq+WgmTTwEmNyy9pT+TY59PgsSuegYGZ5Sse8WMZSi11
	 yLblwR0V8PkMFZ/U8F03fIBgZG8j6JIpXCuD3DCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/175] smb/client: fix memory leak in smb2_open_file()
Date: Mon,  9 Feb 2026 15:23:10 +0100
Message-ID: <20260209142324.620761199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit e3a43633023e3cacaca60d4b8972d084a2b06236 ]

Reproducer:

  1. server: directories are exported read-only
  2. client: mount -t cifs //${server_ip}/export /mnt
  3. client: dd if=/dev/zero of=/mnt/file bs=512 count=1000 oflag=direct
  4. client: umount /mnt
  5. client: sleep 1
  6. client: modprobe -r cifs

The error message is as follows:

  =============================================================================
  BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shutdown()
  -----------------------------------------------------------------------------

  Object 0x00000000d47521be @offset=14336
  ...
  WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x34e/0x440, CPU#0: modprobe/1577
  ...
  Call Trace:
   <TASK>
   kmem_cache_destroy+0x94/0x190
   cifs_destroy_request_bufs+0x3e/0x50 [cifs]
   cleanup_module+0x4e/0x540 [cifs]
   __se_sys_delete_module+0x278/0x400
   __x64_sys_delete_module+0x5f/0x70
   x64_sys_call+0x2299/0x2ff0
   do_syscall_64+0x89/0x350
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  ...
  kmem_cache_destroy cifs_small_rq: Slab cache still has objects when called from cifs_destroy_request_bufs+0x3e/0x50 [cifs]
  WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x16b/0x190, CPU#0: modprobe/1577

Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
Fixes: e255612b5ed9 ("cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES")
Reported-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index a7f6292388306..03f90553d8319 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -177,6 +177,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
+		free_rsp_buf(err_buftype, err_iov.iov_base);
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 			       &err_buftype);
-- 
2.51.0



