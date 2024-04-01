Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6459522301;
	Mon,  1 Apr 2024 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986829; cv=none; b=ACrU0k9hg8k9LXSupPZvEnejW3M5R2HAF7EerskoLXAvzmnigaQF20oy2ikI9H7FdqPSLbpkB22p//znnaTEMmlVOQRgkx9LyCl9uB1XSZOaZqDDgACk1ALz6YJWRLcLpGUoirBulXCFcomxSugibw8EsMVLYIwDa6GufEv7JK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986829; c=relaxed/simple;
	bh=ALHDozNPbNXIxYEO/kl+4a3+dokEavWbitSDc0cIfRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmi2p0cHRezYD1koCqjTPMjZSOUI/wuiBDgVJcVhMXGIeeNSlFhtysNYm2Z8IxyzBZJH/3KHNU0TtQ8L/BHMVW7dnAUNEsvH80DIrzz8ctyRQn8rWrPZxL6aeKE3fc8n2Jceun6aWXI1rAawYMHd2sFq8ysJUT/AP2mGzTx79xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2At9xlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2At9xlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BBAC43390;
	Mon,  1 Apr 2024 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986828;
	bh=ALHDozNPbNXIxYEO/kl+4a3+dokEavWbitSDc0cIfRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2At9xlUI3BvrdwADN307EBf+y3C/PtEc3BwictLvUTwXz0JNEKTNgU594p85ZMGC
	 +r+xvCLjo8VML3Kh7xPPCUQXXGqhhL9zT5fTKuFIqfDFqDU/JAogyH5MqWXTBfWy8U
	 tlqmffj5U0AX7NLn93wlMcuaP4EzJ9F4GLOTU9jI=
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
Subject: [PATCH 6.8 097/399] btrfs: fix off-by-one chunk length calculation at contains_pending_extent()
Date: Mon,  1 Apr 2024 17:41:03 +0200
Message-ID: <20240401152552.079856646@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d67785be2c778..d852d94d51c00 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1403,7 +1403,7 @@ static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
 
 		if (in_range(physical_start, *start, len) ||
 		    in_range(*start, physical_start,
-			     physical_end - physical_start)) {
+			     physical_end + 1 - physical_start)) {
 			*start = physical_end + 1;
 			return true;
 		}
-- 
2.43.0



