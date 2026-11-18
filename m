Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061467;
	b=t2H11aDNVRvYVBhWeGBL7i4hiRZzE5WHTZp8+1azGIDMHZHg1XlWiorZUURNi/nSg87x
	 QA361LJkPmb+2PaNw/6AxSW4477fboHwyy5ileJTTp5dFaqYwKTOydetW4vjCCXKcG9UF
	 n0UEvqsQ+AqrvB+ygbP/qdPl4XExkD3SrZcfeeuf4k1pJ2bTdBCuRUR17wlnZ4Fw5EgQv
	 U6IvlUxZcS8iipxdMGW7gJ6wuZNof2UTlelU4mrSL06uhrO4r6c+2wyVHGCq9auqTNLkC
	 1Lns++/aWlHxoriZARPL39V/H7jKodbKhzCpXjKd3v2PIXM0JDYEtb1m8De9fKeZKxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37TPUnRqJOA9XCMbShIMvSdXHm6CpoCAIgXV1hhgN6k=;
	b=K8mnAH3EpMmE/9qzOqeOqXwz3okLo1ldvpqWw5141mRfgTa1Irk34eFx04Xp+C1ioZUJ
	 ocF1VB1tKmi3cMRW7YwMaojUE3CLWh/+z1gG+teQewlcjKLO0ctjyoJktuHIx8iv1296B
	 jVA2oURVQfiXkuf7DX6xmZpYzHCYNRBxUugF9nuTwIsziuYcvJ9BHsvUkcE3fVF1vXDZX
	 dnpLswDYn89iXQrtTRFZxXhims/+WBrAUkyCH/hlwLJa/iD0d2duZVJ8dfekpTDBR7e10
	 JWY6FQklkbUcT2R6GtmGIVlcMNzPHnplvRgnHL1oFsPY/hVu4t+KUPnl7/bq88WTSiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ihv+h50G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B933A606A330;
	Thu, 19 Nov 2026 04:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ihv+h50G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153461F000C4;
	Thu, 19 Nov 2026 04:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061467;
	bh=37TPUnRqJOA9XCMbShIMvSdXHm6CpoCAIgXV1hhgN6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ihv+h50G488syOwGEz1zlBfP66iJ/dymfdzejGwLnmlZQgmwjbd52NL6KVg6Vilxz
	 AYwY3QIR41vpk4nL0toLzISe6hRjjrmOwEyzQcJ/WZyEIpRZtJsdty5IcSVq8kVlJb
	 OCQPlULwlZ9QVbFqBCmLaNxjhbfsUcBYi+ztppwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	c.f.a@posteo.de,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1564/1848] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Wed, 18 Nov 2026 16:00:02 +0100
Message-ID: <20261118150025.064771992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a252f6cca0027..d6ec4f6cee926 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1661,7 +1661,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.53.0



