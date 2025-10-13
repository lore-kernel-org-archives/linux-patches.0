Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33E330C342;
	Mon, 13 Oct 2025 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369637; cv=none; b=nFPf76pXqdmncis4wQrCkNFi5OVXOKUK82AgKUZWLBZS0HRGTriJzoA5VAT8VuF0w5UWCFQ9K+jMrix4D0nLb3WaM2bsBkLCjDHj9sEtKRVoiRp6yddfMOZJRhjbbapgMRBmo2sBNCgIA4fORouRNKHogSmrxpDDbuoUztN8Bns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369637; c=relaxed/simple;
	bh=v1sqTLmaVKGNOsmte3ZKJB0J4f2wOERW9n6R7mvfXhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXC3YGqSw0brfRcdhjN6Omq4JZ5U/2+4PpiQ0/tqTNJ66pOYuJ7Td2U6clT6VZMw4iOIBj8d2ot2+Uv5Rz4wkWXqSX5RoH/R3oKkRtSlKdQAINFpuclgCCmDhoJ5DJIyTQ4Fqt0EPQ5b56sXuY9FC5mFEL6lB2M0nxMBCBS8dO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3/9cY5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3/9cY5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9CBC4CEE7;
	Mon, 13 Oct 2025 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369636;
	bh=v1sqTLmaVKGNOsmte3ZKJB0J4f2wOERW9n6R7mvfXhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3/9cY5sD1bcR+WM/dQc6+0RKVgi+o0UT7qySxAMJCAjwua7CpLVL/U++v0YoI6Ds
	 A+4fZTxKzayfXz9O5acqwYv4qqjk5/p0S/Wh69b9CUbhh/90oPk9EugcG17Ds6u77y
	 4iU2rlSwNwtNvolbKD0FOmvlIW4vOpLOKYG5Tk0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 317/563] fanotify: Validate the return value of mnt_ns_from_dentry() before dereferencing
Date: Mon, 13 Oct 2025 16:42:58 +0200
Message-ID: <20251013144422.749875341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anderson Nascimento <anderson@allelesecurity.com>

[ Upstream commit 62e59ffe8787b5550ccff70c30b6f6be6a3ac3dd ]

The function do_fanotify_mark() does not validate if
mnt_ns_from_dentry() returns NULL before dereferencing mntns->user_ns.
This causes a NULL pointer dereference in do_fanotify_mark() if the
path is not a mount namespace object.

Fix this by checking mnt_ns_from_dentry()'s return value before
dereferencing it.

Before the patch

$ gcc fanotify_nullptr.c -o fanotify_nullptr
$ mkdir A
$ ./fanotify_nullptr
Fanotify fd: 3
fanotify_mark: Operation not permitted
$ unshare -Urm
Fanotify fd: 3
Killed

int main(void){
    int ffd;
    ffd = fanotify_init(FAN_CLASS_NOTIF | FAN_REPORT_MNT, 0);
    if(ffd < 0){
        perror("fanotify_init");
        exit(EXIT_FAILURE);
    }

    printf("Fanotify fd: %d\n",ffd);

    if(fanotify_mark(ffd, FAN_MARK_ADD | FAN_MARK_MNTNS,
FAN_MNT_ATTACH, AT_FDCWD, "A") < 0){
        perror("fanotify_mark");
        exit(EXIT_FAILURE);
    }

return 0;
}

After the patch

$ gcc fanotify_nullptr.c -o fanotify_nullptr
$ mkdir A
$ ./fanotify_nullptr
Fanotify fd: 3
fanotify_mark: Operation not permitted
$ unshare -Urm
Fanotify fd: 3
fanotify_mark: Invalid argument

[   25.694973] BUG: kernel NULL pointer dereference, address: 0000000000000038
[   25.695006] #PF: supervisor read access in kernel mode
[   25.695012] #PF: error_code(0x0000) - not-present page
[   25.695017] PGD 109a30067 P4D 109a30067 PUD 142b46067 PMD 0
[   25.695025] Oops: Oops: 0000 [#1] SMP NOPTI
[   25.695032] CPU: 4 UID: 1000 PID: 1478 Comm: fanotify_nullpt Not
tainted 6.17.0-rc4 #1 PREEMPT(lazy)
[   25.695040] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
[   25.695049] RIP: 0010:do_fanotify_mark+0x817/0x950
[   25.695066] Code: 04 00 00 e9 45 fd ff ff 48 8b 7c 24 48 4c 89 54
24 18 4c 89 5c 24 10 4c 89 0c 24 e8 b3 11 fc ff 4c 8b 54 24 18 4c 8b
5c 24 10 <48> 8b 78 38 4c 8b 0c 24 49 89 c4 e9 13 fd ff ff 8b 4c 24 28
85 c9
[   25.695081] RSP: 0018:ffffd31c469e3c08 EFLAGS: 00010203
[   25.695104] RAX: 0000000000000000 RBX: 0000000001000000 RCX: ffff8eb48aebd220
[   25.695110] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8eb4835e8180
[   25.695115] RBP: 0000000000000111 R08: 0000000000000000 R09: 0000000000000000
[   25.695142] R10: ffff8eb48a7d56c0 R11: ffff8eb482bede00 R12: 00000000004012a7
[   25.695148] R13: 0000000000000110 R14: 0000000000000001 R15: ffff8eb48a7d56c0
[   25.695154] FS:  00007f8733bda740(0000) GS:ffff8eb61ce5f000(0000)
knlGS:0000000000000000
[   25.695162] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.695170] CR2: 0000000000000038 CR3: 0000000136994006 CR4: 00000000003706f0
[   25.695201] Call Trace:
[   25.695209]  <TASK>
[   25.695215]  __x64_sys_fanotify_mark+0x1f/0x30
[   25.695222]  do_syscall_64+0x82/0x2c0
...

Fixes: 58f5fbeb367f ("fanotify: support watching filesystems and mounts inside userns")
Link: https://patch.msgid.link/CAPhRvkw4ONypNsJrCnxbKnJbYmLHTDEKFC4C_num_5sVBVa8jg@mail.gmail.com
Signed-off-by: Anderson Nascimento <anderson@allelesecurity.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b192ee068a7ac..561339b4cf752 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1999,7 +1999,10 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		user_ns = path.mnt->mnt_sb->s_user_ns;
 		obj = path.mnt->mnt_sb;
 	} else if (obj_type == FSNOTIFY_OBJ_TYPE_MNTNS) {
+		ret = -EINVAL;
 		mntns = mnt_ns_from_dentry(path.dentry);
+		if (!mntns)
+			goto path_put_and_out;
 		user_ns = mntns->user_ns;
 		obj = mntns;
 	}
-- 
2.51.0



