Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AA45208C6;
	Wed, 30 Sep 2026 17:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790325; cv=none; b=Q48sasMX0S0b2oLwRsa0Ucilm95ZkIKHzdUwiJYnIk+guQnf64COUWv7w/KX9WAIUh/Kfnjcj3O5cx81rAm4//Qet1I1tzVzDK7Q53sxtPbKrHe7J6FiO5IxD7kpwDD2Q2L1cB8IzhvHfxBjSrAN7pLscq3Cxd0MOjxcaO5+VhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790325; c=relaxed/simple;
	bh=u8KMitK/wy6s3QkfM76EVVO3IFpBEsIalzm6tfjcRqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4BKofy3v3Ob7fHBDj9CqRGiwNZjgh9wOXF73Li6KQDUhxIEsNzltfkGb42OTdmMIaYkKnpYrzm3XHMr/q8RpkFme0ft3PUN4b8OE9H6jKPFa241nYo4SLogKi/+fg+eDVoWQaszmKz+23LJw/121yiEAWHrTO2GyLdMYEGyE9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qohxOk/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qohxOk/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF81B1F000FF;
	Wed, 30 Sep 2026 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790324;
	bh=GqWE/QSdQEaoKLF1PTFMTJjCn4lSK0vXqj/9EAcRUb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qohxOk/nliLbFVLO7lpBeUC5ppI84N0UicchC2vf01OhbrdpEVmxf6l0x/MsWX1jU
	 J/ItuY2MMPDYKi8GCEbE+Vos2+UDtavC1lcApxYxCVP9E78gCUt9XshB9QWhVNT0wc
	 4C9yvDci35egqg8GUgu2rBm+8uxsMZ8z5psDIpUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 790/877] btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()
Date: Wed, 30 Sep 2026 17:28:21 +0200
Message-ID: <20260930152431.761834481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 0594e3423f4ba3137c734371169491f9a98e9af4 ]

mark_block_group_to_copy() iterates over the commit root with
skip_locking=true. A concurrent transaction commit can swap and free
the commit root during iteration, causing use-after-free when
accessing extent buffers.

Fix it by using path->need_commit_sem to protect the commit root search.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
CC: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ changed path->need_commit_sem assignment from true to 1 to match the older unsigned bitfield representation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -505,6 +505,7 @@ static int mark_block_group_to_copy(stru
 	path->reada = READA_FORWARD;
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
+	path->need_commit_sem = 1;
 
 	key.objectid = src_dev->devid;
 	key.type = BTRFS_DEV_EXTENT_KEY;


