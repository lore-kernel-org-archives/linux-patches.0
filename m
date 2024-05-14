Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83AB12CD8A;
	Tue, 14 May 2024 11:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686631; cv=none; b=V990L+vYriRtAFWGjVGmWYJu5BBWKfgscwsw5DATH+29d6j72UyakG7cGCsptHz/KPuQUTCXyfmKZorsqvSH7PZm1qZkBm7eCoYlVY2TjJ+MOJOwsKQy21qgKVU+teyJs11EPzKHDeH8sV7u5cYdOgjgIJQsG2X9xfERmkO/crI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686631; c=relaxed/simple;
	bh=7JDISL7m3VNFZ3ufq3I1FZBFtn5K7y5+FUAFYxIvKl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVnK04q4gKSIbmvdYk8Mck8lBlX7BTslg7uIbdtnxlL+I4mJ5x26bX/CXvbeu2z0FTQPPc4kG3qHvy5KfJORML+Rjxbz5hqfvSdWmp1SCqIBURp0J52r5n60lmSPgYdbv54seBPPE6JirpFq76fxuAePh6S8X46AyWqbCJ2rPlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQfrfCJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQfrfCJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C150C2BD10;
	Tue, 14 May 2024 11:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686630;
	bh=7JDISL7m3VNFZ3ufq3I1FZBFtn5K7y5+FUAFYxIvKl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQfrfCJr4Qna79Nof9PLkivlE/HA4KikvMk0zWm1fTYmx1yACcr4IAyXdzFyoyQub
	 G7NdPCQ+oACYD7k7Ju80PfDp50IjzjBg8Yxv4Q1fn5aHL59ZtBEZIQm51wRGW3qtka
	 TBfFskk/KN0p7PFV0MKxtX3inBXZ1TmR1F8TEjSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 204/236] btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()
Date: Tue, 14 May 2024 12:19:26 +0200
Message-ID: <20240514101028.108043084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 9af503d91298c3f2945e73703f0e00995be08c30 upstream.

The previous patch that replaced BUG_ON by error handling forgot to
unlock the mutex in the error path.

Link: https://lore.kernel.org/all/Zh%2fHpAGFqa7YAFuM@duo.ucw.cz
Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 7411055db5ce ("btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()")
CC: stable@vger.kernel.org
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3397,6 +3397,7 @@ again:
 			 * alignment and size).
 			 */
 			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->reclaim_bgs_lock);
 			goto error;
 		}
 


