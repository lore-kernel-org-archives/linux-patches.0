Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F81C2356AB;
	Mon, 10 Mar 2025 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630476; cv=none; b=tCvOHs0jousjEckwv1XdxRgBQxCUCIJq7WGIovJxCzCbZ9SaRZf1jwlmoaZQUZrT72XxoDLVRTCrZ2Z5cJ9SsQsnHEB/1u4UETooKZPhKHadb3NVicshpuMRcnAIC+zmxoaTX0cTHsafzi+G++B/Gprh/0ldqkedmJ8tKcPMJM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630476; c=relaxed/simple;
	bh=chstK6hWzyllcsY2Qgph3DDyOVJI7nZnfvxNseeS2lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz28h84MVVXPFV4c4BItKEEdFRy7pJeywzTPlEmBQoaqtugMg8DWyjJqwIrxRYAb5zvUXfgIjbEbYqnAHdNihhft/3jIKxVMnj2VBspl54u8fAnZN91CZFSVq4IXfOAJCh1gPnlNaOdYAPRdxDujwQC0oRwGvFw+ELUpxLbGChA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMlDn+C9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMlDn+C9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEED2C4AF09;
	Mon, 10 Mar 2025 18:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630476;
	bh=chstK6hWzyllcsY2Qgph3DDyOVJI7nZnfvxNseeS2lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMlDn+C9dAs7MPoBxRxCtKzqixSqbAOoVnlVz/rxkC9jb3rz/DhPpwnmu7SjNlYlm
	 BBDfaA2sn0M+I8vmUJ0wvGDL/PCgAFpK5auH12vVig5dUn+XMpgDsquXabjaiTGkwg
	 3Skk8JMvaa8VpYEovw0ti1ne9gjgNsFrll/bkd2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 5.15 428/620] btrfs: avoid monopolizing a core when activating a swap file
Date: Mon, 10 Mar 2025 18:04:34 +0100
Message-ID: <20250310170602.491778053@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

This commit re-attempts the backport of the change to the linux-5.15.y
branch. Commit 214d92f0a465 ("btrfs: avoid monopolizing a core when
activating a swap file") on this branch was reverted.

During swap activation we iterate over the extents of a file and we can
have many thousands of them, so we can end up in a busy loop monopolizing
a core. Avoid this by doing a voluntary reschedule after processing each
extent.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -11031,6 +11031,8 @@ static int btrfs_swap_activate(struct sw
 		}
 
 		start += len;
+
+		cond_resched();
 	}
 
 	if (bsi.block_len)


