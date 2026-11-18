Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026232;
	b=MDJ2kqQ54IFWUI4MacDbp3rPprLy8F8gmmvnGqlC20t/LmxBECm/44CV+7QfxwwUp27c
	 doqZTwGNMwzpNioJEf9F0hfO40UkKCc0k91jkbWdD0KCTv8W2a0xHJG9kgXZH98P6cJgg
	 UQ7f9Qjw13FmRYCMwCdicZhPWHzblIfPRcW5FXGWq/8VjOchrmg6C5Ry0xGxMG9qcRp8N
	 9L90e9QOe8eHuzECbErQhBkKS70vYNf8A61jinoDIJCRcC3nsgQ/bXCYaYbezd9yG1JGh
	 oqSAVVnsf2oZOlGIS+oYNdyBsMBX6+A3WXC1HV5q2JQaPU6E8aZR32KDSXQZkKsNBvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eqWwtmDOw4Im6C4NYlnZ3LL4ZDyfuoTETKwdOuwuwz8=;
	b=HK9pvu/veFIl6UNNENJ88VitBPHY9sBj8dEQOFU9YMID76zDjv4PA6g20ATd5uRGdfYj
	 G1dRmq3hoVFKJ8BUKiDfBvVbe9BeXfvguQggICskNX9EI9CN3whHGq7GiBN73jK/K2oXL
	 jBJs+154IBo5gYMpBwQMJr/uUHM9llJkiNbs9hF+5sFDvu5Voe+yQ88jxgSeiPTxXXDhz
	 NvWKrIUZNXzSh2c5eGUbiId7X5Wo+AhJL1khj7m2/u28vW/23I7nZJB272m4vmDvFQCL/
	 J7F4oSnDQ75WBD0UuJIzm6G+5bWeTYkqxtwXKkZaEXvVPQncsS8hEtx5EYRsiwSuVVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ml50TdjW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8412606A332;
	Wed, 18 Nov 2026 18:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ml50TdjW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239981F000CB;
	Wed, 18 Nov 2026 18:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026232;
	bh=eqWwtmDOw4Im6C4NYlnZ3LL4ZDyfuoTETKwdOuwuwz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ml50TdjW4hNQdu15YhrI4JYuVHD2PXlfqz3tAxyGjpfL+1AZhcrvyrfxtIjijxGAz
	 V6UQEPjIKifEh6XDb2eHnG7WhB9S5AkvHPHcsWpDVznakat/sKbTeoS9EbESvczlYC
	 Byn5ppvLPosLvIyyn6Cb74OZwzIvalUmf1f3/AR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	c.f.a@posteo.de,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1361/2151] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Wed, 18 Nov 2026 15:51:36 +0100
Message-ID: <20261118150211.606560338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit dd906477cc2c33c82ec17e6301bd4be4ea588565 ]

[BUG]
There is a bug report that when removing a child qgroup, if removing the
qgroup requires a rescan, it will delete the on-disk relation and qgroup
items but not the in-memory qgroup rb entry.

This makes all later qgroup rescan to fail.

[CAUSE]
The call chain looks like the following:

 btrfs_remove_qgroup()
 |- __del_qgroup_relation()
 |  |- quick_update_accounting()
 |     Which returns 1, showing this operation will require
 |     a qgroup rescan
 |- if (ret) goto out;
    Which skips the del_qgroup_rb() call, leaving the in-memory qgroup
    rb entry still intact.

Then later qgroup rescan/update will always fail and mark qgroup
inconsistent:

 btrfs_run_qgroups()
 |- update_qgroup_info_item()
 |  |- btrfs_search_slot()
 |     Which returns -ENOENT, as the qgroup info item is already
 |     deleted.
 |- qgroup_mark_inconsistent()
 |- return -ENOENT;

[FIX]
Do not treat "ret > 0" as an error.

Reported-by: c.f.a@posteo.de
Link: https://lore.kernel.org/linux-btrfs/14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de/
Fixes: 9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or mark INCONSISTENT flags when assigning/deleting a qgroup relations.")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 87eddd5a3ea7b..f87acc9966c0e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1851,7 +1851,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.53.0



