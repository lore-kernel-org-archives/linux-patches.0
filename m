Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A2533A006;
	Mon, 18 Aug 2025 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526344; cv=none; b=q/cybdcs64rlx+if1YgiJ9jEQA1I4AU51Mf4V/i+laE8oH7jGqREbOiU2NRJotFJBjVISYsyoBu/K4O0YskoLN516kVbxajfAfD8/TVTNysG+2fsE9+W1gWOv9kyiegQQ6pJUc82ygkKBW/GFZRULBEHS0Q34fBK8sj8JuwtAek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526344; c=relaxed/simple;
	bh=wL6tq3OwmkJs1GCPJyqku1Vi8xW431JbpKm5yZufLHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHUrmVKhI+dwhIQbcawo2gu9r2pi97TL5JFQedMkRkTz3SDaMM+3zhahUd/JXm4k0T0mnd9qqqeMjLi2qRY48lfxFLL/MLNDaxwyGA5JWUotfMLLNMqGQICFf/ikNyRqLg0FUfhMj9Tzs/ocG+Ifj93TU/zjHdAq/YunOWz0Uxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKisG82Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKisG82Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F739C4CEEB;
	Mon, 18 Aug 2025 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526344;
	bh=wL6tq3OwmkJs1GCPJyqku1Vi8xW431JbpKm5yZufLHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKisG82YGoZVPG2uxYa+BFMzBUJoCOC8PbYY2rYxQtMl1s1ueDgej5Xp9yxKNqb5c
	 IyYNWShJ6zUrFqrBXsBtS8ksP7Ppr+JbN20PIL881SID0qj+PNbt0/Bvb/++Q4dT40
	 +ow6AQDTlPmSAHS7C3/LbuajS437XK82zelXLz9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 529/570] btrfs: zoned: do not select metadata BG as finish target
Date: Mon, 18 Aug 2025 14:48:36 +0200
Message-ID: <20250818124526.244540547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 3a931e9b39c7ff8066657042f5f00d3b7e6ad315 upstream.

We call btrfs_zone_finish_one_bg() to zone finish one block group and make
room to activate another block group. Currently, we can choose a metadata
block group as a target. But, as we reserve an active metadata block group,
we no longer want to select a metadata block group. So, skip it in the
loop.

CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2651,7 +2651,7 @@ int btrfs_zone_finish_one_bg(struct btrf
 
 		spin_lock(&block_group->lock);
 		if (block_group->reserved || block_group->alloc_offset == 0 ||
-		    (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) ||
+		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
 			continue;


