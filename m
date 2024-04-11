Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E9D657AE;
	Thu, 11 Apr 2024 10:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831592; cv=none; b=kaP11fGcZTUMtOoXg9VV2HVeeWucNfX6IG7Dpoj7T8bWluCb0iDo9HFxKdEDgYN4m4xFbJZ5GcKvdRHO9HGDzaoksIcBX1afBm9D2UdIv4oHLoeh+FzJdLxVhbtdw9Ow2MyCc3JsJ0cp+FYMaGKl69WJW4RqjKyN9PnYe3zenC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831592; c=relaxed/simple;
	bh=CcUoDzSQ9p6UGeVPxZLgD/34HJ4S2Ois12oP9Z3Jj64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5FZ1BmLK0ZmRxdplk8KYno/rx7ebkhY/gsAM02TAQ5Vvcrk625JmxAqhInY/6nrVw/iAJRYZT6hPhj4oalPdLHp9W+WC6ran4RcsKpyh2YjBPVsQz99/f3vQJvd+nSIlTNN824FVAry3WN9KkMoc+vLgQ6bZP0CLf61RLRnw4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtZaB/VJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtZaB/VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BA3C433C7;
	Thu, 11 Apr 2024 10:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831591;
	bh=CcUoDzSQ9p6UGeVPxZLgD/34HJ4S2Ois12oP9Z3Jj64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtZaB/VJp2wLfv8vyeU0a9WUluZBubdl0WTza5Q8kG1qRk2JmziYQWN5fopRjGauQ
	 jOjJi96n9yK0uSb1hmNE8ADFyU9BwD0CZG0nTdL0F7U0U273LUptyTL50HzIqdQydn
	 5eAO0vHroEodWwWgpTJwEdDq1iCZ0Lq3yLEu3HhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lyakas <alex.lyakas@zadara.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/294] btrfs: fix off-by-one chunk length calculation at contains_pending_extent()
Date: Thu, 11 Apr 2024 11:53:41 +0200
Message-ID: <20240411095437.386361011@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ae6bd7f9b46a29af52ebfac25d395757e2031d0d ]

At contains_pending_extent() the value of the end offset of a chunk we
found in the device's allocation state io tree is inclusive, so when
we calculate the length we pass to the in_range() macro, we must sum
1 to the expression "physical_end - physical_offset".

In practice the wrong calculation should be harmless as chunks sizes
are never 1 byte and we should never have 1 byte ranges of unallocated
space. Nevertheless fix the wrong calculation.

Reported-by: Alex Lyakas <alex.lyakas@zadara.com>
Link: https://lore.kernel.org/linux-btrfs/CAOcd+r30e-f4R-5x-S7sV22RJPe7+pgwherA6xqN2_qe7o4XTg@mail.gmail.com/
Fixes: 1c11b63eff2a ("btrfs: replace pending/pinned chunks lists with io tree")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index eaf5cd043dace..9a05313c69f33 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1471,7 +1471,7 @@ static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
 
 		if (in_range(physical_start, *start, len) ||
 		    in_range(*start, physical_start,
-			     physical_end - physical_start)) {
+			     physical_end + 1 - physical_start)) {
 			*start = physical_end + 1;
 			return true;
 		}
-- 
2.43.0



