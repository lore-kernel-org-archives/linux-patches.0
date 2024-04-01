Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DB1482DF;
	Mon,  1 Apr 2024 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990808; cv=none; b=RzmEMyFG30PFaTRn5GwN8iWNklau84ix9TlZ+L3Z9ECB3mr+9JM+MynEFY/hgP7jD+0XHxf7h4M9ayl/C4cNIoWmOvtaj3VRp9xafhmk2Mm6xtuXVb2LD6WKAmXcC/A8of1TkLu0skngxmzJBhXUZsUL6T1HKuEjp/WYS0RJHtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990808; c=relaxed/simple;
	bh=ZORA2BOmxMn91wopf6YwZSCVvLS3wef1RyW4J77QThI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9erqgKnLIBLh97sMOd+HC0Lx+OEKsGi8wqW83HHniHTDzr2nmxZvx+h+IQb80mTkICVRNYFdlqGPFasJYPgikxGlWSYBDjiIsd3egpKJ0C7u4Iym0i9xgPAPDR59qYohE/Dy0C8m/1eyMqPcyEoE6+QvRUGCJsW0mMlWS0iP1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOQkTWU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOQkTWU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899F6C43390;
	Mon,  1 Apr 2024 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990808;
	bh=ZORA2BOmxMn91wopf6YwZSCVvLS3wef1RyW4J77QThI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOQkTWU0v3sd2/JJkEWc+aB6X4mx0YFv5Ia9FM4qnSLzJpnG6CwwunuqLqZ7KFp85
	 Z3m2uug4wTHYGB5bmdeKL+s6Xq7tXQdjHUfxCm5PcLLBrDxnnZMrwx6xKZvTQP1ZWN
	 R//OTsQ93GB/+RHsDa/c2Ykz5JG5bZpd9EIrQBb0=
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
Subject: [PATCH 6.1 072/272] btrfs: fix off-by-one chunk length calculation at contains_pending_extent()
Date: Mon,  1 Apr 2024 17:44:22 +0200
Message-ID: <20240401152532.812688108@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6fc2d99270c18..03cfb425ea4ea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1444,7 +1444,7 @@ static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
 
 		if (in_range(physical_start, *start, len) ||
 		    in_range(*start, physical_start,
-			     physical_end - physical_start)) {
+			     physical_end + 1 - physical_start)) {
 			*start = physical_end + 1;
 			return true;
 		}
-- 
2.43.0



