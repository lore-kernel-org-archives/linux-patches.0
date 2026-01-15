Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2680D3BFE39;
	Thu, 15 Jan 2026 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497899; cv=none; b=i6ZZIgiJpWY3D2f76Kh18klf64MXHyu+BsDx0T11XfPiwXV5BNUi3SvBpBiWOwU8fdEW9iB8buzRI92WmBn6af9SiW4Zza+EaO4T3mgu/BYvBwF44oWqszRaBZdYcijls9rmbpF99VN6WJqfqW7t+/sPFCn5V5NBMc6+u9CymwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497899; c=relaxed/simple;
	bh=M2Ntu76J/hB90ZWfS9wkzIb/ZtNQ09al7/EJ4ZYAuH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4XdAqWEv2MefJyksiAlNuVR/ysq9mgULv6gtzbxXfQrksuIJ/W9Oju1TVAdNrPMFYy4E/dn1R3Gsy6v7opR0XmjPNkBibCgX+SoScUhfwaRSPcUEkcBrfRyI5iI/LN/aBZHde0LiAX/aH0FUvB5Y6pLln8V7iBgSVrzWZTWj1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkF+ylUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkF+ylUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A41C16AAE;
	Thu, 15 Jan 2026 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497898;
	bh=M2Ntu76J/hB90ZWfS9wkzIb/ZtNQ09al7/EJ4ZYAuH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkF+ylUqHwXmsoDoMmXuHfCSVUgFOo00n7Vs1EZ7/zM4B2IukBFv86oIjGbLHohJT
	 hPfX5nohQHRaZQJaGPEc94P8NwNdsYCH2OGSntz2afJv4sv82Xes+AQhfUsiamL6GG
	 0Sr2UZpfcUgWK51bsRKLQyQ9c6tdGaWfyxtEC1Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/554] btrfs: fix memory leak of fs_devices in degraded seed device path
Date: Thu, 15 Jan 2026 17:44:35 +0100
Message-ID: <20260115164253.817819535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit b57f2ddd28737db6ff0e9da8467f0ab9d707e997 ]

In open_seed_devices(), when find_fsid() fails and we're in DEGRADED
mode, a new fs_devices is allocated via alloc_fs_devices() but is never
added to the seed_list before returning. This contrasts with the normal
path where fs_devices is properly added via list_add().

If any error occurs later in read_one_dev() or btrfs_read_chunk_tree(),
the cleanup code iterates seed_list to free seed devices, but this
orphaned fs_devices is never found and never freed, causing a memory
leak. Any devices allocated via add_missing_dev() and attached to this
fs_devices are also leaked.

Fix this by adding the newly allocated fs_devices to seed_list in the
degraded path, consistent with the normal path.

Fixes: 5f37583569442 ("Btrfs: move the missing device to its own fs device list")
Reported-by: syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eadd98df8bceb15d7fed
Tested-by: syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 316f099a0bcfe..c18918ce8edde 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7322,6 +7322,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 
 		fs_devices->seeding = true;
 		fs_devices->opened = 1;
+		list_add(&fs_devices->seed_list, &fs_info->fs_devices->seed_list);
 		return fs_devices;
 	}
 
-- 
2.51.0



