Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD67B350A2A;
	Tue, 21 Oct 2025 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076708; cv=none; b=dvGvC2b/EjE/BWZM9EFGgQE5rGSDLrfkmGpL+ueATcwCZn+vLJFjIFSgaUwwniyfHJ2uX4UQIygjP5OaIpgOeEqMIGCGvKZGfHhaw4B4PXj723vKqcZplPgM684LzyldarF6iPy5SVkrhjp6w0OFn/G2Zk5+R+ahxizciPV9Rno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076708; c=relaxed/simple;
	bh=amUU4/LKaAvwhokRxAg0ANQkLryV1tWVL0IzREJj5Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iT9LYpN7joY+h+JZ+KyfpMPurLYWe4W1JGXMbhM9PvTfHm+fs18outXNpSi0ZzgShwKCQepdinc4R1VpEZVv+NT3K8BJhvWIWVkhJzJaNPg65+kMj86YZjjplyhhsvEIu4kKJaBG9fYPZgex/ubtH1TWiL00qAcDtOV7rRoOuTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6u1Mmqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6u1Mmqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105FBC4CEF1;
	Tue, 21 Oct 2025 19:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076708;
	bh=amUU4/LKaAvwhokRxAg0ANQkLryV1tWVL0IzREJj5Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6u1Mmqozi1SP3FBUmBIhMtwM80cgk0cnXnYjkN3UksC7P1BcBvXNWkw8C0zuJxrD
	 OtqNxfcW1m58f3OvUzjmEbv9P+3JBbtGG71VBcBoPkBYZpYMR1d6yqn5ZHq/tTSgsf
	 2/oVbVs/s+WChZbe4hKxqftTGVrdZqYV7BbwlHcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 014/136] btrfs: fix memory leaks when rejecting a non SINGLE data profile without an RST
Date: Tue, 21 Oct 2025 21:50:02 +0200
Message-ID: <20251021195036.311882431@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Miquel Sabaté Solà <mssola@mssola.com>

commit fec9b9d3ced39f16be8d7afdf81f4dd2653da319 upstream.

At the end of btrfs_load_block_group_zone_info() the first thing we do
is to ensure that if the mapping type is not a SINGLE one and there is
no RAID stripe tree, then we return early with an error.

Doing that, though, prevents the code from running the last calls from
this function which are about freeing memory allocated during its
run. Hence, in this case, instead of returning early, we set the ret
value and fall through the rest of the cleanup code.

Fixes: 5906333cc4af ("btrfs: zoned: don't skip block group profile checks on conventional zones")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1664,7 +1664,7 @@ out:
 	    !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
 			  btrfs_bg_type_to_raid_name(map->type));
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
 	if (cache->alloc_offset > cache->zone_capacity) {


