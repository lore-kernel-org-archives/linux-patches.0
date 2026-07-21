Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3750844AB60;
	Tue, 21 Jul 2026 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669184; cv=none; b=kEEDwhHgWG4IDiDdjYLB7ZlAYVBzuhhG/yYvnsKa4C/OqSFAQpLIocPArXR9D/cy26YcSUi3zz8tHQkTGAn47OzOSdqqkBFAZxXnitfTBE0iu5bDzlqyCI6Fujg6Mw3TgOHsDsu5h9HmF1w73C/GdrMQYGmTZzVZtplDp3n5E+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669184; c=relaxed/simple;
	bh=Om2fBaKqkVaCS2j/LI+J9124tmozmGSPQgVSXsRkikM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiHbL9FrwhsQ6cAKIVc1dEbMxRhPEeVcyFtBBvjJf6sj9lidUoWqfzBHrSaDBTIHhcy0utIaZG1Uxy7iNdhBbAy5VWDu2ibEiFivuJHDPDIITDfqTCbSx4Nd8nh8JK6orvE361T+TbHNNuwx2E3ugeG+ue4tTUQSdV0z9CWruHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwIgmjQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwIgmjQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1C91F000E9;
	Tue, 21 Jul 2026 21:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669182;
	bh=mK0NuPet3GLrQ2mIS9c/rgSdfP96N/slSPrZ0Z6KNM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwIgmjQ9JIIUlRWYBz4CDvcWcfAIHx4U9lgXcqXp1gUQjGOfAKUu8rKHfnvUMSrSh
	 9V6urHK3t/R4CsdPSuUVuks/ufMT6M3t7IgvwQHfnZOH0V03lYs9RNna1k95zkvGc7
	 TQ5ZisFMoj5Xs2MgjL7ku9Us2E/bSViUWKsH0jdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian496@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0457/1067] cifs: remove all cifs files before kill super
Date: Tue, 21 Jul 2026 17:17:38 +0200
Message-ID: <20260721152434.838837378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Zhang <zhangjian496@huawei.com>

[ Upstream commit 6d9a4aaaa8b2612b5ef9d581e2f286a458b71ee1 ]

Cifs files may be put into fileinfo_put_wq during umounting cifs.
After umount done, cifsFileInfo_put_final is called, which cause
following BUG:

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
[  134.222152]  list_lru_add+0x64/0x1a0
[  134.222399]  ? cifs_put_tcon+0x171/0x340 [cifs]
[  134.222772]  d_lru_add+0x44/0x60
[  134.222997]  dput+0x1fc/0x210
[  134.223213]  cifsFileInfo_put_final+0x11a/0x140 [cifs]
[  134.223576]  process_one_work+0x17c/0x320
[  134.223843]  worker_thread+0x188/0x280
[  134.224084]  ? __pfx_worker_thread+0x10/0x10
[  134.224366]  kthread+0xcc/0x100
[  134.224576]  ? __pfx_kthread+0x10/0x10
[  134.224827]  ret_from_fork+0x30/0x50
[  134.225063]  ? __pfx_kthread+0x10/0x10
[  134.225328]  ret_from_fork_asm+0x1b/0x30

This can be reproduce by following:
unshare -n bash -c "
mkdir -p ${CIFS_MNT}
ip netns attach root 1
ip link add eth0 type veth peer veth0 netns root
ip link set eth0 up
ip -n root link set veth0 up
ip addr add 192.168.0.2/24 dev eth0
ip -n root addr add 192.168.0.1/24 dev veth0
ip route add default via 192.168.0.1 dev eth0
ip netns exec root sysctl net.ipv4.ip_forward=1
ip netns exec root iptables -t nat -A POSTROUTING -s 192.168.0.2 -o
${DEV} -j MASQUERADE
mount -t cifs ${CIFS_PATH} ${CIFS_MNT} -o
vers=3.0,sec=ntlmssp,credentials=${CIFS_CRED},rsize=65536,wsize=65536,cache=none,echo_interval=1
touch ${CIFS_MNT}/a.txt
ip netns exec root iptables -t nat -D POSTROUTING -s 192.168.0.2 -o
${DEV} -j MASQUERADE
"
umount ${CIFS_MNT}

Fixes: 340cea84f691 ("cifs: open files should not hold ref on superblock")

Signed-off-by: Jian Zhang <zhangjian496@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a8f16cd8dca692..5b3e7fa242afa9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4187,6 +4187,9 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
+	flush_workqueue(serverclose_wq);
+	flush_workqueue(fileinfo_put_wq);
+
 	kfree(cifs_sb->prepath);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	dfs_cache_put_refsrv_sessions(&cifs_sb->dfs_mount_id);
-- 
2.53.0



