Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C755200105;
	Thu, 13 Feb 2025 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460975; cv=none; b=Hq2G76rduQTSQu8XlyTyYcX9Dx8Y/P8aCu9ExCBeIP5pG0e7gV7b+XOQIcPj3N1JOQ6LJyg4gJEMBpqbo8qHEmhFobD7aXJfcr4QxEjZwlMet95McQiGhBo5B4GKI5vwbtsGPSS6estkXIDJf4leaNN1TCZqVogFzu/BJQACql4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460975; c=relaxed/simple;
	bh=2s/56Kj5jCsr9KQwdlNCnr3dfx4Muy3Q9sVIxlVUX8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Asp0Xj+zPAj3Mja/f7d/jXGxW7SVSH6Jh3BAco7B3xz5GCpq/VEBGpeyMRg3cpcwnZs9VOHNuaZaNEPxOuEL5mFkr0XnX3rIzGG3XuAHqf00LlyglQX1D1dvjA3MmZt7CH1yQEJjGkImja/zgqmcZazxhkKB74tLk11WlGWG5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYRyWm+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYRyWm+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC345C4CEE7;
	Thu, 13 Feb 2025 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460975;
	bh=2s/56Kj5jCsr9KQwdlNCnr3dfx4Muy3Q9sVIxlVUX8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYRyWm+6blKoGEy330isDvYxEbkCPfjBptbNWxDPhMZvV0ljnN2roXCpbyDpBv5MG
	 e2z0LYMLHagAm++xrrZEwLov/GjnnGrkffwGa1qXfFBGAJK2QvqUHTkATNIA9Dym+y
	 s4UJ5FVXVjn2EPwK6las1d3sQt+bQabGqdj8oh6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 6.6 265/273] btrfs: avoid monopolizing a core when activating a swap file
Date: Thu, 13 Feb 2025 15:30:37 +0100
Message-ID: <20250213142417.888505861@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

This commit re-attempts the backport of the change to the linux-6.6.y
branch. Commit 6e1a82259307 ("btrfs: avoid monopolizing a core when
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
@@ -10833,6 +10833,8 @@ static int btrfs_swap_activate(struct sw
 		}
 
 		start += len;
+
+		cond_resched();
 	}
 
 	if (bsi.block_len)


