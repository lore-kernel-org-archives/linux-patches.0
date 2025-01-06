Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B1678F49;
	Mon,  6 Jan 2025 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177846; cv=none; b=VaJ2AVxiXbhKldEsd7LzoBC6sCD/bddsKlwRHLv6Hsq0uV68jGHlN18RJOwrXfahYoMA/BPrSLbHJj3sEXoU/NukhXrfoZ4bhMed/OTYc1c/06dg59uADF66iInPMBAZ34fGcOHQirxQuasGRHGJnuNPEqirlV54jmY+/0YMEiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177846; c=relaxed/simple;
	bh=3cmcdDMq+GySF4sHexG8P8qpmb9u/OUwY67hlWki5cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSRQ+6zZe++4UeXJZSegXOGFSf/PQCV1+cANEE1fF37FOOeGm4hmRg4qoG/SFcifWYEfFY9RCkrHomN60diBTdq86zvxHCb3ADuqCPwYcQWqjvzIdE4P+x5KPMNSFDXIs4uXUxgcnMcmdt8RCSOeGBxVdgZzBpa1TVHv7mzb/pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7j9ruW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7j9ruW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C1DC4CEDF;
	Mon,  6 Jan 2025 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177846;
	bh=3cmcdDMq+GySF4sHexG8P8qpmb9u/OUwY67hlWki5cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7j9ruW+An6wQ75LHP6UyNDUEzorlnWs7VnZ4v6PR6F76Ky49osJksFYSV7FoXSi3
	 xNhp1hBDR6OudSYWExNpW8touTwC3CEx3Iw5cV3iQXNTDZxUFCaXLiTfP65ZgE+aAn
	 bYUaLJNHJveFUJrP2HFGtHKLnpia+1jSNA2XvIAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/156] btrfs: allow swap activation to be interruptible
Date: Mon,  6 Jan 2025 16:16:02 +0100
Message-ID: <20250106151144.595319521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9a45022a0efadd99bcc58f7f1cc2b6fb3b808c40 ]

During swap activation we iterate over the extents of a file, then do
several checks for each extent, some of which may take some significant
time such as checking if an extent is shared. Since a file can have
many thousands of extents, this can be a very slow operation and it's
currently not interruptible. I had a bug during development of a previous
patch that resulted in an infinite loop when iterating the extents, so
a core was busy looping and I couldn't cancel the operation, which is very
annoying and requires a reboot. So make the loop interruptible by checking
for fatal signals at the end of each iteration and stopping immediately if
there is one.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b3e256e0d0b..b5cfb85af937 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10056,6 +10056,11 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 			bsi.block_start = physical_block_start;
 			bsi.block_len = len;
 		}
+
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
 	}
 
 	if (bsi.block_len)
-- 
2.39.5



