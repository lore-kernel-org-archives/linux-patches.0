Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41D73F23D5;
	Wed, 20 May 2026 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296679; cv=none; b=PSGrlRQH10MwVlAFVwd99s6k96d+PWinVmAX0Jt7+BWOnkCsZgkCuK4CbtCv9GpS6wqBjLyif4ZeysoQB1toBca6umNM9J/WKhjWaRENSGd5968N8fivsfkOXWuP1I1+wXgs/k+B4XXr0V2vAk1n94XxihwWmQoe+Wf1XJxVxNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296679; c=relaxed/simple;
	bh=EOJVdwzkDvjKXbcfeAubGkfJ8fkF49+YRndy3gN4Py0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql97W9jVn9iCUmkoo4UweuwQ8RdKcQDsTWIdJn0aGSJn6nop9wF3MZBSuSb3Y4kZgB2LFYSzv3ABHyCCpVdnzt+kB/HtaJteqO8YFdemqWo4r5zJBCRPOChyu7tx3/SWaaq9Fpye83k+wTrq+asSsbGNZRx2gXVypGc5+uCBZZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lt2Ohklh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lt2Ohklh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165C51F000E9;
	Wed, 20 May 2026 17:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296677;
	bh=sZ41VgyUhzw8Wg3/gzPO4jq9H79PEtZttW/nTwan6XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lt2Ohklhy8L4I30Eia2paKkraTV15/XK5rwX87digvr1J/ldiJ6eGjOFyTL1y03od
	 XmV+M3v8EYz6kouxtdOr0zg1sM6HG7y+EWKT9CdFWcaE8PdKkqUUln4V1qELOHoQtI
	 nuWIbOJpI8xWNoy5xO93FQ7csP2r64mHFFn7D/j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0890/1146] btrfs: fix bytes_may_use leak in do_remap_reloc_trans()
Date: Wed, 20 May 2026 18:19:00 +0200
Message-ID: <20260520162208.378544455@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 9b8824533d75fb199a3fb0f6147ffcca64b5caf8 ]

If the call to btrfs_reserve_extent() in do_remap_reloc_trans() returns
a smaller extent than we asked for, currently we're not undoing the
bytes_may_use change that we made. Fix this by calling
btrfs_space_info_update_bytes_may_use() again for the difference.

Fixes: fd6594b1446c ("btrfs: replace identity remaps with actual remaps when doing relocations")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6e260ccbf50ac..a6965abbab719 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5014,6 +5014,12 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 		return ret;
 	}
 
+	if (ins.offset < remap_length) {
+		spin_lock(&sinfo->lock);
+		btrfs_space_info_update_bytes_may_use(sinfo, ins.offset - remap_length);
+		spin_unlock(&sinfo->lock);
+	}
+
 	made_reservation = true;
 
 	new_addr = ins.objectid;
-- 
2.53.0



