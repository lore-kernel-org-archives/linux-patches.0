Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461C925E83F;
	Tue, 11 Mar 2025 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707196; cv=none; b=FYc/zpjhv4fUeWpFXgvjWn/+GzFvfSZmvmZNAKqJsEwZTmcdUFGqqAFgrUuVyQjqsHau7up2WeGfyuXUgs65MTP3dbjARiO7ZzZ5G2nE/G+quurJyTn9ZMnjfn1np9CoRLMS9lK1aO6h1q/G9LOV/fHswJ3zQFHMH8EGecB1VM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707196; c=relaxed/simple;
	bh=M7ESSOg2l71dFmYCm4838JO5hst2+PCvVJ8UykAyQeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJ0aMmwbAWWbav8CkX2Iq6ECtDDp+JqqveOMGtATKV5LcR2f2pJBtUWz+m/3UxDMXfynwl3tGe8M0IQ3WxeCM7jKnodJnHxh6e1Sh4HuBjsQ89TXx5w8guBh7bWz+MbojGSiQnaSQDNRbOorzLD+p85TUDCj6WW6zW7n1pgcy88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLjZHC4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLjZHC4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31BEC4CEE9;
	Tue, 11 Mar 2025 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707196;
	bh=M7ESSOg2l71dFmYCm4838JO5hst2+PCvVJ8UykAyQeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLjZHC4tqCNmuJhCLwe0wTAjTeKC6opVKwZlBUOtLgzbWubtKKl9P7zW/f52Zl0HP
	 47lxiLq40zCG+IorYovxzr0MwYbReE4QxQxCHI27VKRF44TeJqN3Ukon1bgFUEUuPR
	 zrpZci6HRLZzP26IU6zuHyEOEnA9g9y2UExXS8+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 5.10 306/462] btrfs: avoid monopolizing a core when activating a swap file
Date: Tue, 11 Mar 2025 15:59:32 +0100
Message-ID: <20250311145810.448583338@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

This commit re-attempts the backport of the change to the linux-5.10.y
branch. Commit a1c3a19446a4 ("btrfs: avoid monopolizing a core when
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
@@ -10422,6 +10422,8 @@ static int btrfs_swap_activate(struct sw
 		}
 
 		start += len;
+
+		cond_resched();
 	}
 
 	if (bsi.block_len)


