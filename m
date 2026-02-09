Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B814437C112;
	Mon,  9 Feb 2026 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647951; cv=none; b=XYeNRIw33r53C+3SPW1e868TSZpPV/PKrzwJQADdmc4yLumB1KTA8MJ+zPhP7qUPciZak3mZbREqPSwdAGgFp4l/w5QrevUtaweqWdq15au2i91KTZHUr2xThRdU476hpKlOVT7Ur+faSUUIz1jaY54HKAUtOxHJ3kXswdE2Oww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647951; c=relaxed/simple;
	bh=i4bpGoAGdhtm3vSb5Qa3rBW2AC14ICBW5LQtiNKrobw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDUj4jCDIPSHCboH6mxtgcmDfsQJchg3L5MJwkGcGItv74ZjrhirY88/0Zeyck/HwWA+q2ZWMyiIVoDu+w+PVrdaRZChKBs4113UK58BDaYuD06XO2oWXLeX7MLAy1t3wpnI085jrFsMp3Mskxl0lGQJdbscvIBoWrzpv6ug91Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODthn2/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODthn2/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5136C116C6;
	Mon,  9 Feb 2026 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647951;
	bh=i4bpGoAGdhtm3vSb5Qa3rBW2AC14ICBW5LQtiNKrobw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODthn2/wwj0dcaMPfXteZrOP9Muur+hanzkBVR8i4+Pv8hzbVMg610LPTt09dkr2K
	 H+ft71xus2Ovqt/EQ0b9HwhBfmrdwY2miJUeYoCZlA3n0TMc9W5iQ5BBVC8t3TgnBw
	 PoZaRV0wkTwfaAWJSYrEgKqkSWIjvTcWaMsz+E/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/113] smb/client: fix memory leak in smb2_open_file()
Date: Mon,  9 Feb 2026 15:23:46 +0100
Message-ID: <20260209142312.952292752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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
index b313c128ffbab..414242a33d61a 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -122,6 +122,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
+		free_rsp_buf(err_buftype, err_iov.iov_base);
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 			       &err_buftype);
-- 
2.51.0



