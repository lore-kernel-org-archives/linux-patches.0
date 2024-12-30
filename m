Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2850515E8B;
	Mon, 30 Dec 2024 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573681; cv=none; b=o6i5VtpNPMlzrgjmav1f/eF1b5QeF7qGw9l5fGZoRV5yvVZFUkE0BJXsvN5guP1EbqPAayFIo3R166U2G6SfhNPSIfsA74QkkeJQw/82auzdUl9wLqwBtp+l9uZZ0AvGKOelUG1lV2lAq4RB/Hu9ub0MrGmagydhWnY6ba7rihY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573681; c=relaxed/simple;
	bh=ubCB6IjGZCMb1jj36pci88VWET6AkTAhd0Cq0o4fGtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEc0mhy2okEva8zLyP9bVV054d34xWVMpoJXnXWi1MH/8HyiIDpod2MmsY7xKSUhfhaq7kcBRVFfaFLLSEZUYACTh2DtKVCNQ2AhtiNFWSDDQX9qNn4yxi0qzL69C8jIym/1DOn9Lq9N73iJVbqqHKoRpPx6hIPKSgZv6dH0vX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YM6haPmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YM6haPmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DB6C4CED0;
	Mon, 30 Dec 2024 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573681;
	bh=ubCB6IjGZCMb1jj36pci88VWET6AkTAhd0Cq0o4fGtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM6haPmyqSPDg42OZWcLjKIsu9+3Pprtwl/1snrfSTytT1bPT2qayIuS4NXHWjfxp
	 sKUBxutyv/k6BoOgm7SSq/9sOifPnJAPFN2F00DHFQjY+P+qG2vV88BoA6hkUt184k
	 2ZVzcx2pANDSddvCKhaZR2tK2BM9goOPy827ieZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 56/60] btrfs: avoid monopolizing a core when activating a swap file
Date: Mon, 30 Dec 2024 16:43:06 +0100
Message-ID: <20241230154209.407802096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

During swap activation we iterate over the extents of a file and we can
have many thousands of them, so we can end up in a busy loop monopolizing
a core. Avoid this by doing a voluntary reschedule after processing each
extent.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7387,6 +7387,8 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
+
+		cond_resched();
 	}
 
 	if (orig_start)


